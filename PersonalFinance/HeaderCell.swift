//
//  HeaderCell.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 20/10/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//



import UIKit

protocol HeaderCellDelegate {
    func didFinishEditing()
}


class HeaderCell: UICollectionViewCell {
    
    var delegate : HeaderCellDelegate?
    
    let currencyField : UITextField = {
        let tv = UITextField()
        tv.font = UIFont(name: "Arial", size: 48)
        tv.keyboardType = UIKeyboardType.numberPad
        tv.textAlignment = .center
        tv.backgroundColor = UIColor.lightYellow
        tv.textColor = UIColor.salmao
        tv.text = "$0.00"
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(currencyField)
        currencyField.anchor(top: topAnchor, left: leftAnchor, botton: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        currencyField.addTarget(self, action: #selector(handleCurrencyValueChange), for: .editingChanged)
        
    }
    
    func handleCurrencyValueChange(){
        
        print("CURRENCY: ----------> ", currencyField.text)
        print("AMOUNT: ----------> ", currencyField.text?.currencyInputFormatting())
        if let amountString = currencyField.text?.currencyInputFormatting() {
            currencyField.text = amountString
        }
    }
    
    func didFinishEditing(){
        currencyField.endEditing(true)
        delegate?.didFinishEditing()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

