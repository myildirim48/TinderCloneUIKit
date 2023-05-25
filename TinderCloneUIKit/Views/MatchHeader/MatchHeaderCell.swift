//
//  MatchHeaderCell.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 25.05.2023.
//

import UIKit

class MatchHeaderCell: UICollectionViewCell {
    
    //MARK: -  Properties
    
    var viewModel: MatchHeaderCellViewModel! {
        didSet {
            userNameLabel.text = viewModel.nameText
            profileImageView.downloadImage(fromUrl: viewModel.profileImageUrl)
        }
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.setDimensions(height: 80, width: 80)
        imageView.layer.cornerRadius = 80 / 2
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14,weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView,userNameLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 6
        
        addSubview(stack)
        stack.fillSuperview()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
