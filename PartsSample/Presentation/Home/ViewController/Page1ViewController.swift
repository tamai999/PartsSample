//
//  Page1ViewController.swift
//  PartsSample
//

import UIKit

enum ContentCategory: Int {
    case category1 = 1, cateogry2, category3, category4, category5
}

/// ホーム画面の１ページ目
class Page1ViewController: PageViewController {
    
    // MARK: - private properties
    
    private lazy var presenter = HomeCategoryPresenter(viewController: self)

    // MARK: - internal properties
    
    var page1View = Page1View()
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter.onViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.onViewWillAppear()
    }
    
    override func willEnterForeground() {
        super.willEnterForeground()
        
        presenter.onWillEnterForeground()
    }
}

// MARK: - private

private extension Page1ViewController {
    func setupView() {
        view.addSubview(page1View)
        page1View.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        page1View.delegate = self
    }
}

// MARK: - Page1ViewProtocol

extension Page1ViewController: Page1ViewProtocol {
    func didTapDetailButton(carouselTag: Int) {
        guard let type = ContentCategory(rawValue: carouselTag) else { return }

        let nextVC = AllImageViewController(type: type)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
