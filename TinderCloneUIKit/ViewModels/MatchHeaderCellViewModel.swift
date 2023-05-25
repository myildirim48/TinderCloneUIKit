//
//  MatchHeaderCellViewModel.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 25.05.2023.
//

import Foundation
struct MatchHeaderCellViewModel {
    
    let nameText: String
    let profileImageUrl: String
    let uid: String
    
    init(match: Match) {
        nameText = match.name
        profileImageUrl = match.profileImageUrl
        uid = match.uid
    }
}
