//
//  AuthButton.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 18.05.2023.
//

import UIKit
class AuthButton: UIButton {
    init(title: String, type: ButtonType = .system) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        titleLabel?.font = UIFont.systemFont(ofSize: 16,weight: .heavy)
        layer.cornerRadius = 5
        isEnabled = false
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
