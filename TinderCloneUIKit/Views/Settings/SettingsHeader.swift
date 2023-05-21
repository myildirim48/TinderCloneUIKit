//
//  SettingsHeader.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 19.05.2023.
//

import UIKit

protocol SettingsHeaderDelegate: AnyObject {
    func settingsHeader(_ header: SettingsHeader, didselect index: Int)
}

class SettingsHeader: UIView {
    
    //MARK: - Properties
    weak var delegate: SettingsHeaderDelegate?
    private let user: User
    var buttons = [UIButton]()

    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)

        
        let button1 = createButton(0)
        let button2 = createButton(1)
        let button3 = createButton(2)
        
        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        
        addSubview(button1)
        button1.anchor(top: topAnchor,leading: leadingAnchor, bottom: bottomAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 0))
        button1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [button2,button3])
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: button1.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        loadUserPhotos()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func loadUserPhotos() {
        let imageUrls = user.imageUrls
        
        for (index, url) in imageUrls.enumerated() {
            Task {
               let image = await ImageFetcher.shared.downloadImage(from: url)
                self.buttons[index].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            print(url)
            
        }
    }
    
    func createButton(_ index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        button.tag = index
        return button
    }
    
    //MARK: - Actions
    @objc fileprivate func handleSelectPhoto(sender: UIButton){
        delegate?.settingsHeader(self, didselect: sender.tag)
    }
}
