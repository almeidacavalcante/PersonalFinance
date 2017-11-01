//
//  CustomButton.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 23/10/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import Foundation
import UIKit

var imageCache = [String: UIImage?]()

class CustomButton: UIButton {
    
    var lastUploadedImageWithUrl : String?
    
    func loadImage(urlString: String){
        
        lastUploadedImageWithUrl = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.setImage(cachedImage, for: .normal)
            return
        }
        
        guard let imageUrl = lastUploadedImageWithUrl else { return }
        
        guard let url = URL(string: imageUrl) else { return }
        
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            
            if url.absoluteString != self.lastUploadedImageWithUrl {
                return
            }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.setImage(photoImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
            }.resume()
    }
}

