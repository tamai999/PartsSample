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

    weak var imageView: UIImageView!
    
    // MARK: - lifecycle
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        layoutViews()
    }
}

// MARK: - private

private extension ImageDetailViewController {
    
    func setupViews() {
        view.backgroundColor = .black
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        self.imageView = imageView
        
        // 上下のスワイプジェスチャー
        let swipeGesture = UISwipeGestureRecognizer(target: self, action:#selector(swiped))
        swipeGesture.direction = [.down, .up]
        view.addGestureRecognizer(swipeGesture)
    }
    
    func layoutViews() {
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
