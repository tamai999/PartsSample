//
//  BannerView.swift
//  PartsSample
//

import UIKit
import SnapKit

/// バナー
class BannerView: UIView {
    
    // MARK: - private properties
    
    private let bannerImageView = UIImageView()
    private let labelView = UILabel()
    
    // MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - private

private extension BannerView {
    
    func setupViews() {
        bannerImageView.image = R.image.banner()
        bannerImageView.contentMode = .scaleAspectFill
        addSubview(bannerImageView)
        
        labelView.text = "★★★　バナー広告　★★★"
        labelView.backgroundColor = .clear
        labelView.textColor = .black
        addSubview(labelView)
    }
        
    func layoutViews() {
        // バナー画像
        bannerImageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
        
        // バナー画像のアスペクト比に合わせてバナーのサイズを拡大・縮小する
        if let image = R.image.banner() {
            let aspectRatio = image.size.height / image.size.width
            NSLayoutConstraint.activate([
                bannerImageView.heightAnchor.constraint(equalTo: bannerImageView.widthAnchor, multiplier: aspectRatio)
            ])
        }

        // 広告ラベル
        labelView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
        }
    }
}
