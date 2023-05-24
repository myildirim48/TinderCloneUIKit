//
//  Service.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 18.05.2023.
//

import Firebase
import FirebaseStorage

struct Service {
    
    static func fetchUsers(forCurrentuser user: User, completion: @escaping([User])-> Void) {
        var users = [User]()
        
        guard let minAge = user.minSeekingAge else { return }
        guard let maxAge = user.maxSeekingAge else { return }
      
        
        let query = COLLECTION_USERS
            .whereField("age", isGreaterThanOrEqualTo: minAge)
            .whereField("age", isLessThanOrEqualTo: maxAge)
        
        query.getDocuments { snapshot, error in
            if let error {
                print("DEBUG: Error while fetching users, \(error.localizedDescription)")
                return
            }
            
            snapshot?.documents.forEach({ document in
                guard let user = try? document.data(as: User.self) else { return }
                guard user.uid != Auth.auth().currentUser?.uid else { return }
                users.append(user)
            })
            completion(users)

        }

    }
    static func saveUserData(user: User, completion: @escaping(Error?) -> Void ){
//        let userData = User(fullName: credential.fullName, age: 18, email: credential.email, uid: userUid, imageUrls: [imgUrl])
        
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        COLLECTION_USERS.document(user.uid).setData(encodedUser,completion: completion)

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
    //MARK: -  Image
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
    //MARK: - Match
    
    static func checkIfUserMatchExist(forUser user: User, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(user.uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() else { return }
            guard let didMatch = data[currentUid] as? Bool else { return }
            completion(didMatch)
        }
    }
    
    //MARK: - Swipe
    
    static func saveSwipe(forUser user: User, isLike: Bool, completion: ((Error?) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(uid).getDocument { snaphsot, error in
            if let error {
                print("DEBUG: Error wihle fetching swipes.", error.localizedDescription)
            }
            
            let data = [user.uid: isLike]
            
            if snaphsot?.exists == true {
                COLLECTION_SWIPES.document(uid).updateData(data)
            }else {
                COLLECTION_SWIPES.document(uid).setData(data, completion: completion)
            }
        }
    }
}
