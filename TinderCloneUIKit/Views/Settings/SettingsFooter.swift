//
//  SettingsFooter.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 21.05.2023.
//

import UIKit

protocol SettingsFooterDelegate: AnyObject {
    func handleLogout()
}

class SettingsFooter: UIView {
    //MARK: - Properties
    
    weak var deleagate: SettingsFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let spacer = UIView()
        spacer.backgroundColor = .systemGroupedBackground
        
        addSubview(spacer)
        spacer.setDimensions(height: 32, width: frame.width)
        
        addSubview(logoutButton)
        logoutButton.anchor(top: spacer.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 50))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc fileprivate func handleLogout(){
        deleagate?.handleLogout()
    }
}
