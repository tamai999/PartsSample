//
//  HomeView.swift
//  PartsSample
//

import UIKit
import SnapKit

protocol HomeViewDelegate {
    // ページ切り替えボタンがタップされた
    func didTapPageButton(index: Int)
}

fileprivate struct Const {
    static let hederViewHeight: CGFloat = 44
    static let pageSwitchViewHeight: CGFloat = 30
}

/// ホーム画面ビュー
class HomeView: UIView {
    
    // MARK: - private properties
    
    private weak var headerView: SearchHeaderView!
    private weak var pageSwitchView: PageSwitchView!
    
    // MARK: - internal properties
    
    var delegate: HomeViewDelegate?
    
    // MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - internal methods
    
    /// PageViewControllerのビューをサブビューに設定
    /// - Parameter pageView: PageViewControllerのビュー
    func setupPageView(_ pageView: UIView) {
        addSubview(pageView)
        pageView.snp.makeConstraints { make in
            make.top.equalTo(pageSwitchView.snp.bottom)
            make.left.right.bottom.equalTo(self)
        }
    }
    
    /// ページ切り替えビューの表示ページを変更する
    /// - Parameter index: ページ番号(0~)
    func setPageIndex(_ index: Int) {
        pageSwitchView.updatePageIndex(index)
    }
    
    /// レイアウトし直す
    func updateLayout() {
        pageSwitchView.updateLayoutWithCurrentIndex()
    }
}

// MARK: - private

private extension HomeView {
    
    func setupViews() {
        backgroundColor = R.color.background()
        // ヘッダービュー
        let headerView = SearchHeaderView(frame: CGRect.zero)
        addSubview(headerView)
        self.headerView = headerView
        // ページ切り替えビュー
        let pageSwitchView = PageSwitchView(pageNames: ["ページ１", "ページ２", "ページ３", "ページ４", "ページ５"])
        pageSwitchView.delegate = self
        addSubview(pageSwitchView)
        self.pageSwitchView = pageSwitchView
    }
    
    func layoutViews() {
        // ヘッダービュー
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Const.hederViewHeight)
        }
        
        // ページ切り替えビュー
        pageSwitchView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(Const.pageSwitchViewHeight)
        }
    }
}

// MARK: - PageSwitchViewDelegate

extension HomeView: PageSwitchViewDelegate {
    func didTapPageButton(index: Int) {
        delegate?.didTapPageButton(index: index)
    }
}
