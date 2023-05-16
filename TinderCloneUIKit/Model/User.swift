//
//  User.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 12.05.2023.
//

import UIKit

struct User: ProducesCardViewModel, Decodable {
    var name: String?
    var age: Int?
    let profession: String?
//    let imageNames: [String]
        let imageUrl1: String?
    var uid: String?

    init(dictionary: [String: Any]) {

        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.name = dictionary["fullName"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.imageUrl1  = dictionary["imgUrl"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let ageString = age != nil ? "\(age!)" : "N/A"
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: ageString, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n \(profession ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedText, textAlignment: .left)
    }
}
