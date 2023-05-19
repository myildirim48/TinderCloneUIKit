//
//  Service.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 18.05.2023.
//

import Firebase
import FirebaseStorage

struct Service {
    
    static func fetchUsers(completion: @escaping([User])-> Void) {
        var users = [User]()
         
        COLLECTION_USERS.getDocuments { snapshot, error in
            if let error {
                print("DEBUG: Error while fetching users, \(error.localizedDescription)")
                return
            }
            
            snapshot?.documents.forEach({ document in
                guard let user = try? document.data(as: User.self) else { return }
                users.append(user)
                
//                if users.count == snapshot?.documents.count {
//                }
            })
            completion(users)

        }

    }
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void){
        COLLECTION_USERS
            .document(uid).getDocument { snapshot, error in
                if let error {
                    print("DEBUG: Error fetchuser, \(error.localizedDescription)")
                }
                guard let snapshot else { return }
                guard let user = try? snapshot.data(as: User.self) else { return }
                
                completion(user)
            }
    }
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let fileName = UUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(fileName)")
        
        reference.putData(imageData) { storage, error in
            if let error {
                print("DEBUG: Error while uploading images, \(error.localizedDescription)")
                return
            }
            
            reference.downloadURL { url, _ in
                guard let imgUrl = url?.absoluteString else { return }
                completion(imgUrl)
            }
        }
    }
}
