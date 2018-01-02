//
//  BillTableViewCell.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 18/11/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//



import Foundation
import UIKit

class BillTableViewCell: UITableViewCell {
    
    let valueLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.currentColorScheme[3]
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.currentColorScheme[15]
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.text = "2 days ago"
        return label
    }()
    
    let categoryImageView : UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor.currentColorScheme[8]
        return iv
    }()
    
    let noteLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.currentColorScheme[8]
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var assetName : String?
    let cellId = "cellId"
    
    var bill : Bill? {
        didSet{
            self.setupBill()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        self.addSubview(categoryImageView)

        self.categoryImageView.anchor(top: topAnchor, left: leftAnchor, botton: nil, right: nil, paddingTop: 12.5, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectionStyle = .none
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 1, 0))
        contentView.backgroundColor = UIColor.currentColorScheme[17]

    }
    
    func setupBill(){
        valueLabel.text = "$" + (bill?.value.description)!
        noteLabel.text = bill?.note
        let date : NSDate = bill?.date as! NSDate
        
        dateLabel.text = date.timeAgoDisplay()
        
        self.addSubview(dateLabel)
        self.addSubview(valueLabel)
        self.addSubview(noteLabel)
        
        self.dateLabel.anchor(top: noteLabel.bottomAnchor, left: noteLabel.leftAnchor, botton: nil, right: nil, paddingTop: -7, paddingLeft:0, paddingBottom: 0, paddingRight: 0, width: 200, height: 15)
        valueLabel.anchor(top: topAnchor, left: nil, botton: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 100, height: 37)
        noteLabel.anchor(top: topAnchor, left: categoryImageView.rightAnchor, botton: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 100, height: 37)
        
        categoryImageView.image = UIImage(named: assetName!)?.template()
        layoutIfNeeded()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
