//
//  AppDelegate.swift
//  PartsSample
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupNavigationBar()
        
        return true
    }
    
    /// ナビゲーションバーの共通事項セットアップ
    /// - note: ナビゲーションバーのカスタマイズはAppleのサンプル [Customizing Your App’s Navigation Bar](https://developer.apple.com/documentation/uikit/uinavigationcontroller/customizing_your_app_s_navigation_bar) が参考になる。
    private func setupNavigationBar() {

        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = R.image.navigation_bg()
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
        }

        UINavigationBar.appearance().tintColor = R.color.label()
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: R.color.label()!]
    }
}

