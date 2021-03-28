//
//  UIFont+Extension.swift
//  PartsSample
//

import UIKit

extension UIFont {
    static var titleFont: UIFont {
        let size: CGFloat = 14
        return UIFont(name: "HiraKakuProN-W6", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static var priceFont: UIFont {
        let size: CGFloat = 12
        return UIFont(name: "HiraKakuProN-W3", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static var linkFont: UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
    
    static var pageSwitcherFont: UIFont {
        let size: CGFloat = 12
        return UIFont(name: "HiraKakuProN-W3", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
