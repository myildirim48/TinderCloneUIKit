//
//  RegistrationViewModel.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 14.05.2023.
//

import UIKit
import Firebase
import FirebaseStorage
class RegistrationViewModel {
    
    var bindableIsFormValid = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsRegistering = Bindable<Bool>()
    
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity()} }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        
        bindableIsFormValid.value = isFormValid
    }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email else { return }
        guard let password else { return }
        
        bindableIsRegistering.value = true
        
        
        Auth.auth().createUser(withEmail: email , password: password) { result, error in
            if let error {
                completion(error)
                return
            }
            
            self.saveImageToFirebase(completion: completion)
        }
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()){
        
        let fileName = UUID().uuidString
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        ref.putData(imageData) { _, err in
            if let err {
                completion(err)
                return
            }
            
            ref.downloadURL { url, error in
                if let error {
                    completion(error)
                    return
                }
                self.bindableIsRegistering.value = false
                
                guard let imgUrl = url?.absoluteString else { return }
                self.saveInfoToFirestore(imageUrl:imgUrl, completion: completion)
                completion(nil)
            }
        }
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let docData = ["fullName": fullName ?? "", "uid": uid, "imgrUrl": imageUrl] as [String : Any]
        
        Firestore.firestore().collection("users").document(uid)
            .setData(docData) { err in
                if let err {
                    completion(err)
                    return
                }
                completion(nil)
            }
    }
}
