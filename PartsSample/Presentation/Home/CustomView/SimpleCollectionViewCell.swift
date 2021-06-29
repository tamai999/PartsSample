//
//  SimpleCollectionViewCell.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let labelSideMargin: CGFloat = 16.0
}

class SimpleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - private properties
    
    weak var text: UILabel!
    
    // MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private

private extension SimpleCollectionViewCell {
    func setupViews() {
        backgroundColor = .clear
        
        let text = UILabel()
        text.textColor = .systemRed
        text.font = UIFont.titleFont
        text.numberOfLines = 0
        contentView.addSubview(text)
        self.text = text
    }
    
    func layoutViews() {
        text.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Const.labelSideMargin)
            make.right.equalToSuperview().offset(-Const.labelSideMargin)
            make.centerY.equalToSuperview()
        }
    }
}
