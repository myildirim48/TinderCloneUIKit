//
//  HomeButtonControlsStackView.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 12.05.2023.
//

import UIKit

protocol HomeButtonControlsDelegate: AnyObject {
    func handleLike()
    func handleDislike()
    func handleRefresh()
}

class HomeButtonControlsStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        return button
    }
    //MARK: - Properties
    
    weak var delegate: HomeButtonControlsDelegate?
    
    let refreshButton = createButton(image: #imageLiteral(resourceName: "refresh_circle"))
    let disLikeButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle"))
    let superLikeButton = createButton(image: #imageLiteral(resourceName: "super_like_circle"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "like_circle"))
    let boostButton = createButton(image: #imageLiteral(resourceName: "boost_circle"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        disLikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
        [refreshButton,disLikeButton,superLikeButton,likeButton,boostButton].forEach { button in
            self.addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Actions
    
    @objc fileprivate func handleRefresh(){
        delegate?.handleRefresh()
    }
    @objc fileprivate func handleLike(){
        delegate?.handleLike()
    }
    
    @objc fileprivate func handleDislike(){
        delegate?.handleDislike()
    }
}
