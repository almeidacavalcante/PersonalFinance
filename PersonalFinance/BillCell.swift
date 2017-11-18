//
//  BillCell.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 05/11/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import Foundation
import UIKit

class BillCell: UICollectionViewCell {
    
    let valueLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.currentColorScheme[3]
        label.font = UIFont.boldSystemFont(ofSize: 15)
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
    
    var bill : Bill? {
        didSet{
            self.setupBill()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(categoryImageView)
        categoryImageView.anchor(top: topAnchor, left: leftAnchor, botton: nil, right: nil, paddingTop: 12.5, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
 
    }
    
    func setupBill(){
        valueLabel.text = "$" + (bill?.value.description)!
        noteLabel.text = bill?.note
        
        self.addSubview(valueLabel)
        self.addSubview(noteLabel)
        
        valueLabel.anchor(top: topAnchor, left: nil, botton: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 100, height: 37)
        noteLabel.anchor(top: topAnchor, left: categoryImageView.rightAnchor, botton: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 100, height: 37)
        
        categoryImageView.image = UIImage(named: assetName!)?.template()
        layoutIfNeeded()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
