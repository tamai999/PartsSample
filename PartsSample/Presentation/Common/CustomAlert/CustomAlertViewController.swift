//
//  CustomAlertViewController.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let alertFrameViewWidth: CGFloat = 300
    static let alertFrameViewHeght: CGFloat = 200
    static let alertFrameViewAnimationStartOffset: CGFloat = 50
    static let alertFrameViewCornerRadius: CGFloat = 10.0
    
    static let messageLabelWidthOffset = -40
    static let messageLabelTopOffset = 30
    
    static let closeButtonText = "閉じる"
    static let buttonBottomOffset = -10
}

class CustomAlertViewController: UIViewController {
    private enum ButtonLayout { case close, leftRight }
    
    // MARK: - private properties
    
    private let alertFrameView = UIView()
    private let messageLabel = UILabel()
    private let closeButton = UIButton()
    private let leftButton = UIButton()
    private let rightButton = UIButton()

    private var buttonLayout: ButtonLayout = .close
    private var leftButtonProcess: (()->())?
    private var rightButtonProcess: (()->())?

    // MARK: - internal properties

    var centerYConstraint: NSLayoutConstraint?
    var dismissCompletion: (() -> ())?
    
    // MARK: - lifecycle
    
    init(message: String) {
        messageLabel.text = message
        
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    init(message: String,
                  leftButtonTitle: String,
                  leftButtonProcess: @escaping ()->(),
                  rightButtonTitle: String,
                  rightButtonProcess: @escaping ()->()) {
        
        buttonLayout = .leftRight
        messageLabel.text = message
        
        leftButton.setTitle(leftButtonTitle, for: .normal)
        self.leftButtonProcess = leftButtonProcess
        
        rightButton.setTitle(rightButtonTitle, for: .normal)
        self.rightButtonProcess = rightButtonProcess
        
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
    }
}

// MARK: - private

private extension CustomAlertViewController {
    func setupView() {
        // 背景
        view.backgroundColor = .clear
        // アラートの枠
        alertFrameView.backgroundColor = .lightGray
        alertFrameView.layer.cornerRadius = Const.alertFrameViewCornerRadius
        view.addSubview(alertFrameView)
        // メッセージ
        messageLabel.numberOfLines = 0
        alertFrameView.addSubview(messageLabel)
        
        if buttonLayout == .leftRight {
            // 左ボタン
            leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
            alertFrameView.addSubview(leftButton)

            // 右ボタン
            rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
            alertFrameView.addSubview(rightButton)

        } else {
            // 閉じるボタン
            closeButton.setTitle(Const.closeButtonText, for: .normal)
            closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            alertFrameView.addSubview(closeButton)
        }
    }
    
    func setupLayout() {
        // アラートの枠
        alertFrameView.snp.makeConstraints { make in
            make.width.equalTo(Const.alertFrameViewWidth)
            make.height.equalTo(Const.alertFrameViewHeght)
            make.centerX.equalToSuperview()
        }
        centerYConstraint = alertFrameView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Const.alertFrameViewAnimationStartOffset)
        centerYConstraint?.isActive = true
        
        // メッセージ
        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Const.messageLabelTopOffset)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(Const.messageLabelWidthOffset)
        }
        
        if buttonLayout == .leftRight {
            // 左ボタン
            leftButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview().offset(-Const.alertFrameViewWidth/4)
                make.bottom.equalToSuperview().offset(Const.buttonBottomOffset)
            }
            // 右ボタン
            rightButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview().offset(Const.alertFrameViewWidth/4)
                make.bottom.equalToSuperview().offset(Const.buttonBottomOffset)
            }
            
        } else {
            // 閉じるボタン
            closeButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(Const.buttonBottomOffset)
            }
        }
    }
    
    @objc
    func leftButtonTapped(sender: Any) {
        leftButtonProcess?()
        dismiss(animated: true)
        dismissCompletion?()
    }
    
    @objc
    func rightButtonTapped(sender: Any) {
        rightButtonProcess?()
        dismiss(animated: true)
        dismissCompletion?()
    }
    
    @objc
    func closeButtonTapped(sender: Any) {
        dismiss(animated: true)
        dismissCompletion?()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension CustomAlertViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomAlertPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAlertAnimator(isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAlertAnimator(isPresenting: false)
    }
}
