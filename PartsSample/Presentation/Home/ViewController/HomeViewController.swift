//
//  HomeViewController.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let navigationTitle = "ホーム画面に戻る"
}

/// ホーム画面
class HomeViewController: UIViewController {
    
    // MARK: - private properties
    
    private weak var homeView: HomeView!
    private var pageViewController: HomePageViewController?
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 初期ページ設定
        homeView.setPageIndex(0)
    }
}

// MARK: - private 

private extension HomeViewController {
    func setupViews() {
        let homeView = HomeView()
        view.addSubview(homeView)
        self.homeView = homeView
        
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // ビューからイベントを受け取る
        homeView.delegate = self
        
        // ページビューコントローラーを子ビューコントローラー化
        let viewController = HomePageViewController(transitionStyle: .scroll,
                                                    navigationOrientation: .horizontal,
                                                    options: nil)
        pageViewController = viewController
        addChild(viewController)
        viewController.didMove(toParent: self)
        // ページ切り替えイベントを受け取る
        pageViewController?.homePageDelegate = self
        // ページビューコントローラーのビューをHomeViewの管理下に置く
        homeView.setupPageView(viewController.view)
        // 遷移先画面の戻るボタン表示指定
        if #available(iOS 14.0, *) {
            // 戻るボタン長押しの時に表示されるタイトル名を設定
            navigationItem.backButtonTitle = Const.navigationTitle
            // 戻るボタンを「＜」表示だけにする
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backButtonTitle = " "
        }
    }
}

// MARK: - HomePageViewControllerDelegate

extension HomeViewController: HomePageViewControllerDelegate {
    func didPageChange(index: Int) {
        homeView.setPageIndex(index)
    }
}

// MARK: - HomeViewDelegate

extension HomeViewController: HomeViewDelegate {
    func didTapPageButton(index: Int) {
        // ページ切り替えビューの選択状態更新
        homeView.setPageIndex(index)
        // 指定ページ遷移
        pageViewController?.setPage(index)
    }
}
