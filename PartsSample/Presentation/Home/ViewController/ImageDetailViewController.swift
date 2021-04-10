//
//  ImageDetailViewController.swift
//  PartsSample
//

import UIKit

// 画像の詳細を表示するクラス
class ImageDetailViewController: UIViewController {
    
    // MARK: - private properties
    
    private let image: UIImage
    
    // MARK: - internal properties

    let imageView = UIImageView()
    
    // MARK: - lifecycle
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
    }
}

// MARK: - private

private extension ImageDetailViewController {
    
    func setupView() {
        view.backgroundColor = .black
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        // 上下のスワイプジェスチャー
        let swipeGesture = UISwipeGestureRecognizer(target: self, action:#selector(swiped))
        swipeGesture.direction = [.down, .up]
        view.addGestureRecognizer(swipeGesture)
    }
    
    func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    @objc
    func swiped(sender: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
