//
//  RefreshAnimationView.swift
//  PartsSample
//

import UIKit

class RefreshAnimationView: UIView {
    
    // MARK: - private properties

    private let imageView = UIImageView()
    private var animator: UIViewPropertyAnimator?
    private var animationCounter = 0
    
    var progress: CGFloat {
        didSet {
            animator?.fractionComplete = progress / 2   // 回転量調整
            imageView.alpha = progress
        }
    }
    
    // MARK: - lifecycle
    
    override init(frame: CGRect) {
        progress = 0.0
        super.init(frame: .zero)
        
        setupView()
        setupAnimator()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - internal methods
    
    /// アニメーション開始
    func start() {
        imageView.alpha = 1.0
        animator?.startAnimation()
    }
    
    /// アニメーション停止（終了アニメーション開始）
    func stop() {
        animator?.stopAnimation(true)
        // 画像を小さくするアニメーションを行う
        UIView.animate(withDuration: 0.2) {
            self.imageView.bounds.size.width = 4.0
            self.imageView.bounds.size.height = 4.0
        }
    }
    
    /// アニメーションリセット
    func reset() {
        // アニメーションの状態を初期化する
        imageView.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        imageView.transform = CGAffineTransform(rotationAngle: 0)
        animationCounter = 0
        if case .some(.active) = animator?.state {
            // もしアニメーションがActiveだったら止める
            animator?.stopAnimation(true)
        }
        setupAnimator()
    }
}

// MARK: - private

private extension RefreshAnimationView {
    
    func setupView() {
        backgroundColor = .clear
        
        // アニメーションビュー
        imageView.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        if #available(iOS 13.0, *) {
            imageView.backgroundColor = .clear
            imageView.image = UIImage(systemName: "applelogo")
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = R.color.label()
        } else {
            imageView.backgroundColor = .red
        }
        addSubview(imageView)
    }
    
    func setupAnimator() {
        // 90度単位で回転アニメーションを繰り返す。
        // (アニメーションが逆回転しないように180度以上に設定しないほうが良いため）
        imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2 * CGFloat(animationCounter))
        animationCounter += 1
        
        let animator = UIViewPropertyAnimator(duration: 1.0,
                                              timingParameters: UICubicTimingParameters(animationCurve: .linear))
        let counter = CGFloat(animationCounter)
        animator.addAnimations { [weak self] in
            self?.imageView.transform = CGAffineTransform(rotationAngle: CGFloat(CGFloat.pi / 2 * counter))
        }
        animator.addCompletion { [weak self] position in
            if position == .end, animator.isRunning {
                // アニメーション動作継続中にアニメーション終了通知が来たら、アニメーションを再設定し、スタートさせる。
                // アニメーション停止状態でアニメーション終了通知が来ることがあるので、その場合はアニメーションを再設定しないこと（無限ループしてしまう）
                // （UIViewPropertyAnimatorでリピートさせる方法不明なため）
                self?.setupAnimator()
                self?.animator?.startAnimation()
            }
        }
        self.animator = animator
    }
}
