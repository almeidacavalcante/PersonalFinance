//
//  CategoryCell.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 20/10/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate {
    func didSelectCategory(cell: CategoryCell)
} 

class CategoryCell: UICollectionViewCell {
    
    var delegate: CategoryCellDelegate?
    var indexPath: IndexPath?
    
    lazy var button : CustomButton = {
        let button = CustomButton(type: .system)
        button.tintColor = UIColor.currentColorScheme[12]
        button.isUserInteractionEnabled = false
        return button
    }()
    
    var category: Category?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(button)
        button.anchor(top: topAnchor, left: leftAnchor, botton: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectCategory))
        button.addGestureRecognizer(gestureRecognizer)
        
        self.resetColor()
        
    }
    
    func resetColor(){
        self.backgroundColor = UIColor.currentColorScheme[4]
    }
    
    func didSelectCategory(){
        delegate?.didSelectCategory(cell: self)

    }
    
    override func prepareForReuse() {
        self.category = nil
        self.resetColor()
        self.button.tintColor = UIColor.currentColorScheme[12]
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
