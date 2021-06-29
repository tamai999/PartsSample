//
//  AllImageView.swift
//  PartsSample
//

import UIKit

protocol AllImageViewDelegate {
    func didTapImageCell(indexPath: IndexPath)
}

fileprivate struct Const {
    // レイアウト
    static let horizontalMargin: CGFloat = 16
    static let headerHeight: CGFloat = 50
    static let scrollHandleWidth: CGFloat = 30
    static let scrollHandleHeight: CGFloat = 50
    static let scrollHandleRightPosition: CGFloat = 40
    static let scrollHandleCornerRadius: CGFloat = 15
    // セルのアスペクト比(height/width)
    static let cellAspectRatio: CGFloat = 1.2
    
    static let cellReuseIdentifier = "CellIdentifier"
    static let headerReuseIdentifier = "HeaderIdentifier"
}

// ピンチジェスチャで画像の数を増減するためのルール定義
private enum CellHorizontalCount: Int {
    case wide = 2, middle = 4, narrow = 8, superNarrow = 16
    
    func next(isZoom: Bool, isRegularSize: Bool) -> CellHorizontalCount {
        switch self {
        case .wide:
            return isZoom ? .wide : .middle
        case .middle:
            if isRegularSize {
                // レギュラーサイズはwide不可
                return isZoom ? .middle : .narrow
            } else {
                return isZoom ? .wide : .narrow
            }
        case .narrow:
            if isRegularSize {
                // レギュラーサイズは superNarrow まで許可
                return isZoom ? .middle : .superNarrow
            } else {
                return isZoom ? .middle : .narrow
            }
        case .superNarrow:
            return isZoom ? .narrow : .superNarrow
        }
    }
}

class AllImageView: UIView {
    
    // MARK: - private properties
    
    private weak var scrollHandleView: UIView!

    private var imageLists: [(title: String, items: [ImageItem])] = []
    private var scrollHandleHideTask: DispatchWorkItem?
    
    private var zoomingStatus: UIPinchGestureRecognizer.ZoomStatus = .zoomIn
    private var pinchGesture: UIPinchGestureRecognizer?
    private var transitionLayout: UICollectionViewTransitionLayout?
    private var currentCellHorizontalCount: CellHorizontalCount = .middle
    private var nextCellHorizontalCount: CellHorizontalCount?
    
    // MARK: - internal properties

    weak var collectionView: UICollectionView!

    // 選択モード
    public var isSelectMode = false {
        didSet {
            collectionView.reloadData()
        }
    }
    // イベント通知用
    var delegate: AllImageViewDelegate?
    
    // MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // レイアウトが変わったらスクロールハンドルは一旦、非表示にする
        scrollHandleView.isHidden = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // 横に並べるセルのサイズを決める
        if traitCollection.horizontalSizeClass == .regular {
            currentCellHorizontalCount = .narrow
        } else {
            currentCellHorizontalCount = .middle
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == scrollHandleView {
            // スクロールする量を決めるため、まず、ビュー内のスクロール率を求める
            // タップ位置の基点はビューのトップとする
            let locationY = touch.location(in: self).y - safeAreaInsets.top
            // スクロール範囲はビューの高さからセーフエリアとハンドルの高さを除いた範囲
            let viewSize = bounds.height - safeAreaInsets.top - Const.scrollHandleHeight - safeAreaInsets.bottom
            var ratio = locationY / viewSize
            ratio = min(max(ratio, 0.0), 1.0)
            
            // コンテンツ全体の高さを求める
            let scrollSize = collectionView.contentSize.height
                - bounds.height         // ビューの高さを引く
                + safeAreaInsets.top    // セーフエリアの上部部分を足す（スクロール領域に加わっているため）
                + safeAreaInsets.bottom // セーフエリアの下部を足す（スクロール領域に加わっているため）

            // コンテンツの位置を決定
            collectionView.contentOffset.y = scrollSize * ratio
            
            // contentOffsetを直接指定した場合、scrollViewDidScroll() は呼び出されるが、
            // スクロールの終了はハンドリングできないので、タイマーでハンドルを非表示にする処理をキック。
            // すでに非表示に移行中ならキャンセルしておく。
            scrollHandleHideTask?.cancel()
            hideScrollHandleView()
        }
    }
    
