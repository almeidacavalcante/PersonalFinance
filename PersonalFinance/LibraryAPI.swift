//
//  LibraryAPI.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 17/11/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import Foundation

final class LibraryAPI {
    
    static let sharedInstance = LibraryAPI()
    
    let persistencyInstance = PersistencyManager.sharedInstance
    
    func fetchCategories(completion: @escaping ([Category]) -> ()){
        let c = PersistencyManager()
        if CFEqual(c as CFTypeRef!, persistencyInstance as CFTypeRef!) {
            print("THEY ARE EQUAL")
        }
        self.persistencyInstance.fetchCategories { (categories) in
            completion(categories)
        }
    }
    
}

