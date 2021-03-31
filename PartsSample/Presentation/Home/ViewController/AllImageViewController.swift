//
//  AllImageViewController.swift
//  PartsSample
//

import UIKit

/// ホーム画面のページ
class AllImageViewController: UIViewController {
    
    // MARK: - private properties
    
    private var type = ContentCategory.category1
    private lazy var presenter = AllImagePresenter(viewController: self)

    // MARK: - internal properties
    
    let allImageView = AllImageView()

    // MARK: - lifecycle
    
    init(type: ContentCategory) {
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
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
    func gotoImageDetailView(image: UIImage) {
        DispatchQueue.main.async {
            let vc = ImageDetailViewController(image: image)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}

// MARK: - private

private extension AllImageViewController {
    
    func setupView() {
        // ビューを差し替える
        view = allImageView
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
    func didTapImageCell(section: Int, row: Int) {
        presenter.onImageTapped(section: section, row: row)
    }
}
