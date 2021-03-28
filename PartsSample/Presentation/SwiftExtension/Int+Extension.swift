//
//  Int+Extension.swift
//  PartsSample
//

import Foundation

fileprivate let formatter: NumberFormatter = {
    let f = NumberFormatter()
    f.numberStyle = .decimal
    f.groupingSeparator = ","
    f.groupingSize = 3
    return f
}()

extension Int {
    var withComma: String {
        return formatter.string(from: NSNumber(integerLiteral: self)) ?? "\(self)"
    }
}
