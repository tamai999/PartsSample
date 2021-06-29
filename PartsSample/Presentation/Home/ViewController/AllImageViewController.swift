//
//  AllImageViewController.swift
//  PartsSample
//

import UIKit

/// 画像一覧画面
class AllImageViewController: UIViewController {
    
    // MARK: - private properties
    
    private var type = ContentCategory.category1
    private lazy var presenter = AllImagePresenter(viewController: self)

    // MARK: - internal properties
    
    weak var allImageView: AllImageView!
    var selectedCellIndex: IndexPath?

    // MARK: - lifecycle
    
    init(type: ContentCategory) {
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        presenter.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ナビゲーションバーを表示
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.onViewWillDisappear()
    }
    
    // MARK: - internal

    // 画像を更新する
    func updateImageList(lists: [(String, [ImageItem])]) {
        DispatchQueue.main.async {
            self.allImageView.setItemLists(lists)
        }
    }
    
    // 画像詳細画面を表示する
    func gotoImageDetailView(cell: IndexPath, image: UIImage) {
        DispatchQueue.main.async {
            // 画面遷移アニメーションのため選択されたセルを保存し、アニメーションの基点とする
            self.selectedCellIndex = cell
            
            let vc = ImageDetailViewController(image: image)
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
        }
    }
}

// MARK: - private

private extension AllImageViewController {
    
    func setupViews() {
        let allImageView = AllImageView()
        view.addSubview(allImageView)
        self.allImageView = allImageView
        
        allImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        allImageView.delegate = self
        // タイトル
        title = "タイプ [\(type.rawValue)]"
        // メニュー
        let editButton = UIBarButtonItem()
        editButton.title = "編集"
        editButton.style = .plain

        if #available(iOS 14.0, *) {
            let barButtonMenu = UIMenu(title: "", children: [
                UIAction(title: NSLocalizedString("選択", comment: ""), image: UIImage(systemName: "checkmark"), handler: menuHandler),
                UIAction(title: NSLocalizedString("削除", comment: ""), image: UIImage(systemName: "trash"), handler: menuHandler),
            ])
            editButton.menu = barButtonMenu
            
        } else {
            editButton.target = self
            editButton.action = #selector(action(_:))
        }
        navigationItem.rightBarButtonItem = editButton
        // ツールバー
        let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionTapped))
        actionButton.tintColor = R.color.label()
        let trashutton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashTapped))
        trashutton.tintColor = R.color.label()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [actionButton, space, trashutton]
    }

    @objc
    func action(_ sender: AnyObject) {
        // TODO:
    }
    
    @available(iOS 14.0, *)
    func menuHandler(action: UIAction) {
        print("Menu handler: \(action.title)")
        
        presenter.onEditButtonTapped()
    }
    
    @objc
    func actionTapped(sender: Any) {
        presenter.onEditButtonTapped()
    }
    
    @objc
    func trashTapped(sender: Any) {
        presenter.onEditButtonTapped()
    }
}

// MARK: - AllImageViewDelegate

extension AllImageViewController: AllImageViewDelegate {
    func didTapImageCell(indexPath: IndexPath) {
        presenter.onImageTapped(indexPath: indexPath)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension AllImageViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let imageInfo = getImageInfo() else { return nil}
        return ImageDetailAnimator(isPresenting: true, image: imageInfo.image, imageFrame: imageInfo.frame)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let imageInfo = getImageInfo() else { return nil}
        return ImageDetailAnimator(isPresenting: false, image: imageInfo.image, imageFrame: imageInfo.frame)
    }

    // 遷移元の画像とフレームを取得
    private func getImageInfo() -> (image: UIImage, frame: CGRect)? {
        guard let index = selectedCellIndex,
              let cell = allImageView.collectionView.cellForItem(at: index) as? ImageItemCellView,
              let image = cell.imageView.image else { return nil }
        let frame = cell.imageView.superview!.convert(cell.imageView.frame, to: self.view)
        return (image, frame)
    }
}

