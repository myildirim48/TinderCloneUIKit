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
        fetchSwipes { swipedUserIds in
            query.getDocuments { snapshot, error in
                if let error {
                    print("DEBUG: Error while fetching users, \(error.localizedDescription)")
                    return
                }
                
                snapshot?.documents.forEach({ document in
                    guard let user = try? document.data(as: User.self) else { return }
                    guard user.uid != Auth.auth().currentUser?.uid else { return }
                    guard swipedUserIds[user.uid] == nil else { return }
                    users.append(user)
                })
                completion(users)
            }
        }
    }
    static func saveUserData(user: User, completion: @escaping(Error?) -> Void ){        
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
    
    static func uploadMatch(currentUser: User, matchedUser: User) {
        guard let matchedProfileImageUrl = matchedUser.imageUrls.first else { return }
        guard let currentProfileImageUrl = currentUser.imageUrls.first else { return }
        
        let matchedUser = Match(name: matchedUser.fullName, profileImageUrl: matchedProfileImageUrl, uid: matchedUser.uid)
        guard let encodedMatchedUser = try? Firestore.Encoder().encode(matchedUser) else { return }

        COLLECTION_MATCHES_MESSAGES.document(currentUser.uid).collection("matches")
            .document(matchedUser.uid).setData(encodedMatchedUser)
        
        let currentUser = Match(name: currentUser.fullName, profileImageUrl: currentProfileImageUrl, uid: currentUser.uid)
        guard let encodedCurrentUser = try? Firestore.Encoder().encode(currentUser) else { return }

        COLLECTION_MATCHES_MESSAGES.document(matchedUser.uid).collection("matches")
            .document(currentUser.uid).setData(encodedCurrentUser)
    }
    
    static func fetchMatches(completion: @escaping([Match]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        COLLECTION_MATCHES_MESSAGES.document(uid).collection("matches")
            .getDocuments { snapshot, error in
                if let error {
                    print("DEBUG: Error while fetching matches, \(error.localizedDescription)")
                    return
                }
                guard let snapshot else { return }
                let matches = snapshot.documents.compactMap { try? $0.data(as: Match.self) }
                completion(matches)
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
    
    private static func fetchSwipes(completion: @escaping([String: Bool]) -> Void){
        guard let CurrentUserUid = Auth.auth().currentUser?.uid else { return }
         
        COLLECTION_SWIPES.document(CurrentUserUid).getDocument { snapshot, error in
            if let error {
                print("DEBUG: Error wihle fetching swipes.", error.localizedDescription)
            }
            guard let data = snapshot?.data() as? [String: Bool] else {
                completion([String: Bool]())
                return
                
            }
            completion(data)
        }
        
        
    }
}
