//
//  Page4ViewController.swift
//  PartsSample
//

import UIKit
import SnapKit

fileprivate struct Const {
    static let sectionSideMargin: CGFloat = 20.0
    static let sectionTopMargin: CGFloat = 4.0
    static let sectionBottomMargin: CGFloat = 4.0
    static let minimumInteritemSpacing: CGFloat = 2.0

    static let headerHeight: CGFloat = 60.0
    
    static let cellMinimumWidth: CGFloat = 200.0
    static let cellHeight: CGFloat = 50.0
}

class Page4ViewController: PageViewController {
    
    // MARK: - private properties
    
    private weak var collectionView: UICollectionView!
    private let collectionViewLayout: UICollectionViewFlowLayout = CustomFlowLayout()
    private let textList:[(String, [String])] = [
        ("春", ["春は曙、", "やうやう白くなりゆく山際すこしあかりて、", "紫だちたる雲の細くたなびきたる。"]),
        ("夏", ["夏は夜、", "月の頃はさらなり、", "闇もなほ螢飛びちがひたる、", "雨などの降るさへをかし。"]),
        ("秋", ["秋は夕暮、", "夕日はなやかにさして、", "山の端(は)いと近くなりたるに、", "烏のねどころへ行くとて、", "三つ四つ二つなど飛びゆくさへあはれなり。", "まいて雁などのつらねたるが、", "いとちひさく見ゆる、", "いとをかし。", "日入りはてて、", "風の音、", "蟲の音など、", "いとあはれなり。"]),
        ("冬", ["冬はつとめて。", "雪の降りたるは、", "いふべきにもあらず。", "霜などのいと白きも、", "またさらでもいと寒きに、", "火など急ぎおこして、", "炭持てわたるも、", "いとつきづきし。", "昼になりて、", "ぬるくゆるびもていけば、", "炭櫃(すびつ)・火桶の火も、", "白き灰がちになりぬるはわろし。"]),
    ]

    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        layoutViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateLayout()
    }
}

// MARK: - private

private extension Page4ViewController {
    func setupViews() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SimpleCollectionViewCell.self, forCellWithReuseIdentifier: SimpleCollectionViewCell.className)
        collectionView.register(SimpleCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SimpleCollectionViewHeader.className)

        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    func layoutViews() {
        // コレクションビューのセーフエリア対応は自分で計算する
        collectionView.insetsLayoutMarginsFromSafeArea = false
        
        collectionViewLayout.minimumInteritemSpacing = Const.minimumInteritemSpacing
        collectionViewLayout.minimumLineSpacing = 2
        collectionViewLayout.sectionInset = UIEdgeInsets(top: Const.sectionTopMargin,
                                                         left: Const.sectionSideMargin,
                                                         bottom: Const.sectionBottomMargin,
                                                         right: Const.sectionSideMargin)
    }
    
    func updateLayout() {
        // セーフエリア内にレイアウトする
        let frame = view.bounds.inset(by: view.safeAreaInsets)
        collectionView.frame = frame
        // コレクションビューからレイアウトマージンとセクションインセット分差し引いた横幅を計算
        // insetsLayoutMarginsFromSafeAreaをfalseに設定済みなので、layoutMargins はセーフエリアの影響をうけない。
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).inset(by: collectionViewLayout.sectionInset).width
        var column = Int((availableWidth + Const.minimumInteritemSpacing) / (Const.cellMinimumWidth + Const.minimumInteritemSpacing))
        if column == 0 {
            column = 1
        }
        
        let cellWidth = (availableWidth - (Const.minimumInteritemSpacing * CGFloat(column - 1))) / CGFloat(column)
        let cellSize = CGSize(width: cellWidth, height: Const.cellHeight)
        
        collectionViewLayout.itemSize = cellSize
        collectionViewLayout.invalidateLayout()
        collectionViewLayout.headerReferenceSize = CGSize(width: view.frame.width, height: Const.headerHeight)
    }
}

// MARK: - UICollectionViewDelegate

extension Page4ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell tapped [\(indexPath.section)][\(indexPath.row)]")
    }
}

// MARK: - UICollectionViewDataSource

extension Page4ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return textList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textList[section].1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimpleCollectionViewCell.className, for: indexPath)
        guard let simpleCell = cell as? SimpleCollectionViewCell else { return cell }
        
        simpleCell.text.text = textList[indexPath.section].1[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: SimpleCollectionViewHeader.className,
                                                                     for: indexPath)
        guard let simpleHeader = header as? SimpleCollectionViewHeader else { return header }
        
        simpleHeader.text.text = textList[indexPath.section].0
        return header
    }
}
