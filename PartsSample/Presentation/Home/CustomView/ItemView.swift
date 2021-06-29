//
//  ItemView.swift
//  PartsSample
//

import UIKit
import SnapKit

fileprivate struct Const {
    static let imageCornerRadius: CGFloat = 4
}

/// カルーセルビュー内のアイテム
class ItemView: UIView {
    
    // MARK: - private properties
    private weak var imageView: UIImageView!
    private weak var priceLabel: UILabel!
    // 画像ロード後に画像のアスペクト比を維持した状態で、
    // 外側のビューの縦幅に合うように横幅の制約を更新するため、対象の制約を保持
    private weak var widthConstraint: NSLayoutConstraint?
    
    // MARK: - lifecycle
    
    init(imageName: String, price: Int) {
        super.init(frame: CGRect.zero)
        
        setupView(imageName: imageName, price: price)
        layoutViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - private

private extension ItemView {
    
    func setupView(imageName: String, price: Int) {
        // スケルトン画像を表示
        let imageView = UIImageView()
        imageView.image = R.image.item_skeleton()
        imageView.layer.cornerRadius = Const.imageCornerRadius
        imageView.clipsToBounds = true
        addSubview(imageView)
        self.imageView = imageView
        // 画像の読み込み開始
        loadImage(name: imageName)
        // 価格
        let priceLabel = UILabel()
        priceLabel.text = " ¥\(price.withComma) "
        priceLabel.textColor = .white
        priceLabel.font = UIFont.priceFont
        priceLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        priceLabel.isHidden = true
        addSubview(priceLabel)
        self.priceLabel = priceLabel
    }
    
    func layoutViews() {
        // 画像
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        setupImageViewAspect()
        // 価格
        priceLabel.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
        }
    }
    
    func setupImageViewAspect() {
        guard let image = imageView.image else { return }
        
        if let constraint = widthConstraint {
            removeConstraint(constraint)
        }
        
        // アイテムの横幅の制約をロードした画像サイズに合わせて変更する
        let aspectRatio = image.size.width / image.size.height
        let widthConstraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio)
        widthConstraint.isActive = true
        self.widthConstraint = widthConstraint
    }
    
    func loadImage(name: String) {
        guard let image = UIImage(named: name) else { return }
        
        // 擬似的にアイテムを遅延表示
        let loadTime = Double.random(in: 0.5 ..< 3)
        DispatchQueue.main.asyncAfter(deadline: .now() + loadTime) {
            // 画像を差し替える
            self.imageView.image = image
            self.setupImageViewAspect()
            // 価格を表示する
            self.bringSubviewToFront(self.priceLabel)
            self.priceLabel.isHidden = false
        }
    }
}
