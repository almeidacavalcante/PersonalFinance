//
//  CategoryHeaderCell.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 28/10/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import Foundation
import UIKit


class CategoryHeaderCell: UICollectionViewCell {
   
    let categoryNameTextField : TextField = {
        let tf = TextField()
        tf.backgroundColor = UIColor.currentColorScheme[3]
        tf.borderStyle = .roundedRect
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        tf.placeholder = "Type the Category Name"
        tf.textAlignment = .left
        tf.contentVerticalAlignment = .center
        tf.textAlignment = .center
        tf.textColor = UIColor.currentColorScheme[9]
        
        return tf
    }()
    
    let categoryNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.currentColorScheme[8]
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(categoryNameTextField)
        self.addSubview(categoryNameLabel)
        
        categoryNameLabel.anchor(top: self.topAnchor, left: self.leftAnchor, botton: nil, right: self.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        categoryNameTextField.anchor(top: categoryNameLabel.bottomAnchor, left: self.leftAnchor, botton: nil, right: self.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
        
        self.resetColor()
    }
    
    func resetColor(){
        self.backgroundColor = UIColor.currentColorScheme[4]
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

