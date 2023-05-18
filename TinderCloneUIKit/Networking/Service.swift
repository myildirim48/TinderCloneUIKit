//
//  Service.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 18.05.2023.
//

import Firebase
import FirebaseStorage

struct Service {
    
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
