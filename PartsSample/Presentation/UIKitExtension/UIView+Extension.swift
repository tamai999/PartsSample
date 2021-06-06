//
//  UIView+Extension.swift
//  PartsSample
//

import UIKit

extension UIView {
    enum tagConst: Int {
        case customPickerView = 10000
    }
    
    class var className: String {
        return "\(self)"
    }
}
