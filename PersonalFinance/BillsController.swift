//
//  BillsController.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 18/11/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import Foundation
import UIKit

class BillsController: UITableViewController {
    
    let cellId = "cellId"
    
    var bills = [Bill]()
    
    let uid = DefaultUser.currentUser.uid
    
    var homeControllerRef : HomeController?
    
    override func viewDidLoad() {
        self.fetchBills()
        view.backgroundColor = UIColor.currentColorScheme[2]
        tableView.separatorColor = UIColor.clear
        tableView.register(BillTableViewCell.self, forCellReuseIdentifier: cellId)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BillTableViewCell
        
        cell.backgroundColor = UIColor.currentColorScheme[1]
        if self.bills.count > 0 {
            cell.assetName = findAssetName(withId: (self.bills[indexPath.item].categoryId)!)
            cell.bill = self.bills[indexPath.item]
        }
        
        return cell
    }
    
    func findAssetName(withId: String) -> String{
        
        for category in (self.homeControllerRef?.categories)! {
            if category.id == withId{
                return category.assetName!
            }
        }
        return ""
    }
    
    func fetchBills(){
        
        guard let uid = self.uid else {return}
        
        LibraryAPI.sharedInstance.fetchBills(with: uid) { (bills) in
            self.bills = bills
            self.tableView.reloadData()
        }
    }
    
    
}
