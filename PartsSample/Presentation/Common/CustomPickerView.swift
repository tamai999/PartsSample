//
//  CustomPickerView.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let toolBarHeight: CGFloat = 40.0
}

class CustomPickerView: UIView {
    // MARK: - private properties
    
    private weak var pickerView: UIPickerView?
    private var selectedRow: Int = 0
    private var data: [(value:Int, title: String)] = []
    
    // MARK: - internal method
    
    var didTapDoneButtonProcess: ((Int) -> ())?
    
    // MARK: - lifecycle
    
    init() {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// ピッカーの選択肢を設定する
    /// - Parameters:
    ///   - data: 値とタイトルのタプルの配列
    ///   - selectedIndex: 選択されている行番号（0〜）
    func setData(_ data: [(Int, String)], selectedRow: Int) {
        self.data = data
        self.selectedRow = selectedRow
        
        if let pickerView = pickerView {
            pickerView.reloadAllComponents()
            pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        }
    }
}

// MARK: - private

private extension CustomPickerView {
    func setupView() {
        backgroundColor = .clear
        // ブラー
        let blurEffect: UIBlurEffect
        if #available(iOS 13.0, *) {
            blurEffect = UIBlurEffect(style: .systemMaterial)
        } else {
            blurEffect = UIBlurEffect(style: .light)
        }
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = bounds
        addSubview(visualEffectView)
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // ツールバー
        let toolBar = UIToolbar()
        var toolBarFrame = bounds
        toolBarFrame.size.height = Const.toolBarHeight
        toolBar.frame = toolBarFrame
        if #available(iOS 13.0, *) {
            toolBar.backgroundColor = UIColor.tertiarySystemBackground
        } else {
            toolBar.backgroundColor = .lightGray
        }
        visualEffectView.contentView.addSubview(toolBar)
        toolBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        // ツールバー内の余白
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                target: nil, action: nil)
        // 完了ボタン
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                        target: self,
                        action: #selector(didTapDoneButton))
        toolBar.items = [flexibleItem, doneButton]
        // AutoLayoutのワーニングが出るのでupdateConstraintsIfNeeded()しておく
        // https://developer.apple.com/forums/thread/121474
        toolBar.updateConstraintsIfNeeded()
        // ピッカー
        let picker = UIPickerView()
        picker.selectRow(selectedRow, inComponent: 0, animated: false)
        picker.dataSource = self
        picker.delegate = self

        var pickerFrame = bounds
        pickerFrame.origin.y += Const.toolBarHeight
        picker.frame = pickerFrame
        visualEffectView.contentView.addSubview(picker)
        picker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.pickerView = picker
    }
    
    @objc
    func didTapDoneButton(_ sender: Any) {
        guard selectedRow < data.count else { return }
        didTapDoneButtonProcess?(data[selectedRow].value)
    }
}

// MARK: - UIPickerViewDataSource

extension CustomPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
}

// MARK: - UIPickerViewDelegate

extension CustomPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row < data.count else { return nil }
        return data[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
}
