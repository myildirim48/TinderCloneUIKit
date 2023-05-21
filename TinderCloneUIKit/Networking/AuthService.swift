//
//  AuthService.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 18.05.2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

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

                let userData = User(fullName: credential.fullName, age: 18, email: credential.email, uid: userUid, imageUrls: [imgUrl])
                
                guard let encodedUser = try? Firestore.Encoder().encode(userData) else { return }
                COLLECTION_USERS.document(userUid).setData(encodedUser)

            }
        }
    }
}
