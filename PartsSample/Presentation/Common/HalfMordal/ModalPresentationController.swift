//
//  ModalPresentationController.swift
//  PartsSample
//

import UIKit

/// ViewControllerの上のViewControllerを配置する際の半透明ビューの表示制御
class ModalPresentationController: UIPresentationController {
    private var overlay: UIView?
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let container = containerView else { return }
        let overlay = UIView()
        overlay.frame = container.frame
        overlay.backgroundColor = .black
        overlay.alpha = 0.0
        container.insertSubview(overlay, at: 0)
        self.overlay = overlay
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.overlay?.alpha = 0.5
        })
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.overlay?.alpha = 0.0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            overlay?.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        return container.bounds
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        guard let container = containerView else { return }
        overlay?.frame = container.frame
    }
}
