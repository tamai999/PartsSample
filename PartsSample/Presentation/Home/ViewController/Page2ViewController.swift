//
//  Page2ViewController.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let buttonWidth: CGFloat = 300
    static let buttonHeight: CGFloat = 40
    static let prefectureList: [(value: Int, title: String)] = [
        (0, "北海道"),
        (1, "青森県"),
        (2, "岩手県"),
        (3, "宮城県"),
        (4, "秋田県"),
        (5, "山形県"),
        (6, "福島県"),
        (7, "茨城県"),
        (8, "栃木県"),
        (9, "群馬県"),
        (10,"埼玉県")]
}

class Page2ViewController: PageViewController {
    
    // MARK: - private properties
    
    private weak var stackView: UIStackView!
    private weak var showPickerButton: UIButton!
    private weak var maskView: UIView!
    private var pickerSelectedRow = 0
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        layoutViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        closePicker()
        maskView.isHidden = true
    }
}

// MARK: - private

private extension Page2ViewController {
    
    func setupViews() {
        view.backgroundColor = R.color.background()
        // 部品を格納するスタックビュー
        let stackView = UIStackView()
        view.addSubview(stackView)
        self.stackView = stackView
        // ボタン
        let showAlertButton = UIButton()
        showAlertButton.setTitle("２連続アラート表示", for: .normal)
        showAlertButton.setTitleColor(R.color.label(), for: .normal)
        showAlertButton.addTarget(self, action: #selector(showAlertButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(showAlertButton)
        // ボタン
        let showDelayAlertButton = UIButton()
        showDelayAlertButton.setTitle("３秒後にアラート表示", for: .normal)
        showDelayAlertButton.setTitleColor(R.color.label(), for: .normal)
        showDelayAlertButton.addTarget(self, action: #selector(showDelayAlertButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(showDelayAlertButton)
        // ボタン
        let showPickerButton = UIButton()
        showPickerButton.setTitle(makePickerButtonTitle(), for: .normal)
        showPickerButton.setTitleColor(R.color.label(), for: .normal)
        showPickerButton.addTarget(self, action: #selector(showPickerButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(showPickerButton)
        self.showPickerButton = showPickerButton
        // ピッカー表示中のマスク
        let maskView = UIView()
        maskView.backgroundColor = .clear
        maskView.isHidden = true
        view.addSubview(maskView)
        self.maskView = maskView
        // タップジェスチャー
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(viewDidTap))
        
        maskView.addGestureRecognizer(tapGestureRecognizer)
        
        // ハーフモーダル表示ボタン
        let showHalfModalButton = UIButton()
        showHalfModalButton.setTitle("ハーフモーダル表示", for: .normal)
        showHalfModalButton.setTitleColor(R.color.label(), for: .normal)
        stackView.addArrangedSubview(showHalfModalButton)
        showHalfModalButton.addTarget(self, action: #selector(showHalfModalTapped), for: .touchUpInside)
    }
    
    func layoutViews() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        maskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
    @objc
    func showPickerButtonTapped(sender: Any) {
        maskView.isHidden = false
        showPicker(data: Const.prefectureList, selectedRow: pickerSelectedRow) { selectedRow in
            self.pickerSelectedRow = selectedRow
            self.showPickerButton.setTitle(self.makePickerButtonTitle(), for: .normal)
            self.maskView.isHidden = true
        }
    }
    
    @objc
    func viewDidTap(_ sender: Any) {
        if isPickerOpened {
            closePicker()
            maskView.isHidden = true
        }
    }
    
    @objc
    func showHalfModalTapped(_ sender: Any) {
        let vc = SampleHalfModalViewController()
        present(vc, animated: true, completion: nil)
    }
    
    func makePickerButtonTitle() -> String {
        let title = Const.prefectureList[pickerSelectedRow].title
        return "ピッカーを表示[\(title)]"
    }
}
