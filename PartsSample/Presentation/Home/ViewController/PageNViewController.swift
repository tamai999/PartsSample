//
//  PageNViewController.swift
//  PartsSample
//

import UIKit

/// ホーム画面のダミーページ
class PageNViewController: PageViewController {
    
    // MARK: - private properties
    
    private let label = UILabel()
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
    }
}

// MARK: - private

private extension PageNViewController {
    
    func setupView() {
        view.backgroundColor = R.color.background()
        
        // ダミーラベル表示
        label.text = "ページ \(pageIndex + 1)"
        label.textColor = R.color.label()
        label.backgroundColor = R.color.background()
        view.addSubview(label)
    }
    
    func setupLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
