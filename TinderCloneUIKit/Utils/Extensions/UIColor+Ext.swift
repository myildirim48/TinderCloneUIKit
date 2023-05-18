//
//  UIColor+Ext.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 17.05.2023.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    static let barDeselectedColor = UIColor(white: 0, alpha: 0.1)

}
