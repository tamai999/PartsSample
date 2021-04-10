//
//  ImageDetailAnimator.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let animateDuration: Double = 0.3
}

class ImageDetailAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - private properties
    
    private var isPresenting: Bool
    private let image: UIImage
    private let imageFrame: CGRect  // 遷移元のViewController.viewを基点としたFrame
    
    // MARK: - lifecycle
    init(isPresenting: Bool, image: UIImage, imageFrame: CGRect) {
        self.isPresenting = isPresenting
        self.image = image
        self.imageFrame = imageFrame
    }
    
    func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Const.animateDuration
    }

    func animateTransition(using context: UIViewControllerContextTransitioning) {

        if isPresenting {
            
            guard let imageDetailVC = context.viewController(forKey: .to) as? ImageDetailViewController,
                  let AllImageVC = context.viewController(forKey: .from) else  {
                context.cancelInteractiveTransition()
                return
            }
            // 制約を変更する前に未適用のレイアウトを適用しておく
            imageDetailVC.view.layoutSubviews()
            // コンテナビューに画像詳細画面ビューを追加する
            context.containerView.addSubview(imageDetailVC.view)
            // コンテナビューに遷移アニメーション用の画像を追加する
            let animationView = UIView(frame: AllImageVC.view.frame)
            animationView.backgroundColor = .black

            let imageView = UIImageView(frame: imageFrame)
            imageView.image = image
            imageView.contentMode = imageDetailVC.imageView.contentMode
            animationView.addSubview(imageView)

            context.containerView.addSubview(animationView)

            // 画像詳細画面表示アニメーション
            animationView.alpha = 1.0
            imageDetailVC.view.alpha = 0.0
            UIView.animate(withDuration: transitionDuration(using: context),
                           animations: {
                            imageView.frame = imageDetailVC.imageView.frame
                            animationView.alpha = 1.0
                           },
                           completion: { didComplete in
                            imageDetailVC.view.alpha = 1.0
                            animationView.removeFromSuperview()
                            context.completeTransition(didComplete)
                           })
        } else {
            
            guard let imageDetailVC = context.viewController(forKey: .from) as? ImageDetailViewController,
                  let AllImageVC = context.viewController(forKey: .to) else  {
                context.cancelInteractiveTransition()
                return
            }
            
            // コンテナビューに遷移アニメーション用の画像を追加する

            let animationView = UIView(frame: AllImageVC.view.frame)
            animationView.backgroundColor = .black
            context.containerView.addSubview(animationView)
            
            let presentingFrame = imageDetailVC.view.frame
            let imageView = UIImageView(frame: presentingFrame)
            imageView.image = imageDetailVC.imageView.image
            imageView.contentMode = imageDetailVC.imageView.contentMode
            animationView.addSubview(imageView)

            // 画像詳細画面を閉じるアニメーション
            animationView.alpha = 1
            imageDetailVC.view.alpha = 0
            UIView.animate(withDuration: transitionDuration(using: context), animations: {
                animationView.alpha = 0
                imageView.frame = self.imageFrame
                
            }) { (_) in
                animationView.removeFromSuperview()
                context.completeTransition(true)
            }
        }
    }
}
