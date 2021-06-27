//
//  HalfModalDismissAnimator.swift
//  PartsSample
//

import UIKit

/// ハーフモーダル（ViewController）を閉じるアニメーションの時間・アニメーション終了位置の定義
class HalfModalDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let window = UIApplication.shared.keyWindow else { return }
        
        let container = transitionContext.containerView
        container.addSubview(fromVC.view)
        
        let finalFrame = CGRect(x: 0,
                                y: window.frame.height,
                                width: window.frame.width,
                                height: window.frame.height)
        // スワイプ（isInteractive）の場合は指の位置に合うようにリニアなアニメーションにする
        let option: UIView.AnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseIn
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: [option],
                       animations: {
                        fromVC.view.frame = finalFrame
                       }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
