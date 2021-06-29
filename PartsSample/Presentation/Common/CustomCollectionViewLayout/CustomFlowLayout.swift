import UIKit

fileprivate struct Const {
    static let borderWidth: CGFloat = 0.5
    static let borderColor = UIColor.lightGray
    static let frameCornerRadius: CGFloat = 10.0
    // 枠線のデコレーション識別子
    static let kindSectionFrame = "kindSectionFrame"
}

/// セックションの角丸枠線表示レイアウト
class CustomFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - private properties
    
    private var sectionFrames: [CGRect] = []
    
    // MARK: - lifecycle
    
    override init() {
        super.init()
        
        register(SectionBackgroundView.self, forDecorationViewOfKind: Const.kindSectionFrame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        // 各セクションの位置・サイズを計算し、sctionFrames に格納する
        sectionFrames = []

        let headerHeight = headerReferenceSize.height
        let footerHeight = footerReferenceSize.height
        var yPosition: CGFloat = 0
        for section in 0..<collectionView.numberOfSections {
            // セクションあたりの縦のアイテムの数
            let verticalItemCount = Int(ceil(Float(collectionView.numberOfItems(inSection: section)) / Float(numberOfColumns)))
            // １セクションあたりの高さ
            var height = CGFloat(verticalItemCount) * itemSize.height
            height += (minimumInteritemSpacing * CGFloat(verticalItemCount - 1))
            height +=  sectionInset.top + sectionInset.bottom
            height +=  headerHeight + footerHeight
            
            sectionFrames.append(CGRect(x: 0, y: yPosition , width:collectionView.frame.width, height: height))
            // 次のセクションの位置
            yPosition += height
        }
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
        guard indexPath.section < sectionFrames.count else { return nil }
        let sctionFrame = sectionFrames[indexPath.section]

        if elementKind == Const.kindSectionFrame {
            // セクションの枠の位置・サイズを返す
            let frame = CGRect(x: sctionFrame.origin.x + sectionInset.left,
                               y: sctionFrame.origin.y + headerReferenceSize.height + sectionInset.top,
                               width: sctionFrame.width - (sectionInset.left + sectionInset.right),
                               height: sctionFrame.height - headerReferenceSize.height - sectionInset.bottom)
            attributes.frame = frame
            attributes.zIndex = -2
            
            return attributes
        } else {
            return nil
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 標準のフローレイアウトが描画しようとしているビュー（アトリビュート）を取得
        guard let allAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var decorationAttributes: [UICollectionViewLayoutAttributes] = []
        var sectionIndexes: Set<Int> = []
        
        for layoutAttributes in allAttributes {
            let indexPath = layoutAttributes.indexPath
            // 背景画像を追加する
            if !sectionIndexes.contains(indexPath.section) {
                // セクション毎にデコレーションアトリビュートを生成する
                if let attribute = self.layoutAttributesForDecorationView(ofKind: Const.kindSectionFrame, at: indexPath) {
                    decorationAttributes.append(attribute)
                    sectionIndexes.insert(indexPath.section)
                }
            }
        }
        // 標準のフローレイアウトが描画しようとしているビューに加えて、セクションの背景ビューも追加する
        return allAttributes + decorationAttributes
    }
}

// MARK: - private

private extension CustomFlowLayout {
    // セルの列の数
    private var numberOfColumns: Int {
        guard let collectionView = collectionView else { return 0 }
        // 注意。列数の計算はこのレイアウトを使うUICollectionViewの列数の計算（またはセルサイズ）と合わせる必要がある。
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).inset(by: sectionInset).width
        let numberOfColumns = Int((availableWidth + minimumInteritemSpacing) / (itemSize.width + minimumInteritemSpacing))
        return numberOfColumns > 0 ? numberOfColumns : 1
    }
}

/// セックションの背景
private class SectionBackgroundView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        layer.cornerRadius = Const.frameCornerRadius
        layer.borderWidth = Const.borderWidth
        layer.borderColor = Const.borderColor.cgColor
        if #available(iOS 13.0, *) {
            backgroundColor = UIColor.tertiarySystemBackground
        } else {
            backgroundColor = UIColor.white
        }
    }
}
