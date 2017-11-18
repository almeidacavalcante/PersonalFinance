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
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
        FIRDatabase.fetchCategoriesWithUID(uid: uid) { (categories) in
            completion(categories)
        }
    }
    
}
