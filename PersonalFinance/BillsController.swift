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
    
    var monthNumber : String?
    
    var monthLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    var m = [Int]()
    
    override func viewDidLoad() {
        self.fetchBills()
        
        
        setupLoadingBar()
        
        
        view.backgroundColor = UIColor.currentColorScheme[2]
        tableView.separatorColor = UIColor.clear
        tableView.register(BillTableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    

    
    let shapeLayer = CAShapeLayer()
    fileprivate func setupLoadingBar(){
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: 0, y: 2))
        aPath.addLine(to: CGPoint(x: view.frame.width, y: 2))
        
        aPath.close()
        shapeLayer.path = aPath.cgPath
        
        shapeLayer.strokeColor = UIColor.currentColorScheme[6].cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.strokeEnd = 0

        tableView.layer.addSublayer(shapeLayer)
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        
    }
    
    fileprivate func animateBar(fromValue: Float, toValue: Float, duration: Double, speed: Float) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.fromValue = fromValue
        basicAnimation.toValue = toValue
        basicAnimation.duration = duration
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.speed = speed
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    
    
    @objc private func handleTap(){
        print("TAP")
//        beginDownload()
//        animateBar(fromValue: 0, toValue: 1, duration: 1)
        
    }
    
    private func beginDownload() {
        print("Attempting to download file")
    }
    
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            guard let billId = self.bills[indexPath.item].id else {return}
            LibraryAPI.sharedInstance.removeBill(with: billId, completion: { 
                print("Bill removed with success: ", billId.description)
                self.bills.remove(at: indexPath.item)
                self.tableView.reloadData()
            })
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BillTableViewCell
        
        cell.backgroundColor = UIColor.currentColorScheme[2]
        if self.bills.count > 0 {
            cell.assetName = findAssetName(withId: (self.bills[indexPath.item].categoryId)!)
            cell.bill = self.bills[indexPath.item]
        }
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Just add this below line didSelectRowAt
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func findAssetName(withId: String) -> String{
        
        for category in (self.homeControllerRef?.categories)! {
            if category.id == withId{
                guard let assetName = category.asset?.assetName else {return ""}
                return assetName
            }
        }
        return ""
    }
    
    func fetchBills(){
        
        self.animateBar(fromValue: 0.0, toValue: 0.45, duration: 1, speed: 0.5)
        
        print("fetching bills after 4 seconds")
        guard let uid = self.uid else {return}
        
        
        LibraryAPI.sharedInstance.fetchBills(with: uid) { (bills) in
            self.bills = bills
            
            self.animateBar(fromValue: 0.45, toValue: 1, duration: 1, speed: 1)
            self.tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    

}
