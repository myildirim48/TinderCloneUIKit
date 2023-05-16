//
//  ImageFetcher.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 16.05.2023.
//

import UIKit

class ImageFetcher {
    static let shared = ImageFetcher()
    let imgCache = NSCache<NSString,UIImage>()

    //DownloadImage
    func downloadImage(from urlString:String) async -> UIImage? {
        
        //Checks cache if the image is already downloaded its return the image
        let cacheKey = NSString(string: urlString)
        if let image = imgCache.object(forKey: cacheKey){ return image }
        
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            self.imgCache.setObject(image, forKey: cacheKey) //Addes image to cache
            return image
        }catch {
            return nil
        }
    }
}
