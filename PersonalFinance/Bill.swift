//
//  Bill.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 05/11/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import Foundation

class Bill: NSObject {
    var id : String?
    var note : String?
    var value : Double = 0.0
    var category : Category?
    var categoryId : String?
    var date: Date
    
    init(id: String, note: String, value: Double, category: Category, date: Date) {
        self.id = id
        self.note = note
        self.value = value
        self.category = category
        self.date = date
    }
    
    init(id: String, dictionary: [String : Any]) {
        self.id = id
        self.note = dictionary["note"] as? String ?? ""
        self.value = dictionary["value"] as? Double ?? 0.0
        self.category = nil
        self.categoryId = dictionary["categoryId"] as? String ?? ""
        let date = dictionary["creationDate"] as! Double * 1000
        
        self.date = Date(milliseconds: Int(date))
    }
    
    init(dictionary: [String : Any]) {
        print("NO KEY! CHECK THIS OUT")
        self.id = ""
        self.note = dictionary["note"] as? String ?? ""
        self.value = dictionary["value"] as? Double ?? 0.0
        self.category = nil
        self.categoryId = dictionary["categoryId"] as? String ?? ""
        let date = dictionary["creationDate"] as! Double * 1000
        
        self.date = Date(milliseconds: Int(date))
    }
    
    
    
}
