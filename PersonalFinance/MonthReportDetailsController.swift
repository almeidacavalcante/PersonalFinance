//
//  MonthReportDetailsController.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 05/11/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class MonthReportDetailsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var monthLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    var monthNumber : String?
    
    var homeControllerRef : HomeController?
    var bills : [Bill]?
    
    override func viewDidLoad() {
        
        collectionView?.alwaysBounceVertical = true

        self.setupRefreshControl()
        
        guard let month = self.monthNumber else {return}
        self.fetchBillsPerMonth(monthString: month)
        
        collectionView?.backgroundColor = UIColor.currentColorScheme[2]
        collectionView?.register(BillCell.self, forCellWithReuseIdentifier: cellId)
        
        navigationItem.title = monthLabel.text
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.bills?.count else {return 0}
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BillCell
        cell.backgroundColor = UIColor.currentColorScheme[1]
        if (self.bills?.count)! > 0 {
            cell.assetName = findAssetName(withId: (self.bills?[indexPath.item].categoryId)!)
            cell.bill = self.bills?[indexPath.item]
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 45)
    }
    
    
    func fetchBillsForMonth(){
        fetchLimitedBills()
    }
    
    let arrowView : UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "arrow6").template())
        view.tintColor = UIColor.currentColorScheme[3]
        return view
    }()
    
    fileprivate func setupRefreshControl(){
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = UIColor.currentColorScheme[3]
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.addSubview(arrowView)
        arrowView.anchor(top: nil, left: nil, botton: refreshControl.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 20, height: 20)
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        self.collectionView?.refreshControl = refreshControl
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .curveLinear, .repeat], animations: {
            refreshControl.backgroundColor = UIColor.currentColorScheme[8]
            refreshControl.backgroundColor = UIColor.currentColorScheme[1]
        }) { (true) in
            print("REFRESH CONTROL ANIMATION!")
        }
        let constraint = NSLayoutConstraint(item: refreshControl, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 200)
        view.addConstraint(constraint)
    }
    
    func handleRefresh(sender:AnyObject){
        
        self.bills?.removeAll()
        self.readyToReload = true
        self.fetchBillsPerMonth(monthString: self.monthNumber!)
    }
    
    let numberOfBillsPerPage: UInt = 10
    
    func fetchLimitedBills(){
        
        self.bills = [Bill]()
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
        let ref = FIRDatabase.database().reference().child("bills").child(uid)
        
        let query = ref.queryOrdered(byChild: "creationDate")
        
        query.queryLimited(toLast: self.numberOfBillsPerPage).observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("SNAPSHOT: ", snapshot)
            
            self.collectionView?.refreshControl?.endRefreshing()
            
            guard let billsDictionary = snapshot.value as? [String: Any] else {return}
            
            billsDictionary.forEach({ (key,value) in
                guard let dictionary = value as? [String: Any] else {return}
                
                let bill = Bill(id: key, dictionary: dictionary)
                
                self.bills?.append(bill)

                self.bills?.sort(by: { (p1, p2) -> Bool in
                    return p1.date.compare(p2.date as Date) == .orderedDescending
                })

                self.tryToReloadData()
            })
            
        })
    }
    
    
    func fetchBillsPerMonth(monthString: String){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        var monthString = monthString
        
        if monthString.characters.count == 1 {
            let newString = "0".appending(monthString)
            monthString = newString
            print("MONTH STRING", monthString)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: -10800)
        formatter.calendar = NSCalendar.current
        let startingDate = formatter.date(from: "2017/\(monthString)/01 00:00")?.startOfMonth()
        let endingDate = startingDate?.endOfMonth()
        
        
        
        FIRDatabase.fetchBills(with: uid, from: startingDate!, to: endingDate!) { (bills) in
            self.collectionView?.refreshControl?.endRefreshing()
            self.bills = bills
            self.tryToReloadData()
        }
        
    }
    
    var readyToReload = true
    
    func tryToReloadData(){
        if readyToReload {
            self.collectionView?.reloadData()
        }
    }
}
