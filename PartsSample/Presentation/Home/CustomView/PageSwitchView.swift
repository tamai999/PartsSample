//
//  PageSwitchView.swift
//  PartsSample
//

import UIKit
import SnapKit

protocol  PageSwitchViewDelegate {
    // ページ切り替えボタンがタップされた
    func didTapPageButton(index: Int)
}

fileprivate struct Const {
    static let scrollViewHeight: CGFloat = 30
    static let pageLabelWidth: CGFloat = 100
    static let pageStackViewSpace: CGFloat = 0
    static let pageStackViewVerticalMargin: CGFloat = 2
    static let pageIndicatorHeight: CGFloat = 2
}

/// ページ切り替えビュー
class PageSwitchView: UIView {
    
    // MARK: - private properties
    
    private weak var scrollView: UIScrollView!
    private weak var pageStackView: UIStackView!
    private weak var pageIndicator: UIView!
    private weak var pageIndicatorXConstraint: NSLayoutConstraint?
    private var pageNames: [String] = []
    private var currentIndex = -1
    
    // MARK: - internal properties
    
    var delegate: PageSwitchViewDelegate?
    
    // MARK: - lifecycle
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(pageNames: [String]) {
        super.init(frame: CGRect.zero)
        
        self.pageNames = pageNames
        
        setupViews()
        layoutViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // ページスタックビューの横幅を計算する
        let pageStackViewWidth = Const.pageLabelWidth * CGFloat(pageStackView.arrangedSubviews.count)
        if bounds.width > pageStackViewWidth {
            // ページスイッチの表示幅より画面幅が大きければ、スクロール位置を中央にしておく
            let offsetX = self.scrollView.bounds.width / 2 - pageStackViewWidth / 2
            self.scrollView.setContentOffset(CGPoint(x: -offsetX, y: 0), animated: false)
        }
        // 子ビューのレイアウトが終わったらスクロール位置を再設定するようにレイアウトし直す
        setNeedsLayout()
    }
    
    // MARK: - internal methods
    
    /// ページ切り替えビューの表示ページを変更する（適宜スクロールする）
    /// - Parameter index: ページ番号(0~)
    func updatePageIndex(_ index: Int, animated: Bool = true) {
        guard index < pageStackView.arrangedSubviews.count else { return }
        currentIndex = index
        
        let buttonWidth = scrollView.contentSize.width / CGFloat(pageStackView.arrangedSubviews.count)
        if scrollView.bounds.width < scrollView.contentSize.width {
            // ページのラベルをスクロール
            
            // 左端からのペーボタンの中心座標
            let pageCenter = (buttonWidth / 2) + (buttonWidth * CGFloat(index))
            // ウィンドの横幅を取得
            let viewCenter = bounds.width / 2
            // スクロール範囲を超えたスクロールはさせない
            var offsetX = pageCenter - viewCenter
            offsetX = max(offsetX, 0)
            offsetX = min(offsetX, scrollView.contentSize.width - bounds.width)
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
        }
        
        // ページのインジケーターを移動する
        layoutIfNeeded()
        if let constraint = pageIndicatorXConstraint {
            constraint.isActive = false
            pageIndicator.removeConstraint(constraint)
        }
        let indicatorX = CGFloat(index) * buttonWidth
        pageIndicatorXConstraint = pageIndicator.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: indicatorX)
        pageIndicatorXConstraint?.isActive = true

        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    /// ウィンドの幅が変わった等によりインデックスが中央に来るようにレイアウトしなおす
    func updateLayoutWithCurrentIndex() {
        if currentIndex != -1 {
            updatePageIndex(currentIndex, animated: false)
        }
    }
}

// MARK: - private

private extension PageSwitchView {
    private func setupViews() {
        // スクロールビュー
        let scrollView = UIScrollView()
        scrollView.backgroundColor = R.color.carouselBackground()
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        self.scrollView = scrollView
        // スクロールビュー内スタックビュー
        let pageStackView = UIStackView()
        scrollView.addSubview(pageStackView)
        self.pageStackView = pageStackView
        // ページ切り替えボタン
        pageNames.enumerated().forEach() { page in
            // ボタン生成
            let button = UIButton()
            button.setTitle(page.element, for: .normal)
            button.tag = page.offset
            button.titleLabel?.font = UIFont.pageSwitcherFont
            button.setTitleColor(R.color.label(), for: .normal)
            button.addTarget(self, action: #selector(didTapPageButton), for: .touchUpInside)
            
            pageStackView.addArrangedSubview(button)
        }
        // ページのインジケーター
        let pageIndicator = UIView()
        pageIndicator.backgroundColor = R.color.pageSelected()
        scrollView.addSubview(pageIndicator)
        self.pageIndicator = pageIndicator
    }
    
    func layoutViews() {
        // ページ切り替えスクロールビュー
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
            make.height.equalTo(Const.scrollViewHeight)
        }
        
        // スクロールビュー内のスタックビュー
        pageStackView.axis = .horizontal
        pageStackView.alignment = .center
        pageStackView.distribution = .equalSpacing
        pageStackView.spacing = Const.pageStackViewSpace
        pageStackView.snp.makeConstraints { make in
            make.top.left.right.equalTo(scrollView.contentLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide).offset(-Const.pageStackViewVerticalMargin)
        }
        
        // ページ切り替えボタン
        pageStackView.arrangedSubviews.forEach() { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(Const.pageLabelWidth)
            }
        }
        
        // ページのインジケーター
        pageIndicator.snp.makeConstraints { make in
            make.height.equalTo(Const.pageIndicatorHeight)
            make.width.equalTo(Const.pageLabelWidth)
            make.bottom.equalTo(pageStackView.snp.bottom)
        }
        pageIndicatorXConstraint = pageIndicator.leftAnchor.constraint(equalTo: scrollView.leftAnchor)
        pageIndicatorXConstraint?.isActive = true        
    }
    
    @objc func didTapPageButton(sender: UIView) {
        delegate?.didTapPageButton(index: sender.tag)
    }
}
