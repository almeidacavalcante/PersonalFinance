//
//  Persistency.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 17/11/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase


final class PersistencyManager {
    
    static let sharedInstance = PersistencyManager()
    
    func fetchCategories(completion: @escaping ([Category]) -> ()){
        guard let uid = DefaultUser.currentUser.uid else {return}
        
        FIRDatabase.fetchCategoriesWithUID(uid: uid) { (categories) in
            completion(categories)
        }
    }
    
    func fetchBills(startingDate: Date, endingDate: Date, completion: @escaping ([Bill]) -> ()){
        guard let uid = DefaultUser.currentUser.uid else {return}
        
        FIRDatabase.fetchBills(with: uid, from: startingDate, to: endingDate) { (bills) in
            completion(bills)
        }
    }
    
    func fetchBills(with uid: String, completion: @escaping ([Bill]) -> ()){
        FIRDatabase.fetchBillsWithUID(uid: uid) { (bills) in
            completion(bills)
        }
    }
}

