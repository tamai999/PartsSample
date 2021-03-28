//
//  SearchHeaderView.swift
//  PartsSample
//

import UIKit
import SnapKit

fileprivate struct Const {
    static let inputAreaViewHeight: CGFloat = 30
    static let textFieldViewHeight: CGFloat = 28
    static let loupeImageViewSize: CGFloat = 20
    static let todoButtonAreaSize: CGFloat = 35
    static let todoButtonSize: CGFloat = 25
    static let layoutMergine: CGFloat = 10
    static let partsMergine: CGFloat = 8
}

/// ホーム画面のヘッダビュー
class SearchHeaderView: UIView {

    // MARK: - private properties
    
    private let inputAreaView = UIView()
    private let loupeImageView = UIImageView()
    private let textFieldView = UITextField()
    private let settingButton = UIButton()
    
    // MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
        
        // TODO: 検索窓を使えるようにする
        textFieldView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - private

private extension SearchHeaderView {
    func setupView() {
        // ヘッダー背景
        backgroundColor = R.color.header()
        
        // 入力領域
        inputAreaView.layer.cornerRadius = Const.inputAreaViewHeight / 2
        inputAreaView.backgroundColor = R.color.textField()
        addSubview(inputAreaView)
        
        // 虫眼鏡
        if #available(iOS 13.0, *) {
            loupeImageView.image = UIImage(systemName: "magnifyingglass")
            loupeImageView.tintColor = R.color.subIcon()
        } else {
            loupeImageView.backgroundColor = R.color.errorText()
        }
        addSubview(loupeImageView)
        
        // テキストフィールド
        textFieldView.attributedPlaceholder = NSAttributedString(string: "検索",
                                                                 attributes: [.foregroundColor : R.color.placeHolderText() ?? UIColor.red])
        addSubview(textFieldView)

        // 設定ボタン
        if #available(iOS 13.0, *) {
            let image = UIImage(
                systemName: "gearshape",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: Const.todoButtonSize)
            )
            settingButton.setImage(image, for: .normal)
            settingButton.tintColor = R.color.subIcon()
        } else {
            settingButton.backgroundColor = R.color.errorBackground()
        }
        addSubview(settingButton)
    }
    
    func setupLayout() {
        // 入力領域
        inputAreaView.snp.makeConstraints { make in
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(Const.layoutMergine)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-Const.layoutMergine - Const.todoButtonAreaSize - Const.partsMergine)
            make.bottom.equalToSuperview().offset(-Const.layoutMergine)
            make.height.equalTo(Const.inputAreaViewHeight)
        }
        
        // 虫眼鏡
        loupeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(inputAreaView)
            make.left.equalTo(inputAreaView).offset(Const.partsMergine)
            make.size.equalTo(Const.loupeImageViewSize)
        }

        // テキストフィールド
        textFieldView.snp.makeConstraints { make in
            make.centerY.equalTo(inputAreaView)
            make.left.equalTo(loupeImageView.snp.right).offset(Const.partsMergine)
            make.right.equalTo(inputAreaView)
            make.height.equalTo(Const.textFieldViewHeight)
        }

        // 設定ボタン
        settingButton.snp.makeConstraints { make in
            make.centerY.equalTo(inputAreaView)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-Const.layoutMergine)
        }
    }
}
