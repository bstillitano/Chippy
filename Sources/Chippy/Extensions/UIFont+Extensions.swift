//
//  UIFont+Extensions.swift
//
//
//  Created by Brandon on 29/1/2022.
//

import UIKit

extension UIFont {
    var scaledFont: UIFont {
        return UIFontMetrics.default.scaledFont(for: self)
    }
}
