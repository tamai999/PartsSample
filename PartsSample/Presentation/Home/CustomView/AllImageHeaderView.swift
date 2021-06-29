//
//  AllImageHeaderView.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let titleX: CGFloat = 20
    static let titleY: CGFloat = 15
    static let titleWidth: CGFloat = 0
    static let titleHeight: CGFloat = 30
}

/// 画像一覧のコレクションビューのヘッダ
class AllImageHeaderView: UICollectionReusableView {

    // MARK: - private properties

    private weak var titleLabel: UILabel!
    
    // MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    
    /// ヘッダのタイトルテキストを設定
    /// - Parameter text: タイトルテキスト
    public func setTitle(_ text: String) {
        titleLabel.text = text
        titleLabel.sizeToFit()
    }
}

// MARK: - private

private extension AllImageHeaderView {
    func setupViews() {
        let titleLabel = UILabel()
        titleLabel.textColor = R.color.label()
        addSubview(titleLabel)
        self.titleLabel = titleLabel
    }
    
    func layoutViews() {
        titleLabel.frame = CGRect(x: Const.titleX, y: Const.titleY, width: Const.titleWidth, height: Const.titleHeight)
    }
}
