//
//  CardViewModel.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 17.05.2023.
//

import UIKit

class CardViewModel {
    
    let user: User
    
    let userInfoText: NSAttributedString
    var imageIndex = 0
    
    var imageUrls: [String]
    var firstImageUrl: String
    
    init(user:User) {
        self.user = user
        
        
        let attributedText = NSMutableAttributedString(string: user.fullName, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        
        attributedText.append(NSAttributedString(string: "  \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white]))
        
        self.userInfoText = attributedText
        
        self.imageUrls = user.imageUrls
         self.firstImageUrl = imageUrls.first ?? ""
        
    }
    
    func showNextPhoto() {
//        guard imageIndex < user.images.count - 1 else { return }
//        imageIndex += 1
//        self.imageToShow = user.images[imageIndex]
    }
    func showPreviousPhoto() {
//        guard imageIndex > 0 else { return }
//        imageIndex += 1
//        self.imageToShow = user.images[imageIndex]
    }
}
