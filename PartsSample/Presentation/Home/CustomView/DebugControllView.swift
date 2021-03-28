//
//  DebugControllView.swift
//  PartsSample
//

import UIKit
import SnapKit

enum DebugUIStyle: Int { case light = 0, dark }

/// デバッグ用の操作スイッチビュー
class DebugControllView: UIView {
    // MARK: - private properties
    let uiStyleSegmentedControl = UISegmentedControl(items: ["light", "dark"])
    
    // MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - internal methods
    func setUIStyle(style: DebugUIStyle) {
        uiStyleSegmentedControl.selectedSegmentIndex = style.rawValue
    }
}

// MARK: - private

private extension DebugControllView {
    func setupView() {
        backgroundColor = R.color.carouselBackground()
        
        addSubview(uiStyleSegmentedControl)
        uiStyleSegmentedControl.addTarget(self, action: #selector(uiStyleChanged), for: .valueChanged)
    }
    
    func setupLayout() {
        uiStyleSegmentedControl.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.centerX.centerY.equalTo(self)
        }
    }
    
    @objc func uiStyleChanged(sender: AnyObject) {
        // Darkモードの切り替えを通知する
        let selectedIndex = uiStyleSegmentedControl.selectedSegmentIndex
        if selectedIndex == DebugUIStyle.dark.rawValue {
            NotificationCenter.default.post(name: .didChangeToDarkMode, object: nil)
        } else {
            NotificationCenter.default.post(name: .didChangeToLightMode, object: nil)
        }
    }
}
