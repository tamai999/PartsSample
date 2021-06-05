//
//  HomePageViewController.swift
//  PartsSample
//

import UIKit

protocol HomePageViewControllerDelegate {
    /// ページが変更された
    /// - Parameter index: ページ番号(0~)
    func didPageChange(index: Int)
}

/// ホーム画面のページコントローラー
class HomePageViewController: UIPageViewController {
    
    // MARK: - private properties
    
    private let page1VC = Page1ViewController(pageIndex: 0)
    private let page2VC = Page2ViewController(pageIndex: 1)
    private let page3VC = Page3ViewController(pageIndex: 2)
    private let page4VC = Page4ViewController(pageIndex: 3)
    private let page5VC = PageNViewController(pageIndex: 4)
    
    // MARK: - internal properties
    
    var homePageDelegate: HomePageViewControllerDelegate?
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers([page1VC],
                           direction: .forward,
                           animated: false,
                           completion: nil)
        dataSource = self
        delegate = self
    }
    
    // MARK: - internal methods
    
    /// ページを切り替える
    /// - Parameter index: 表示するページ番号(0~)
    func setPage(_ index: Int) {
        let tagetVC: PageViewController
        switch index {
        case 1: tagetVC = page2VC
        case 2: tagetVC = page3VC
        case 3: tagetVC = page4VC
        case 4: tagetVC = page5VC
        default: tagetVC = page1VC
        }
        
        if let currentVC = viewControllers?.first as? PageViewController {
            var direction: NavigationDirection = .forward
            if tagetVC.pageIndex < currentVC.pageIndex {
                direction = .reverse
            }
            setViewControllers([tagetVC],
                               direction: direction,
                               animated: true,
                               completion: nil)
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension HomePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let pageVC = viewController as? PageViewController else { return nil }
        let pageIndex = pageVC.pageIndex
        
        // 右から左にスワイプ（無限ループ）
        switch pageIndex {
        case 4: return page4VC
        case 3: return page3VC
        case 2: return page2VC
        case 1: return page1VC
        case 0: return page5VC
        default: return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let pageVC = viewController as? PageViewController else { return nil }
        let pageIndex = pageVC.pageIndex
        
        // 左から右にスワイプ（無限ループ）
        switch pageIndex {
        case 0: return page2VC
        case 1: return page3VC
        case 2: return page4VC
        case 3: return page5VC
        case 4: return page1VC
        default: return nil
        }
    }
}

// MARK: - UIPageViewControllerDelegate

extension HomePageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed else { return }
        
        // ページめくりが完了したら遷移後のページを通知する
        if let pageVC = pageViewController.viewControllers?.first as? PageViewController {
            homePageDelegate?.didPageChange(index: pageVC.pageIndex)
        }
    }
}
