//
//  ImageItemCellView.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let priceLabelHeight: CGFloat = 20
}

class ImageItemCellView: UICollectionViewCell {
    
    // MARK: - private properties

    private let imageView = UIImageView()
    private let priceLabel = UILabel()
    private let coverButton = UIButton()
    private let checkImageView = UIImageView()
    
    private var section: Int!
    private var row: Int!
    
    private var isChecked = false {
        didSet {
            if #available(iOS 13.0, *) {
                if isChecked {
                    checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
                } else {
                    checkImageView.image = UIImage(systemName: "circle")
                }
            }
        }
    }
    
    // MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayout()
    }

    //
    // セルタップでセルを縮小（凹んだように見せる）
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        UIView.animate(withDuration: 0.05) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.05) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        UIView.animate(withDuration: 0.05) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }

    // MARK: - intarnal
    
    /// 画像セルのセットアップ
    /// - Parameters:
    ///   - image: 画像
    ///   - price: 価格
    ///   - section: コレクションビューのセクション
    ///   - row: コレクションビューのセクション内順番
    ///   - isSelectMode: セルの選択モードか否か
    public func setupCell(image: UIImage, price: Int, section: Int, row: Int, isSelectMode: Bool) {
        // 画像
        imageView.image = image
        // 価格
        priceLabel.text = " ¥\(price.withComma) "
        // セルの位置
        self.section = section
        self.row = row
        // 選択モード（チェックボックス表示）
        checkImageView.isHidden = !isSelectMode
        // チェック状態
        isChecked = false
    }
}

// MARK: - private

private extension ImageItemCellView {
    
    func setupView() {
        // 画像
        addSubview(imageView)
        // 価格
        priceLabel.textColor = .white
        priceLabel.font = UIFont.priceFont
        priceLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(priceLabel)
        // チェックイメージ
        if #available(iOS 13.0, *) {
            checkImageView.image = UIImage(systemName: "circle")
            checkImageView.tintColor = R.color.label()
        } else {
            checkImageView.backgroundColor = .red
        }
        addSubview(checkImageView)
        // セル全体をボタン化
        coverButton.backgroundColor = .clear
        coverButton.addTarget(self, action: #selector(cellTapped), for: .touchUpInside)
        addSubview(coverButton)
    }
    
    func setupLayout() {
        // 画像
        imageView.contentMode = .scaleAspectFit
        imageView.frame = bounds
        // 価格
        let maxSize = CGSize(width: .greatestFiniteMagnitude, height: Const.priceLabelHeight)
        let titleSize = priceLabel.sizeThatFits(maxSize)
        priceLabel.frame =  CGRect(x: 0,
                                   y: frame.height - Const.priceLabelHeight,
                                   width: titleSize.width,
                                   height: Const.priceLabelHeight)
        // チェックイメージ
        checkImageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        // セル全体をボタン化
        coverButton.frame = bounds
    }
    
    @objc
    func cellTapped(sender: Any) {
        print("section [\(section!)] row[\(row!)]")
        
        isChecked = !isChecked
    }
}
