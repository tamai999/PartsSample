//
//  UIViewController+Extension.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let pickerHeight: CGFloat = 220.0
    static let pickerTopConstraintId = "pickerTopConstraintId"
    static let pickerAnimationDuration: TimeInterval = 0.2
}

extension UIViewController {
    
    /// ピッカーを表示する
    /// - Parameters:
    ///   - data: 値とタイトルのタプルの配列
    ///   - selectedRow: 選択されている行（０〜の連番）
    ///   - doneProcess: 完了ボタンタップ時の処理
    func showPicker(data: [(Int, String)], selectedRow: Int, doneProcess: ((Int) -> ())?) {
        // 作成済みでなければピッカービューを作成
        let customPickerView: CustomPickerView
        if let pickerView = view.viewWithTag(UIView.tagConst.customPickerView.rawValue) as? CustomPickerView {
            customPickerView = pickerView
        } else {
            customPickerView = CustomPickerView()
            customPickerView.tag = UIView.tagConst.customPickerView.rawValue
            view.addSubview(customPickerView)
        }
        // データを設定
        customPickerView.setData(data, selectedRow: selectedRow)
        // 完了ボタンブロック
        customPickerView.didTapDoneButtonProcess = { selectedRow in
            doneProcess?(selectedRow)
            self.closePicker()
        }
        // レイアウト
        customPickerView.snp.removeConstraints()
        customPickerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(Const.pickerHeight + view.safeAreaInsets.bottom)
        }
        // ピッカービューのトップの制約がなければ作る
        var constraint = view.constraints.first {
            $0.identifier == Const.pickerTopConstraintId
        }
        if constraint == nil {
            let topConstraint = customPickerView.topAnchor.constraint(equalTo: view.bottomAnchor)
            topConstraint.identifier = Const.pickerTopConstraintId
            topConstraint.isActive = true
            constraint = topConstraint
        }
        // 一旦枠外に配置
        constraint?.constant = 0
        view.layoutIfNeeded()
        // 最前面に表示
        view.bringSubviewToFront(customPickerView)
        
        // 表示アニメーション
        constraint?.constant = -(Const.pickerHeight + self.view.safeAreaInsets.bottom)
        UIView.animate(withDuration: Const.pickerAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// ピッカーを閉じる
    func closePicker() {
        let constraint = view.constraints.first {
            $0.identifier == Const.pickerTopConstraintId
        }
        // 非表示アニメーション
        if let constraint = constraint {
            constraint.constant = 0
            UIView.animate(withDuration: Const.pickerAnimationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    /// ピッカーが表示されているかどうか
    var isPickerOpened: Bool {
        let constraint = view.constraints.first {
            $0.identifier == Const.pickerTopConstraintId
        }
        if let constraint = constraint {
            return constraint.constant != 0
        } else {
            return false
        }
    }
}
