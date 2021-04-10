//
//  ImageItemCellView.swift
//  PartsSample
//

import UIKit

fileprivate struct Const {
    static let priceLabelHeight: CGFloat = 20
}

class ImageItemCellView: UICollectionViewCell {
    
    // MARK: - private properties

    private let priceLabel = UILabel()
    private let checkImageView = UIImageView()
    
    private var dentAnimator: UIViewPropertyAnimator?
    
    private var isSelectMode = false
    
    // MARK: - internal properties

    let imageView = UIImageView()

    var isChecked = false {
        didSet {
            if #available(iOS 13.0, *) {
                if isChecked {
                    checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
                } else {
                    checkImageView.image = UIImage(systemName: "circle")
                }
            }
        }
    }
    
    // MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayout()
    }

    //
    // セルタップでセルを縮小（凹んだように見せる）
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        // セル選択モードの時は何もしない
        guard !isSelectMode else { return }
        // セルを凹ますアニメーション開始
        dentAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        dentAnimator?.startAnimation()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        dentReverseAnimation()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        dentReverseAnimation()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        dentReverseAnimation()
    }
    
    private func dentReverseAnimation() {
        if dentAnimator?.isRunning == .some(true) {
            // アニメーション中ならアニメーション終了後にセルサイズを元に戻すようにする
            dentAnimator?.addCompletion { _ in
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        } else {
            // 凹ますアニメーション完了後なら元にのサイズにするアニメーションを開始
            dentAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn) {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            dentAnimator?.startAnimation()
        }
    }
    
    // MARK: - intarnal
    
    /// 画像セルのセットアップ
    /// - Parameters:
    ///   - image: 画像
    ///   - price: 価格
    ///   - isSelectMode: セルの選択モードか否か
    public func setupCell(image: UIImage, price: Int, isSelectMode: Bool) {
        // 画像
        imageView.image = image
        // 価格
        priceLabel.text = " ¥\(price.withComma) "
        // 選択モード（チェックボックス表示）
        self.isSelectMode = isSelectMode
        checkImageView.isHidden = !isSelectMode
        // ボタンの活性・非活性（選択モードならボタンタップできる）
// TODO:        coverButton.isHidden = !isSelectMode
        // チェック状態
        isChecked = false
    }
}

// MARK: - private

private extension ImageItemCellView {
    
    func setupView() {
        // 画像
        addSubview(imageView)
        // 価格
        priceLabel.textColor = .white
        priceLabel.font = UIFont.priceFont
        priceLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(priceLabel)
        // チェックイメージ
        if #available(iOS 13.0, *) {
            checkImageView.image = UIImage(systemName: "circle")
            checkImageView.tintColor = R.color.label()
        } else {
            checkImageView.backgroundColor = .red
        }
        addSubview(checkImageView)
    }
    
    func setupLayout() {
        // 画像
        imageView.contentMode = .scaleAspectFit
        imageView.frame = bounds
        // 価格
        let maxSize = CGSize(width: .greatestFiniteMagnitude, height: Const.priceLabelHeight)
        let titleSize = priceLabel.sizeThatFits(maxSize)
        priceLabel.frame =  CGRect(x: 0,
                                   y: frame.height - Const.priceLabelHeight,
                                   width: titleSize.width,
                                   height: Const.priceLabelHeight)
        // チェックイメージ
        checkImageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
    }
}
