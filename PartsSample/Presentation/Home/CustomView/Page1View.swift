//
//  Page1View.swift
//  PartsSample
//

import UIKit
import SnapKit

protocol Page1ViewProtocol {
    func didTapDetailButton(carouselTag: Int)
}

fileprivate struct Const {
    static let contentsSpacing: CGFloat = 8
    static let contentsCornerRadius: CGFloat = 10
}

/// ページ１のビュー
class Page1View: UIView {
    
    // MARK: - private properties
    
    private let scrollView = UIScrollView()
    private let refreshControl = CustomRefreshControl()
    private let rootStackView = UIStackView()
    private let bannerView = BannerView()
    private let contentStackView = UIStackView()
    // コンテンツは最大６つまで（２列×３段）
    private let contentGroup0StackView = UIStackView()
    private let contentGroup1StackView = UIStackView()
    private let contentGroup2StackView = UIStackView()
    private var contents: [UIView] = []
    
    // MARK: - internal properties
    
    var delegate: Page1ViewProtocol?
    
    // MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func updateConstraints() {
        super.updateConstraints()
        layoutForSizeClass()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutForSizeClass()
    }
    
    // MARK: - internal methods
    
    /// カルーセルへのアイテムの設定を行う
    /// - Parameters:
    ///   - name: カルーセルのタイトル
    ///   - carouseSize: カルーセルのサイズ。縦横比で指定。大きいほど縦に対して横が短い。
    ///   - items: 表示アイテムの配列
    ///   - contentCategory: 表示する情報の種類
    func addCarousel(name: String, carouseSize: CarouselView.CarouseSize, items: [CarouselViewItem], contentCategory: ContentCategory) {
        let carouseView = CarouselView(title: name, size: carouseSize, tag: contentCategory.rawValue)
        carouseView.setItems(items)
        carouseView.delegate = self
        addContent(carouseView)
    }
    
    /// 動作確認用のビュー追加
    func addDebugView() {
        let debugView = DebugControllView()
        addContent(debugView)
        NSLayoutConstraint.activate([
            debugView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    /// リフレッシュコントロールの初期化（リフレッシュコントロール動作中は除く）
    func resetRefreshControl() {
        refreshControl.resetIfNotRefreshing()
    }
}

// MARK: - private

private extension Page1View {

    func addContent(_ contentView: UIView) {
        contents.append(contentView)
        
        var stackView: UIStackView?
        let group = (contents.count - 1) / 2
        switch group {
        case 0: stackView = contentGroup0StackView
        case 1: stackView = contentGroup1StackView
        case 2: stackView = contentGroup2StackView
        default:
            break
        }
        
        guard let groupStackView = stackView else { return }
        groupStackView.addArrangedSubview(contentView)
        
        let row = (contents.count - 1) % 2
        contentView.translatesAutoresizingMaskIntoConstraints = false
        if row == 0 {
            // 横レイアウトで左側
            NSLayoutConstraint.activate([
                contentView.leftAnchor.constraint(equalTo: groupStackView.leftAnchor),
            ])
        } else {
            // 横レイアウトで右側
            
            // 左側のビュー取得
            if let leftView = groupStackView.arrangedSubviews.first {
                NSLayoutConstraint.activate([
                    contentView.rightAnchor.constraint(equalTo: groupStackView.rightAnchor),
                    contentView.widthAnchor.constraint(equalTo: leftView.widthAnchor),
                ])
            }
        }
    }
    
    func layoutForSizeClass() {
        let collection = UITraitCollection(horizontalSizeClass: .regular)
        if traitCollection.containsTraits(in: collection) {
            // 横がレギュラーサイズの場合、コンテンツを２つずつ並べる
            contentGroup0StackView.axis = .horizontal
            contentGroup1StackView.axis = .horizontal
            contentGroup2StackView.axis = .horizontal
            
            bannerView.isHidden = true
        } else {
            // コンテンツは全て縦に並べる
            contentGroup0StackView.axis = .vertical
            contentGroup1StackView.axis = .vertical
            contentGroup2StackView.axis = .vertical

            bannerView.isHidden = false
        }
    }
    
    func setupView() {
        backgroundColor = R.color.background()
        // スクロール領域
        addSubview(scrollView)
        scrollView.backgroundColor = R.color.background()
        // リフレッシュコントロール
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.delegate = self
        // スクロール領域の中身のセットアップ
        scrollView.addSubview(rootStackView)
        rootStackView.backgroundColor = R.color.background()
        // キャンペーンバナー
        rootStackView.addArrangedSubview(bannerView)
        // カテゴリ別コンテンツ（縦３段）
        contentStackView.layer.cornerRadius = Const.contentsCornerRadius
        contentStackView.layer.masksToBounds = true
        contentStackView.backgroundColor = R.color.background()
        rootStackView.addArrangedSubview(contentStackView)
        // １段目
        contentStackView.addArrangedSubview(contentGroup0StackView)
        // ２段目
        contentStackView.addArrangedSubview(contentGroup1StackView)
        // ３段目
        contentStackView.addArrangedSubview(contentGroup2StackView)
    }
    
    func setupLayout() {
        // スクロール領域
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(safeAreaLayoutGuide)
        }
        
        // スクロール領域内の枠組み
        rootStackView.axis = .vertical
        rootStackView.alignment = .center
        // setCustomSpacing でスペースを調整するなら「equalSpacing」は使えない。
        rootStackView.distribution = .fill
        rootStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide).offset(Const.contentsSpacing)
            make.left.right.bottom.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        // キャンペーンバナー
        bannerView.snp.makeConstraints { make in
            make.left.right.equalTo(scrollView.contentLayoutGuide)
        }
        
        // ３段とりまとめスタックビュー
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.distribution = .equalSpacing
        contentStackView.spacing = Const.contentsSpacing
        contentStackView.snp.makeConstraints { make in
            make.left.equalTo(rootStackView).offset(Const.contentsSpacing / 2)
            make.right.equalTo(rootStackView).offset(-1 * Const.contentsSpacing / 2)
        }
        
        // コンテンツ１段目
        contentGroup0StackView.axis = .vertical
        contentGroup0StackView.alignment = .center
        contentGroup0StackView.distribution = .equalSpacing
        contentGroup0StackView.spacing = Const.contentsSpacing
        contentGroup0StackView.snp.makeConstraints { make in
            make.left.right.equalTo(contentStackView)
        }
        
        // コンテンツ２段目
        contentGroup1StackView.axis = .vertical
        contentGroup1StackView.alignment = .center
        contentGroup1StackView.distribution = .equalSpacing
        contentGroup1StackView.spacing = Const.contentsSpacing
        contentGroup1StackView.snp.makeConstraints { make in
            make.left.right.equalTo(contentStackView)
        }
        
        // コンテンツ３段目
        contentGroup2StackView.axis = .vertical
        contentGroup2StackView.alignment = .center
        contentGroup2StackView.distribution = .equalSpacing
        contentGroup2StackView.spacing = Const.contentsSpacing
        contentGroup2StackView.snp.makeConstraints { make in
            make.left.right.equalTo(contentStackView)
        }

        rootStackView.setCustomSpacing(Const.contentsSpacing, after: bannerView)
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        // TODO: 動作確認用ダミーウェイト
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UIScrollViewDelegate

extension Page1View: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // リフレッシュコントロールのアニメーションを更新する
        refreshControl.updateProgress(with: scrollView.contentOffset.y)
    }
}

// MARK: - CarouselViewProtocol

extension Page1View: CarouselViewProtocol{
    func didTapDetailButton(carouselTag: Int) {
        delegate?.didTapDetailButton(carouselTag: carouselTag)
    }
}
