//
//  SampleHalfModalViewController.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let percentThreshold: CGFloat = 0.1
    static let velocityFireClosing: CGFloat = 1200
}

/// ハーフモーダル
class SampleHalfModalViewController: UIViewController {
    // MARK: - private properties
    
    private let interactor = HalfModalTransitioningInteractor()
    private weak var sampleHalfModalView: SampleHalfModalView!
    private var tableViewContentOffsetY: CGFloat = 0.0

    // MARK: - lifecycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInteractor()
        setupViews()
    }
}

// MARK: - private

private extension SampleHalfModalViewController {
    func setupViews() {
        let sampleHalfModalView = SampleHalfModalView()
        sampleHalfModalView.frame = view.frame
        sampleHalfModalView.delegate = self
        view.addSubview(sampleHalfModalView)
        sampleHalfModalView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.sampleHalfModalView = sampleHalfModalView
    }
    
    /// ハーフモーダルの閉じる動作が発生した時の独自の処理を設定
    func setupInteractor() {
        interactor.closeHandler = { [weak self] in
            // ハーフモーダルをdismissするタイミングでTableViewのスクロールを止める
            self?.sampleHalfModalView.setTableViewBounces(false)
        }
        interactor.resetHandler = { [weak self] in
            // ハーフモーダルのTableViewをスクロールできるようにする
            self?.sampleHalfModalView.setTableViewBounces(true)
        }
    }
    
    // ジェスチャー（移動量）に応じてハーフモーダルをクローズ
    func handleTransitionGesture(_ sender: UIPanGestureRecognizer) {
        /// インタラクションを開始できる状態なら、クローズを開始する
        switch interactor.state {
        case .startInteraction:
            interactor.state = .inProgress
            dismiss(animated: true, completion: nil)
        case .inProgress, .shouldClose:
            break
        case .notInProgress:
            return
        }
        
        // クローズの割合（％）を算出
        let translation = sender.translation(in: view)
        let verticalMovement = (translation.y) / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        switch sender.state {
        case .changed:
            if progress > Const.percentThreshold || sender.velocity(in: view).y > Const.velocityFireClosing {
                // 一定の割合を超えたスクロール、または、素早く下げた場合に一気に閉じる
                interactor.state = .shouldClose
            } else {
                interactor.state = .inProgress
            }
            // ハーフモーダルの位置を指の位置に合わせて移動させる
            interactor.update(progress)
        case .cancelled:
            interactor.cancel()
            interactor.reset()
        case .ended:
            switch interactor.state {
            case .shouldClose:
                interactor.finish()
            case .inProgress, .notInProgress, .startInteraction:
                interactor.cancel()
            }
            interactor.reset()
        default:
            break
        }
    }
}

// MARK: - SampleHalfModalViewDelegate

extension SampleHalfModalViewController: SampleHalfModalViewDelegate {
    
    func backgroundDidTap() {
        dismiss(animated: true, completion: nil)
    }
    
    // ヘッダーのジェスチャーを検知
    func headerGestureRecognized(_ sender: UIPanGestureRecognizer) {
        // インタラクトを開始する
        interactor.updateStateShouldStartIfNeeded()
        // ジェスチャー（移動量）に応じてハーフモーダルをクローズ
        handleTransitionGesture(sender)
    }
    
    // TableViewのジェスチャーを検知
    func tableViewGestureRecognized(_ sender: UIPanGestureRecognizer) {
        if tableViewContentOffsetY <= 0 {
            // ジェスチャー検知時にTableViewが目一杯上まで表示されている状態なら,
            // ハーフモーダルのクローズを開始する。
            interactor.updateStateShouldStartIfNeeded()
        }
        // ジェスチャー（移動量）に応じてハーフモーダルをクローズ
        handleTransitionGesture(sender)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableViewContentOffsetY = scrollView.contentOffset.y
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension SampleHalfModalViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        // ハーフモーダルの背景表示制御
        return ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HalfModalDismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        switch interactor.state {
        case .inProgress, .startInteraction:
            return interactor
        case .notInProgress, .shouldClose:
            return nil
        }
    }
}
