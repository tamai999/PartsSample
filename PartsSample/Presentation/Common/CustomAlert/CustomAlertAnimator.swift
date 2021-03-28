//
//  CustomAlertAnimator.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let animateDuration: Double = 0.2
}

class CustomAlertAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - private properties

    private let isPresenting: Bool
    
    // MARK: - lifecycle
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Const.animateDuration
    }

    func animateTransition(using context: UIViewControllerContextTransitioning) {
        if isPresenting {
            //
            // アラート表示アニメーション
            //
            guard let toVC = context.viewController(forKey: .to),
                  let alertVC = toVC as? CustomAlertViewController,
                  let yConstraint = alertVC.centerYConstraint else  {
                context.cancelInteractiveTransition()
                return
            }
            // コンテナビューにアラートビューを追加する
            context.containerView.addSubview(toVC.view)
            // 制約を変更する前に未適用のレイアウトを適用しておく
            toVC.view.layoutIfNeeded()
            // アラート表示アニメーション（少し下からアラートが上がってくる）
            toVC.view.alpha = 0.0
            yConstraint.constant = 0
            UIView.animate(withDuration: transitionDuration(using: context),
                           animations: {
                            toVC.view.alpha = 1.0
                            toVC.view.layoutIfNeeded()
                           },
                           completion: { didComplete in
                            context.completeTransition(didComplete)
                           })
        } else {
            //
            // アラート非表示アニメーション
            //
            guard let fromView = context.view(forKey: .from) else  {
                context.cancelInteractiveTransition()
                return
            }

            fromView.alpha = 1
            UIView.animate(withDuration: transitionDuration(using: context),
                           animations: {
                            fromView.alpha = 0
                           },
                           completion: { didComplete in
                            context.completeTransition(didComplete)
                           })
        }
    }
}
