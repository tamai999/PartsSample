//
//  CarouselView.swift
//  PartsSample
//

import UIKit

protocol CarouselViewProtocol {
    func didTapDetailButton(carouselTag: Int)
}

struct CarouselViewItem {
    let imageName: String
    let price: Int
}

fileprivate struct Const {
    static let layoutMargin: CGFloat = 2.0
    static let labelCarouselSpace: CGFloat = 2.0
    static let titleLeftMargin: CGFloat = 10
    static let titleHeight: CGFloat = 35
    static let detailButtonRightMargin: CGFloat = 10
    static let scrollViewMargin: CGFloat = 2
    static let itemStackViewVerticalMargin: CGFloat = 10
    static let itemStackViewSpace: CGFloat = 6
}

/// カルーセルビュー
class CarouselView: UIView {
    
    // MARK: - private properties
    private weak var stackView: UIStackView!
    private weak var titleLabel: UILabel!
    private weak var detailButton: UIButton!
    private weak var scrollView: UIScrollView!
    private weak var itemStackView: UIStackView!
    
    private var aspectConstraint: NSLayoutConstraint?
    
    // カルーセルの大きさ
    private var size: CarouseSize = .large
    private var carouselTag: Int = 0
    
    var delegate: CarouselViewProtocol?
    
    enum CarouseSize {
        case large, medium, small
        // カルーセルの大きさ別のビューの縦横比
        func aspectRatio(sizeClass: UIUserInterfaceSizeClass) -> CGFloat {
            // TODO: アスペクト比は要調整
            if sizeClass == .compact {
                switch self {
                case .large:  return 0.4
                case .medium: return 0.3
                default: return 0.2
                }
            } else {
                switch self {
                case .large:  return 0.24
                case .medium: return 0.2
                default: return 0.15
                }
            }
        }
    }
    
    // MARK: - lifecycle
    init(title: String, size: CarouseSize, tag: Int) {
        super.init(frame: CGRect.zero)
        
        setupViews(title: title)
        setupLayout(size)
        
        self.size = size
        carouselTag = tag
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let constraint = aspectConstraint {
            constraint.isActive = false
            scrollView.removeConstraint(constraint)
        }
        let aspectRatio: CGFloat
        if traitCollection.horizontalSizeClass == .regular {
            aspectRatio = size.aspectRatio(sizeClass: .regular)
        } else {
            aspectRatio = size.aspectRatio(sizeClass: .compact)
        }
        
        aspectConstraint = scrollView.heightAnchor.constraint(equalTo: scrollView.widthAnchor,
                                                              multiplier: aspectRatio)
        aspectConstraint?.isActive = true
    }
    
    // MARK: - internal methods
    
    /// カルーセルにアイテムを設定
    /// - Parameter items: アイテムの配列
    func setItems(_ items: [CarouselViewItem]) {
        items.forEach { item in
            setupItem(item)
        }
    }
}

// MARK: - private

private extension CarouselView {
    
    func setupViews(title: String) {
        layer.masksToBounds = true
        // レイアウト
        let stackView = UIStackView()
        stackView.backgroundColor = R.color.carouselBackground()
        addSubview(stackView)
        self.stackView = stackView
        // タイトル
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.backgroundColor = R.color.carouselBackground()
        titleLabel.textColor = R.color.label()
        titleLabel.font = UIFont.titleFont
        stackView.addArrangedSubview(titleLabel)
        self.titleLabel = titleLabel
        // すてべ見る
        let detailButton = UIButton()
        detailButton.setTitle("すべて見る", for: .normal)
        detailButton.titleLabel?.font = UIFont.linkFont
        detailButton.setTitleColor(R.color.linkText(), for: .normal)
        detailButton.addTarget(self, action: #selector(didTapDetailButton), for: .touchUpInside)
        addSubview(detailButton)
        self.detailButton = detailButton
        // スクロールビュー
        let scrollView = UIScrollView()
        scrollView.backgroundColor = R.color.carouselBackground()
        stackView.addArrangedSubview(scrollView)
        self.scrollView = scrollView
        // アイテムスタックビュー
        let itemStackView = UIStackView()
        scrollView.addSubview(itemStackView)
        self.itemStackView = itemStackView
    }
    
    func setupLayout(_ type: CarouseSize) {
        // レイアウト
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = Const.labelCarouselSpace
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // タイトル
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(stackView.snp.left).offset(Const.titleLeftMargin)
            make.height.equalTo(Const.titleHeight)
        }
        // すべて見る
        detailButton.snp.makeConstraints { make in
            make.right.equalTo(stackView.snp.right).offset(-Const.detailButtonRightMargin)
            make.centerY.equalTo(titleLabel)
        }
        
        // カルーセル領域。縦のサイズは横との比率で指定
        scrollView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Const.scrollViewMargin)
            make.right.equalToSuperview().offset(-Const.scrollViewMargin)
        }
        aspectConstraint = scrollView.heightAnchor.constraint(equalTo: scrollView.widthAnchor,
                                                              multiplier: type.aspectRatio(sizeClass: .unspecified))
        aspectConstraint?.isActive = true
        
        // スクロールビュー内スタックビュー
        itemStackView.axis = .horizontal
        itemStackView.alignment = .bottom
        itemStackView.distribution = .equalSpacing
        itemStackView.spacing = Const.itemStackViewSpace
        itemStackView.snp.makeConstraints { make in
            make.top.left.right.equalTo(scrollView.contentLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide).offset(-Const.itemStackViewVerticalMargin)
        }
    }
    
    func setupItem(_ item: CarouselViewItem) {
        // アイテムビューのセットアップ
        let itemView = ItemView(imageName: item.imageName,
                            price: item.price)
        itemStackView.addArrangedSubview(itemView)
        // レイアウト
        itemView.snp.makeConstraints { make in
            make.height.equalTo(itemStackView)
        }
    }
    
    @objc func didTapDetailButton(sender: Any) {
        delegate?.didTapDetailButton(carouselTag: carouselTag)
    }
}
