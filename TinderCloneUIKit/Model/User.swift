//
//  User.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 17.05.2023.
//

import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var fullName: String
    var age: Int
    var email: String
    let uid: String
    var imageUrls: [String]
    
    var profession: String?
    var bio: String?
    
    var minSeekingAge: Int? = 18
    var maxSeekingAge: Int? = 60
    
//    var images: [UIImage]
    
//    init(dictionary: [String:Any]) {
//        self.fullName = dictionary["fullName"] as? String ?? ""
//        self.age = dictionary["age"] as? Int ?? 0
//        self.email = dictionary["email"] as? String ?? ""
//        self.profileImageUrl = dictionary["imageUrl"] as? String ?? ""
//        self.uid = dictionary["uid"] as? String ?? ""
//    }
    
}

//struct User: Identifiable,Decodable {
//    @DocumentID var id: String?
//    var name: String
//    var age: Int
//    var email: String
//    let uid: String
//    let profileImageUrl: String
//}
