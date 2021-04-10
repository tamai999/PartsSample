//
//  AllImagePresenter.swift
//  PartsSample
//

import UIKit

struct ImageItem {
    let image: UIImage
    let price: Int
}

public class AllImagePresenter {
    
    // MARK: - private properties
    
    private var viewController: AllImageViewController!
    private var isSelectMode = false
    
    private var lists: [(title: String, items: [ImageItem])] = []
    
    // MARK: - lifecycle
    init(viewController: AllImageViewController) {
        self.viewController = viewController
        
        setupDummyData()
    }
}

// MARK: - event receiver

extension AllImagePresenter {
    func onViewDidLoad() {
        // DBから読み込んでビューに設定する体のダミー
        viewController.updateImageList(lists: self.lists)
    }
    
    func onViewWillDisappear() {
        isSelectMode = false
        setSelectModeView()
    }
    
    func onEditButtonTapped() {
        isSelectMode = !isSelectMode
        setSelectModeView()
    }
    
    func onImageTapped(indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        guard section < lists.count, row < lists[section].1.count else { return }
        viewController.gotoImageDetailView(cell: indexPath, image: lists[section].items[row].image)
    }
}

// MARK: - private

private extension AllImagePresenter {
    func setSelectModeView() {
        // セルのチェックボックス表示
        viewController.allImageView.isSelectMode = isSelectMode
        // ツールバー表示
        viewController.navigationController?.setToolbarHidden(!isSelectMode, animated: true)
    }
    
    func setupDummyData() {
        var list1: [ImageItem] = []
        var list2: [ImageItem] = []
        var list3: [ImageItem] = []

        for i in 0 ..< 100 {
            let image: UIImage
            switch i % 6 {
            case 0: image = R.image.item1()!
            case 1: image = R.image.item2()!
            case 2: image = R.image.item3()!
            case 3: image = R.image.item4()!
            case 4: image = R.image.item5()!
            case 5: image = R.image.item6()!
            default:
                image = R.image.item7()!
            }
            list1.append(ImageItem(image: image, price: 100 + i))
            list2.append(ImageItem(image: image, price: 200 + i))
            list3.append(ImageItem(image: image, price: 300 + i))
        }
        lists.append(("画像リスト１", list1))
        lists.append(("画像リスト２", list2))
        lists.append(("画像リスト３", list3))
    }
}
