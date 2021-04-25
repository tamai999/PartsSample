//
//  HomeCategoryPresenter.swift
//  PartsSample
//

import Foundation

class HomeCategoryPresenter {
    
    // MARK: - private properties
    
    private var viewController: Page1ViewController
    
    // MARK: - lifecycle
    
    init(viewController: Page1ViewController) {
        self.viewController = viewController
    }
}

// MARK: - event receiver

extension HomeCategoryPresenter {
    func onViewDidLoad() {
        // ダミーデータ
        let items = [
            CarouselViewItem(imageName: "item1", price: 1000),
            CarouselViewItem(imageName: "item2", price: 2000),
            CarouselViewItem(imageName: "item3", price: 3000),
            CarouselViewItem(imageName: "item4", price: 4000),
            CarouselViewItem(imageName: "item5", price: 1000),
            CarouselViewItem(imageName: "item6", price: 1000),
            CarouselViewItem(imageName: "item7", price: 1000),
            CarouselViewItem(imageName: "item8", price: 1000),
            CarouselViewItem(imageName: "item9", price: 100),
            CarouselViewItem(imageName: "item10", price: 100),
            CarouselViewItem(imageName: "item11", price: 100),
            CarouselViewItem(imageName: "item12", price: 100),
        ]
        
        let page1View = viewController.page1View
        page1View.addCarousel(name: "カルーセル（大）", carouseSize: .large, items: items.shuffled(), contentCategory: .category1)
        page1View.addCarousel(name: "カルーセル（大）", carouseSize: .large, items: items.shuffled(), contentCategory: .cateogry2)
        page1View.addCarousel(name: "カルーセル（中）", carouseSize: .medium, items: items.shuffled(), contentCategory: .category3)
        page1View.addCarousel(name: "カルーセル（中）", carouseSize: .medium, items: items.shuffled(), contentCategory: .category4)
        page1View.addCarousel(name: "カルーセル（小）", carouseSize: .small, items: items.shuffled(), contentCategory: .category5)

        page1View.addDebugView()
    }
    
    func onViewWillAppear() {
        // リフレッシュコントロール初期化
        viewController.page1View.resetRefreshControl()
        // ナビゲーションバーは非表示
        viewController.navigationController?.isNavigationBarHidden = true
    }
    
    func onWillEnterForeground() {
        // リフレッシュコントロール初期化
        viewController.page1View.resetRefreshControl()
    }
}
