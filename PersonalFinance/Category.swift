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
    var assetId : String?
    var asset : Asset?
    
    init(descriptionContent: String, asset: Asset) {
        self.id = ""
        self.descriptionContent = descriptionContent
        self.asset = asset
    }
    
    init(dictionary: [String: Any]) {
        self.id = ""
        self.descriptionContent = dictionary["description"] as? String ?? ""

    }
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.descriptionContent = dictionary["description"] as? String ?? ""
        self.assetId = dictionary["assetId"] as? String ?? ""
    }
    
    init(id: String, assetId: String, dictionary: [String: Any]) {
        self.id = id
        self.descriptionContent = dictionary["description"] as? String ?? ""
    }
    
    func setAsset(asset: Asset){
        self.asset = asset
    }
}
