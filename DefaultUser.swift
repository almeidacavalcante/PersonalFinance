//
//  DefaultUser.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 18/11/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import Foundation
import FirebaseAuth

final class DefaultUser {
    
    static let currentUser = DefaultUser()
    
    internal var uid : String?
    
    private init(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            print("Failed to fetch the logged user")
            return
        }
        
        self.uid = uid
    }
    
}
