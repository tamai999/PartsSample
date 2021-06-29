//
//  CustomAlertViewController.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let alertFrameViewWidth: CGFloat = 300
    static let alertFrameViewHeight: CGFloat = 200
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
    
    private weak var alertFrameView: UIView!
    private weak var messageLabel: UILabel!
    private weak var closeButton: UIButton!
    private weak var leftButton: UIButton!
    private weak var rightButton: UIButton!

    private var buttonLayout: ButtonLayout = .close
    private var leftButtonProcess: (()->())?
    private var rightButtonProcess: (()->())?
    private var message = ""
    private var leftButtonTitle = ""
    private var rightButtonTitle = ""

    // MARK: - internal properties

    var centerYConstraint: NSLayoutConstraint?
    var dismissCompletion: (() -> ())?
    
    // MARK: - lifecycle
    
    init(message: String) {
        self.message = message
        
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

        self.message = message
        self.leftButtonTitle = leftButtonTitle
        self.leftButtonProcess = leftButtonProcess
        self.rightButtonTitle = rightButtonTitle
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
        
        setupViews()
        layoutViews()
    }
}

// MARK: - private

private extension CustomAlertViewController {
    func setupViews() {
        // 背景
        view.backgroundColor = .clear
        // アラートの枠
        let alertFrameView = UIView()
        alertFrameView.backgroundColor = .lightGray
        alertFrameView.layer.cornerRadius = Const.alertFrameViewCornerRadius
        view.addSubview(alertFrameView)
        self.alertFrameView = alertFrameView
        // メッセージ
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        alertFrameView.addSubview(messageLabel)
        self.messageLabel = messageLabel
        
        if buttonLayout == .leftRight {
            // 左ボタン
            let leftButton = UIButton()
            leftButton.setTitle(leftButtonTitle, for: .normal)
            leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
            alertFrameView.addSubview(leftButton)
            self.leftButton = leftButton

            // 右ボタン
            let rightButton = UIButton()
            rightButton.setTitle(rightButtonTitle, for: .normal)
            rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
            alertFrameView.addSubview(rightButton)
            self.rightButton = rightButton

        } else {
            // 閉じるボタン
            let closeButton = UIButton()
            closeButton.setTitle(Const.closeButtonText, for: .normal)
            closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            alertFrameView.addSubview(closeButton)
            self.closeButton = closeButton
        }
    }
    
    func layoutViews() {
        // アラートの枠
        alertFrameView.snp.makeConstraints { make in
            make.width.equalTo(Const.alertFrameViewWidth)
            make.height.equalTo(Const.alertFrameViewHeight)
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
