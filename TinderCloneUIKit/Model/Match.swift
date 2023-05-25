//
//  Match.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 25.05.2023.
//

import Firebase
import FirebaseFirestoreSwift

struct Match: Identifiable,Codable {
    @DocumentID var id: String?
    let name: String
    let profileImageUrl: String
    let uid: String

    
//    init(dictionary: [String:Any]) {
//        self.name = dictionary["name"] as? String ?? ""
//        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
//        self.uid = dictionary["uid"] as? String ?? ""
//    }
}
