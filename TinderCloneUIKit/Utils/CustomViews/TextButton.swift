//
//  TextButton.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 18.05.2023.
//

import UIKit
class TextButton: UIButton {
    init(title: String, boldTitle: String, type: ButtonType = .system) {
        super.init(frame: .zero)
        
        let attributedTitle = NSMutableAttributedString(string: title,
                                                        attributes: [.foregroundColor: UIColor.white,.font: UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSAttributedString(string: " \(boldTitle)",
                                                  attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]))
        setAttributedTitle(attributedTitle, for: .normal)
      
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
