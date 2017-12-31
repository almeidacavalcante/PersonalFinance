//
//  Asset.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 18/12/2017.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import Foundation

class Asset : NSObject {
    let id : String?
    let assetName: String?
    var used: Int
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.assetName = dictionary["assetName"] as? String ?? ""
        self.used = dictionary["used"] as? Int ?? 0
    }
}
