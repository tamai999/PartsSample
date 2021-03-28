//
//  PageViewController.swift
//  PartsSample
//

import UIKit

/// ホーム画面のページ
class PageViewController: BaseViewController {
    
    // MARK: - internal properties
    
    let pageIndex: Int

    // MARK: - lifecycle
    
    required init(pageIndex: Int) {
        self.pageIndex = pageIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
