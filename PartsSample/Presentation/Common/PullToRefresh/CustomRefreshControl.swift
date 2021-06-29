//
//  CustomRefreshControl.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let maxPullDistance: CGFloat = 150
    // アニメーションビューがスクロールビューのコンテントの上に位置するようにするためのオフセット
    static let animationViewYOffset: CGFloat = 60
}

class CustomRefreshControl: UIRefreshControl {
    
    // MARK: - private properties

    private weak var animationView: RefreshAnimationView!
    private var isAnimating = false
    private var isEndRefreshingCalled = false
    private var animationViewYConstraint: NSLayoutConstraint?
    
    // MARK: - lifecycle
    
    override init() {
        super.init(frame: .zero)
        
        setupViews()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func endRefreshing() {
        super.endRefreshing()
        
        animationView.stop()
        isEndRefreshingCalled = true
    }
    
    // MARK: - internal
    
    /// スクロールビューを下に引っ張っている間（リフレッシュを開始まで）のアニメーションを行う。
    /// - Parameter offsetY: スクロールビューの contentOffset.y を指定する
    func updateProgress(with offsetY: CGFloat) {
        if isEndRefreshingCalled && offsetY >= 0.0 {
            // endRefreshing() のタイミングではなく、
            // endRefreshing()が呼ばれた後、スクロール位置が先頭に戻ったタイミングで一連のアニメーション完了とする。
            // これにより、スクロール位置が戻る際に、アニメーションが巻き戻ることを防ぐ。
            reset()
        }
        
        if !isAnimating {
            // インジケーター回転
            let progress = min(abs(offsetY / Const.maxPullDistance), 1)
            animationView.progress = progress
        }
        
        // インジケーター縦位置調整
        animationViewYConstraint?.constant = -offsetY - Const.animationViewYOffset
    }
    
    /// リフレッシュ中でなければリフレッシュビューを初期化する
    func resetIfNotRefreshing() {
        if !isRefreshing {
            reset()
        }
    }
}

// MARK: - private

private extension CustomRefreshControl {
    func setupViews() {
        // デフォルトのインジケーターが見えないようにする
        tintColor = .clear
        // カスタムインジケーター
        let animationView = RefreshAnimationView()
        addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        addSubview(animationView)
        self.animationView = animationView
    }
    
    func layoutViews() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        animationViewYConstraint = animationView.centerYAnchor.constraint(equalTo: centerYAnchor)
        animationViewYConstraint?.isActive = true
    }
    
    @objc func handleRefreshControl() {
        if isRefreshing {
            // インジケーターアニメーション開始
            isAnimating = true
            animationView.start()
        }
    }
    
    func reset() {
        isAnimating = false
        isEndRefreshingCalled = false
        animationView.reset()
    }
}
