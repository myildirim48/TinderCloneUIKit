//
//  HomeButtonControlsStackView.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 12.05.2023.
//

import UIKit

class HomeButtonControlsStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
       let subviews =  [UIImage(named: "refresh_circle"),
         UIImage(named: "dismiss_circle"),
         UIImage(named: "super_like_circle"),
         UIImage(named: "like_circle"),
         UIImage(named: "boost_circle")].map { img -> UIView in
            let button = UIButton(type: .system)
           button.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        

        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        subviews.forEach { view in
            addArrangedSubview(view)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
