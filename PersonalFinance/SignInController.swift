//
//  SignInController.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 23/10/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import UIKit

class SignInController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = UIColor.lightYellow
        
        let alert = UITextView()
        alert.text = "You're logged out!"
        
        view.addSubview(alert)
        alert.anchor(top: view.topAnchor, left: view.leftAnchor, botton: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
}
