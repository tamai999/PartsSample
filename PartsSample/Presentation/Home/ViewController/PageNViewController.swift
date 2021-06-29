//
//  PageNViewController.swift
//  PartsSample
//

import UIKit

/// ホーム画面のダミーページ
class PageNViewController: PageViewController {
    
    // MARK: - private properties
    
    private weak var label: UILabel!
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        layoutViews()
    }
}

// MARK: - private

private extension PageNViewController {
    
    func setupViews() {
        view.backgroundColor = R.color.background()
        
        // ダミーラベル表示
        let label = UILabel()
        label.text = "ページ \(pageIndex + 1)"
        label.textColor = R.color.label()
        label.backgroundColor = R.color.background()
        view.addSubview(label)
        self.label = label
    }
    
    func layoutViews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
