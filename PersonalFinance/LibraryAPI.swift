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
        persistencyInstance.fetchCategories { (categories) in
            completion(categories)
        }
    }
    
    func fetchBills(startingDate: Date, endingDate: Date, completion: @escaping ([Bill]) -> ()){
        persistencyInstance.fetchBills(startingDate: startingDate, endingDate: endingDate) { (bills) in
            completion(bills)
        }
    }
    
    func fetchBills(with uid: String, completion: @escaping ([Bill]) -> ()){
        persistencyInstance.fetchBills(with: uid) { (bills) in
            completion(bills)
        }
    }
    
    func removeBill(with id: String, completion: @escaping ()->()){
        persistencyInstance.removeBill(with: id) {
            completion()
        }
    }

}

