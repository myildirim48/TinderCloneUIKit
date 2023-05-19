//
//  AuthService.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 18.05.2023.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullName: String
    let profileImage: UIImage
}

struct AuthService {
    
    static func userLogin(withEmail email: String, password: String, completion:@escaping((AuthDataResult?, Error?) -> Void)){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredential credential: AuthCredentials, completion: @escaping (Error?)-> Void){
        Service.uploadImage(image: credential.profileImage) { imgUrl  in
            Auth.auth().createUser(withEmail: credential.email, password: credential.password) { result, error in
                if let error {
                    print("DEBUG: Error while creating user, \(error.localizedDescription)")
                    return
                }
                
                guard let userUid = result?.user.uid else { return }
                
                let data: [String: Any] = ["email": credential.email,
                            "fullName": credential.fullName,
                            "imageUrl": imgUrl,
                            "uid": userUid,
                            "age": 18 ]
                
                COLLECTION_USERS.document(userUid)
                    .setData(data, completion: completion)
            }
        }
    }
}
