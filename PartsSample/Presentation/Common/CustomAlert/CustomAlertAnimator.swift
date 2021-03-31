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
            guard let alertVC = context.viewController(forKey: .to) as? CustomAlertViewController,
                  let yConstraint = alertVC.centerYConstraint else  {
                context.cancelInteractiveTransition()
                return
            }
            // コンテナビューにアラートビューを追加する
            context.containerView.addSubview(alertVC.view)
            // 制約を変更する前に未適用のレイアウトを適用しておく
            alertVC.view.layoutIfNeeded()
            // アラート表示アニメーション（少し下からアラートが上がってくる）
            alertVC.view.alpha = 0.0
            yConstraint.constant = 0
            UIView.animate(withDuration: transitionDuration(using: context),
                           animations: {
                            alertVC.view.alpha = 1.0
                            alertVC.view.layoutIfNeeded()
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
