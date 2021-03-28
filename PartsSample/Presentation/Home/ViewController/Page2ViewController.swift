//
//  Page2ViewController.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let buttonWidth: CGFloat = 300
    static let buttonHeight: CGFloat = 40
    static let buttonVerticalSpaceUnit: CGFloat = 40
}

class Page2ViewController: PageViewController {
    
    // MARK: - private properties
    
    private let showAlertButton = UIButton()
    private let showDelayAlertButton = UIButton()
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
    }
}

// MARK: - private

private extension Page2ViewController {
    
    func setupView() {
        view.backgroundColor = R.color.background()
        
        showAlertButton.setTitle("２連続アラート表示", for: .normal)
        showAlertButton.setTitleColor(R.color.label(), for: .normal)
        showAlertButton.addTarget(self, action: #selector(showAlertButtonTapped), for: .touchUpInside)
        view.addSubview(showAlertButton)
        
        showDelayAlertButton.setTitle("３秒後にアラート表示", for: .normal)
        showDelayAlertButton.setTitleColor(R.color.label(), for: .normal)
        showDelayAlertButton.addTarget(self, action: #selector(showDelayAlertButtonTapped), for: .touchUpInside)
        view.addSubview(showDelayAlertButton)
    }
    
    func setupLayout() {
        showAlertButton.snp.makeConstraints { make in
            make.width.equalTo(Const.buttonWidth)
            make.height.equalTo(Const.buttonHeight)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-Const.buttonVerticalSpaceUnit)
        }
        
        showDelayAlertButton.snp.makeConstraints { make in
            make.width.equalTo(Const.buttonWidth)
            make.height.equalTo(Const.buttonHeight)
            make.top.equalTo(showAlertButton.snp.bottom).offset(Const.buttonVerticalSpaceUnit)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc
    func showAlertButtonTapped(sender: Any) {
        
        let closeAlertVC = CustomAlertViewController(message: "アラートボタンの表示テスト。\nこのアラートは１つボタン。\n次に表示されるアラートは２つボタンで、既にアラート表示要求がキューにある。")
        showAlert(presented: closeAlertVC)
        
        let doubleButtonVC = CustomAlertViewController(message: "２つボタンアラートのテスト表示。左側のボタンタップでアラート表示のキューを全て削除。右側のボタンは閉じるだけ。",
                                                       leftButtonTitle: "左ボタン",
                                                       leftButtonProcess: {
                                                        // アラートの表示キューをクリア
                                                        self.cancelAllAlert()
                                                       },
                                                       rightButtonTitle: "右ボタン",
                                                       rightButtonProcess: {
                                                       })
        showAlert(presented: doubleButtonVC)
    }
        
    @objc
    func showDelayAlertButtonTapped(sender: Any) {
        let vc = CustomAlertViewController(message: "このアラートは３秒前に表示要求されました")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.showAlert(presented: vc)
        }
    }
}
