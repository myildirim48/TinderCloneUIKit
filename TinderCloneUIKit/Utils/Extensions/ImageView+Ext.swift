//
//  ImageView+Ext.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 16.05.2023.
//

import UIKit

extension UIImageView {
    func downloadImage(fromUrl url: String) {
        let placeHolderImage = UIImage(systemName: "person")
        
            Task {
                image = await ImageFetcher.shared.downloadImage(from: url) ?? placeHolderImage
            }
    }
}
