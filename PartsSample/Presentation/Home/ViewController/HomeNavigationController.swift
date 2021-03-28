//
//  HomeNavigationController.swift
//  PartsSample
//

import UIKit

class HomeNavigationController: UINavigationController {
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ダークモードの切り替え通知を受け取る（配色確認用）
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeToDarkMode),
                                               name: .didChangeToDarkMode,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeToLightMode),
                                               name: .didChangeToLightMode,
                                               object: nil)
    }
}

// MARK: - private

private extension HomeNavigationController {
    
    @objc func didChangeToDarkMode() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
    }
    
    @objc func didChangeToLightMode() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
}
