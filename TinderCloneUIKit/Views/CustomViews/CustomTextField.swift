//
//  CustomTextField.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 18.05.2023.
//

import UIKit

class CustomTextField: UITextField {
    let padding: CGFloat = 24
    init(placeholder: String, isSecureText:Bool? = false) {
        super.init(frame: .zero)

         borderStyle = .none
         textColor = .white
         backgroundColor = UIColor(white: 1, alpha: 0.2)
        keyboardAppearance = .dark
         layer.cornerRadius = 5
         attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        isSecureTextEntry = isSecureText!
         
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
