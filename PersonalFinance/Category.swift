//
//  Category.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 23/10/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import Foundation

class Category: NSObject {
    let id: String?
    let descriptionContent : String?
    let assetName : String?
    
    
    init(descriptionContent: String, assetName: String) {
        self.id = ""
        self.descriptionContent = descriptionContent
        self.assetName = assetName
    }
    
    init(dictionary: [String: Any]) {
        self.id = ""
        self.descriptionContent = dictionary["description"] as? String ?? ""
        self.assetName = dictionary["assetName"] as? String ?? ""
    }
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.descriptionContent = dictionary["description"] as? String ?? ""
        self.assetName = dictionary["assetName"] as? String ?? ""
    }
}
