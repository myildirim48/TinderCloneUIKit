//
//  TopNavigationStackView.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 12.05.2023.
//

import UIKit

protocol HomeNavigationStackViewDelegate: AnyObject {
    func showSettings()
    func showMessages()
}

class TopNavigationStackView: UIStackView {
    
    weak var delegate: HomeNavigationStackViewDelegate?
    
    let settingsButton = UIButton(type: .system)
    let messagesButton = UIButton(type: .system)
    let fireImageViewButton = UIImageView(image: UIImage(named: "app_icon" ))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addActions()
    }
    func setupUI() {
        fireImageViewButton.contentMode = .scaleAspectFit
        settingsButton.setImage(UIImage(named: "top_left_profile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messagesButton.setImage(UIImage(named: "top_right_messages")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingsButton, UIView(), fireImageViewButton, UIView(),messagesButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
    }
    
    func addActions() {
        settingsButton.addTarget(self, action: #selector(handleShowSettingsView), for: .touchUpInside)
        messagesButton.addTarget(self, action: #selector(handleShowMessagesView), for: .touchUpInside)
    }
    
    @objc fileprivate func handleShowSettingsView(){
        delegate?.showSettings()
    }
    @objc fileprivate func handleShowMessagesView(){
        delegate?.showMessages()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
