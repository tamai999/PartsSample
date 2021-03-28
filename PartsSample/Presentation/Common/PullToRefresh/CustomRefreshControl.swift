//
//  CustomRefreshControl.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let maxPullDistance: CGFloat = 150
}

class CustomRefreshControl: UIRefreshControl {
    
    // MARK: - private properties

    private let animationView = RefreshAnimationView()
    private var isAnimating = false
    private var isEndRefreshingCalled = false
    
    // MARK: - lifecycle
    
    override init() {
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
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
            animationView.progress = min(abs(offsetY / Const.maxPullDistance), 1)
        }
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
    func setupView() {
        // デフォルトのインジケーターが見えないようにする
        tintColor = .clear
        // カスタムインジケーター
        addSubview(animationView)
        addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    func setupLayout() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
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
