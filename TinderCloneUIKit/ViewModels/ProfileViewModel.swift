//
//  ProfileViewModel.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 23.05.2023.
//

import UIKit

struct ProfileViewModel {
    
    private let user: User
    
    let userDetailsAttributedString: NSAttributedString
    let profession: String
    let bio: String
    let imageUrls: [String]
    
    var itemCount: Int {
        return user.imageUrls.count
    }
    
    init(user: User) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.fullName,
                                                       attributes: [.font: UIFont.systemFont(ofSize: 24,weight: .semibold)])
        attributedText.append(NSAttributedString(string: "  \(user.age)",attributes: [.font: UIFont.systemFont(ofSize: 22)]))
        userDetailsAttributedString = attributedText
        
        profession = user.profession ?? ""
        bio = user.bio ?? ""
        imageUrls = user.imageUrls
    }
    
}
