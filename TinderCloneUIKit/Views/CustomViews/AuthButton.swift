//
//  AuthButton.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 18.05.2023.
//

import UIKit
class AuthButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        layer.cornerRadius = 5
        isEnabled = false
        setTitleColor(.white, for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
