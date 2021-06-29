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
    static let layoutMargin: CGFloat = 10
    static let partsMargin: CGFloat = 8
}

/// ホーム画面のヘッダビュー
class SearchHeaderView: UIView {

    // MARK: - private properties
    
    private weak var inputAreaView: UIView!
    private weak var loupeImageView: UIImageView!
    private weak var textFieldView: UITextField!
    private weak var settingButton: UIButton!
    
    // MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        layoutViews()
        
        // TODO: 検索窓を使えるようにする
        textFieldView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - private

private extension SearchHeaderView {
    func setupViews() {
        // ヘッダー背景
        backgroundColor = R.color.header()
        
        // 入力領域
        let inputAreaView = UIView()
        inputAreaView.layer.cornerRadius = Const.inputAreaViewHeight / 2
        inputAreaView.backgroundColor = R.color.textField()
        addSubview(inputAreaView)
        self.inputAreaView = inputAreaView
        
        // 虫眼鏡
        let loupeImageView = UIImageView()
        if #available(iOS 13.0, *) {
            loupeImageView.image = UIImage(systemName: "magnifyingglass")
            loupeImageView.tintColor = R.color.subIcon()
        } else {
            loupeImageView.backgroundColor = R.color.errorText()
        }
        addSubview(loupeImageView)
        self.loupeImageView = loupeImageView
        
        // テキストフィールド
        let textFieldView = UITextField()
        textFieldView.attributedPlaceholder = NSAttributedString(string: "検索",
                                                                 attributes: [.foregroundColor : R.color.placeHolderText() ?? UIColor.red])
        addSubview(textFieldView)
        self.textFieldView = textFieldView

        // 設定ボタン
        let settingButton = UIButton()
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
        self.settingButton = settingButton
    }
    
    func layoutViews() {
        // 入力領域
        inputAreaView.snp.makeConstraints { make in
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(Const.layoutMargin)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-Const.layoutMargin - Const.todoButtonAreaSize - Const.partsMargin)
            make.bottom.equalToSuperview().offset(-Const.layoutMargin)
            make.height.equalTo(Const.inputAreaViewHeight)
        }
        
        // 虫眼鏡
        loupeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(inputAreaView)
            make.left.equalTo(inputAreaView).offset(Const.partsMargin)
            make.size.equalTo(Const.loupeImageViewSize)
        }

        // テキストフィールド
        textFieldView.snp.makeConstraints { make in
            make.centerY.equalTo(inputAreaView)
            make.left.equalTo(loupeImageView.snp.right).offset(Const.partsMargin)
            make.right.equalTo(inputAreaView)
            make.height.equalTo(Const.textFieldViewHeight)
        }

        // 設定ボタン
        settingButton.snp.makeConstraints { make in
            make.centerY.equalTo(inputAreaView)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-Const.layoutMargin)
        }
    }
}