    // MARK: - internal methods
    
    func setItemLists(_ itemLists: [(String, [ImageItem])]) {
        self.imageLists = itemLists
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func showScrollHandleView(contentHeightRatio: CGFloat) {
        scrollHandleView.isHidden = false

        setScrollHandlePosition(contentHeightRatio: contentHeightRatio)
    }
    
    func setScrollHandlePosition(contentHeightRatio: CGFloat) {
        // ハンドルが非表示に移行中ならキャンセルする
        scrollHandleHideTask?.cancel()
        
        let size = bounds.height - safeAreaInsets.top - safeAreaInsets.bottom - Const.scrollHandleHeight
        let scrollViewY = size * contentHeightRatio + safeAreaInsets.top
        let scrollViewX = collectionView.frame.origin.x + collectionView.frame.width - Const.scrollHandleRightPosition
        scrollHandleView.frame.origin = CGPoint(x: scrollViewX, y: scrollViewY)
    }
    
    func hideScrollHandleView() {
        if let hideTask = scrollHandleHideTask, !hideTask.isCancelled {
            // 非同期移行中なら新たな移行処理は開始しない
            return
        }

        let dispatchWorkItem = DispatchWorkItem {
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.scrollHandleView.alpha = 0.0
                           },
                           completion: { _ in
                            self.scrollHandleView.isHidden = true
                            self.scrollHandleView.alpha = 1.0
                           })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: dispatchWorkItem)
        scrollHandleHideTask = dispatchWorkItem
    }
}

// MARK: - private

private extension AllImageView {
    func setupViews() {
        // 背景色
        backgroundColor = R.color.background()

        // 画像一覧
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = R.color.background()
        collectionView.delegate = self
        collectionView.dataSource = self
        // スクロールバーはカスタムするのでデフォルトはオフ
        collectionView.showsVerticalScrollIndicator = false
        addSubview(collectionView)
        self.collectionView = collectionView
        
        // 画像セル
        collectionView.register(ImageItemCellView.self, forCellWithReuseIdentifier: Const.cellReuseIdentifier)
        
        // ヘッダーセル
        collectionView.register(AllImageHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: Const.headerReuseIdentifier)
        
        // スクロールハンドル
        let scrollHandleView = UIView()
        scrollHandleView.backgroundColor = .green
        scrollHandleView.bounds = CGRect(x: 0, y: 0, width: Const.scrollHandleWidth, height: Const.scrollHandleHeight)
        scrollHandleView.layer.cornerRadius = Const.scrollHandleCornerRadius
        scrollHandleView.isUserInteractionEnabled = true
        scrollHandleView.isHidden = true    // 非表示にしておく
        addSubview(scrollHandleView)
        self.scrollHandleView = scrollHandleView
        // 画像一覧の画像サイズ変更のためのピンチジェスチャ
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(gesture:)))
        collectionView.addGestureRecognizer(pinchGesture)
        self.pinchGesture = pinchGesture
    }
    
    func layoutViews() {
        // 画像一覧
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc
    func pinchGesture(gesture: UIPinchGestureRecognizer) {
        
        switch(gesture.state){
        case .began:
            // ピンチ操作を開始した時点で、拡大なのか縮小なのか、どちらの操作なのか決めて、ピンチ操作が完了するまでその状態を確認できるようにする
            zoomingStatus = gesture.zoomStatus
            
            // 次のセルサイズを決める
            if traitCollection.horizontalSizeClass == .regular {
                nextCellHorizontalCount = currentCellHorizontalCount.next(isZoom: zoomingStatus == .zoomIn,
                                                isRegularSize: true)
            } else {
                nextCellHorizontalCount = currentCellHorizontalCount.next(isZoom: zoomingStatus == .zoomIn,
                                                isRegularSize: false)
            }
            
            // Transitionする先のLayoutを用意
            let nextLayout = UICollectionViewFlowLayout()            
            // Transitionの開始
            collectionView.startInteractiveTransition(to: nextLayout) { completed, finish in
                self.pinchGesture?.isEnabled = true
                self.nextCellHorizontalCount = nil
            }
            
        case .changed:
            // Transitionの進捗(progress)を0.0〜1.0で更新
            guard let layout = collectionView.collectionViewLayout as? UICollectionViewTransitionLayout else { return }
            layout.transitionProgress = gesture.transitionProgress(zoomStatus: zoomingStatus)
            
        case .ended:
            // Transitionを完了
            guard let layout = collectionView.collectionViewLayout as? UICollectionViewTransitionLayout else { return }

            if layout.transitionProgress > 0.5 {
                collectionView.finishInteractiveTransition()

                if let next = nextCellHorizontalCount {
                    currentCellHorizontalCount = next
                    nextCellHorizontalCount = nil
                }
            } else {
                nextCellHorizontalCount = nil
                collectionView.cancelInteractiveTransition()
            }
            
            // 最後のアニメーションが終わるまでジェスチャーを停止
            pinchGesture?.isEnabled = false
        default:
            break;
        }
    }
}

