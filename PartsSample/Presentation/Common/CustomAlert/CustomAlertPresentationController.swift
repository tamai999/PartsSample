//
//  CustomAlertPresentationController.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let overlayViewAlpha: CGFloat = 0.5
}

/// アラートの表示元ViewControllerを透過表示するためのオーバーレイビューの制御
class CustomAlertPresentationController: UIPresentationController {
    // MARK: - private properties
    
    /// 呼び出し元のViewControllerの上に重ねるオーバーレイ
    private let overlayView = UIView()
}

// MARK: - UIPresentationController

extension CustomAlertPresentationController {
    
    /// 遷移開始時に処理
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        // カスタムビュー（グレーの透過ビュー）
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.0
        containerView?.insertSubview(overlayView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.overlayView.alpha = Const.overlayViewAlpha
        })
    }

    /// 遷移を完了できなかったときの処理
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        if !completed {
            overlayView.removeFromSuperview()
        }
    }
    
    /// アラートを閉じる際の処理
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.overlayView.alpha = 0.0
        })
    }
    
    /// アラートを閉じる処理が完了したときの処理
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)

        if completed {
            overlayView.removeFromSuperview()
        }
    }

    /// 新しいViewControllerのCGRectを返す
    override var frameOfPresentedViewInContainerView : CGRect {
        return containerView!.bounds
    }
    
    /// 画面回転等によるレイアウトの変更を行う
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        /// レイアウト開始前の処理
        overlayView.frame = containerView!.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
