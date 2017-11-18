//
//  MonthReportController.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 05/11/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MonthReportController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var homeControllerRef : HomeController?
    
    var monthReportDetailsController : MonthReportDetailsController?
    var months : [String] = []
        
    override func viewDidLoad() {

        fetchMonths()

        
        navigationController?.navigationBar.topItem?.title = ""
        
        collectionView?.register(MonthReportCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.currentColorScheme[2]
    }
    
    func currentTime(date: Date) -> Int {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        return month
    }
    
    var m = [Int]()
    
    func addMonth(month: Int){
        if !m.contains(month){
            m.append(month)
        }
    }

    func fetchMonths(){
        guard let uid = DefaultUser.currentUser.uid else {return}
        
        LibraryAPI.sharedInstance.fetchBills(with: uid) { (returnedBills) in
            returnedBills.forEach({ (bill) in
                self.addMonth(month: self.currentTime(date: bill.date))
            })
            self.doTranslateMonths()
            self.collectionView?.reloadData()
        }
    }

    
    func doTranslateMonths(){
        self.m.forEach { (element) in
            months.append(translateNumberToMonthName(number: element))
        }
    }
    
    func translateNumberToMonthName(number: Int) -> String{
        let months = [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
            ]
        return months[number-1]
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as!MonthReportCell

        cell.monthLabel.text = months[indexPath.item]
        
        return cell
    }
    
    
    //MARK: It`s creating a new instance every time it loads!
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)

            let layout = UICollectionViewFlowLayout()
            self.monthReportDetailsController = MonthReportDetailsController(collectionViewLayout: layout)
            self.monthReportDetailsController?.homeControllerRef = self.homeControllerRef
            self.monthReportDetailsController?.monthNumber = String(m[indexPath.item])
            self.monthReportDetailsController?.monthLabel.text = months[indexPath.item]
            navigationController?.pushViewController(self.monthReportDetailsController!, animated: true)

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 45)
    }
}