// MARK: - UICollectionViewDelegate

extension AllImageView: UICollectionViewDelegate {
    // MARK: - スクロール検知処理
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        showScrollHandleView(contentHeightRatio: getScrollRatio(scrollView: scrollView))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !scrollHandleView.isHidden {
            // ハンドルが表示されている時だけ移動量を通知する
            setScrollHandlePosition(contentHeightRatio: getScrollRatio(scrollView: scrollView))
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            // 完成スクロールしていなければスクロール終了
            hideScrollHandleView()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        hideScrollHandleView()
    }
    
    private func getScrollRatio(scrollView: UIScrollView) -> CGFloat {
        // セーフエリアのインセットを含めて計算しないと合わない。
        let contentSize = safeAreaInsets.top + scrollView.contentSize.height - self.bounds.height + self.safeAreaInsets.bottom
        let contentOffset = scrollView.contentOffset.y
        
        let ratio = contentOffset / contentSize
        return ratio
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt section[\(indexPath.section)] index [\(indexPath.row)]")
        if !isSelectMode {
            delegate?.didTapImageCell(indexPath: indexPath)
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ImageItemCellView else {
                return
            }
            
            cell.isChecked = !cell.isChecked
        }
    }
}

// MARK: - UICollectionViewDataSource

extension AllImageView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return imageLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageLists[section].items.count
    }
    
    // MARK: - セルのセットアップ
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.cellReuseIdentifier, for: indexPath)
        if let cell = cell as? ImageItemCellView {
            let item = imageLists[indexPath.section].items[indexPath.row]
            cell.setupCell(image: item.image, price: item.price, isSelectMode: isSelectMode)
        }
        
        return cell
    }
    
    // MARK: - ヘッダーのセットアップ

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader,
           let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Const.headerReuseIdentifier, for: indexPath) as? AllImageHeaderView {
            // セクションのラベル設定
            let title = imageLists[indexPath.section].title
            header.setTitle(title)
            return header
        }
        
        return AllImageHeaderView()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AllImageView: UICollectionViewDelegateFlowLayout {
    
    // MARK: - セルのレイアウト
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 横に並べるセルの数を取得
        let cellHorizontalCount: Int
        if let next = nextCellHorizontalCount {
            cellHorizontalCount = next.rawValue
        } else {
            cellHorizontalCount = currentCellHorizontalCount.rawValue
        }
        
        // 横に並べるセルの数が一定になるようにセルサイズを計算する
        var cellWidth = collectionView.frame.width - (Const.horizontalMargin * 2)
        cellWidth /= CGFloat(cellHorizontalCount)
        let cellHeight = cellWidth * Const.cellAspectRatio
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 縦方向のセル間のスペースはなし
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // 横方向のセル間のスペースはなし
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // 左右に余白を設けておく
        return UIEdgeInsets(top: 0, left: Const.horizontalMargin, bottom: 0, right: Const.horizontalMargin)
    }
    
    // MARK: - ヘッダーのレイアウト
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: bounds.width, height: Const.headerHeight)
    }
}
