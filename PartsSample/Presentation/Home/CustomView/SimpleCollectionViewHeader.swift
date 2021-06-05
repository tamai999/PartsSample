//
//  SimpleCollectionViewHeader.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let labelFontSize: CGFloat = 30.0
    static let labelSideMargin: CGFloat = 16.0
}

class SimpleCollectionViewHeader: UICollectionReusableView {
    
    // MARK: - private properties
    
    weak var text: UILabel!
    
    // MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private

private extension SimpleCollectionViewHeader {
    func setupView() {
        let text = UILabel()
        if #available(iOS 13.0, *) {
            text.textColor = UIColor.label
        } else {
            text.textColor = UIColor.black
        }
        text.numberOfLines = 1
        text.font = UIFont.boldSystemFont(ofSize: Const.labelFontSize)
        addSubview(text)
        self.text = text
    }
    
    func setupLayout() {
        text.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Const.labelSideMargin)
            make.right.equalToSuperview().offset(-Const.labelSideMargin)
            make.centerY.equalToSuperview()
        }
    }
}
