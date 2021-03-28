//
//  ItemView.swift
//  PartsSample
//

import UIKit
import SnapKit

protocol ItemViewProtocol {
    func didLoadImage(sender: ItemView)
}

fileprivate struct Const {
    static let imageCornerRadius: CGFloat = 4
}

/// カルーセルビュー内のアイテム
class ItemView: UIView {
    
    // MARK: - private properties
    private var imageView = UIImageView()
    private let priceLabel = UILabel()
    // 画像ロード後に画像のアスペクト比を維持した状態で、
    // 外側のビューの縦幅に合うように横幅の制約を更新するため、対象の制約を保持
    var widthConstraint: NSLayoutConstraint?
    
    var delegate: ItemViewProtocol?
    
    var imageAspect: CGFloat {
        if let size = imageView.image?.size {
            return size.width / size.height
        } else {
            return  1.0
        }
    }
    
    // MARK: - lifecycle
    
    init(imageName: String, price: Int) {
        super.init(frame: CGRect.zero)
        
        setupView(imageName: imageName, price: price)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - private

private extension ItemView {
    
    func setupView(imageName: String, price: Int) {
        // スケルトン画像を表示
        setupImageView(image: R.image.item_skeleton())
        addSubview(imageView)
        // 画像の読み込み開始
        loadImage(name: imageName)
        // 価格
        priceLabel.text = " ¥\(price.withComma) "
        priceLabel.textColor = .white
        priceLabel.font = UIFont.priceFont
        priceLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        priceLabel.isHidden = true
        addSubview(priceLabel)
    }
    
    func setupImageView(image: UIImage?) {
        imageView.image = image
        imageView.layer.cornerRadius = Const.imageCornerRadius
        imageView.clipsToBounds = true
    }
    
    func setupLayout() {
        // 画像
        setupImageViewLayout()
        // 価格
        priceLabel.snp.makeConstraints { make in
            make.left.bottom.equalTo(self)
        }
    }
    
    func setupImageViewLayout() {
        imageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
    }
    
    func loadImage(name: String) {
        guard let image = UIImage(named: name) else { return }
        
        // 擬似的にアイテムを遅延表示
        let loadTime = Double.random(in: 0.5 ..< 3)
        DispatchQueue.main.asyncAfter(deadline: .now() + loadTime) {
            // 一旦、画像ボタンをレイアウトから外す
            self.imageView.removeFromSuperview()
            // 画像ボタンを作りレイアウトし直す
            self.imageView = UIImageView()
            self.imageView.image = image
            self.addSubview(self.imageView)
            self.setupImageViewLayout()
            // 価格を表示する
            self.bringSubviewToFront(self.priceLabel)
            self.priceLabel.isHidden = false

            self.delegate?.didLoadImage(sender: self)
        }
    }
}
