//
//  ProfileCell.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 21.05.2023.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    //MARK: -  Properties
    let imageView = UIImageView()
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    //MARK: -  Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "jane2")
        
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
