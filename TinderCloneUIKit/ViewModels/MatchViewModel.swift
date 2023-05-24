//
//  MatchViewModel.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 24.05.2023.
//

import Foundation

struct MatchViewModel {
    private let currentUser: User
    let matchedUser: User
    
    let matchLabelText: String
    
    var currentUserImageUrl: String
    var matchedUserImageUrl: String
    
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        matchLabelText = "You and \(matchedUser.fullName) have liked each other!"

        currentUserImageUrl = currentUser.imageUrls.first ?? ""
        matchedUserImageUrl = matchedUser.imageUrls.first ?? ""
    }
}
