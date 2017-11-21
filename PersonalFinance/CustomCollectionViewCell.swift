//
//  CustomCollectionViewCell.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 18/11/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import Foundation
import UIKit

class CustomCollectionViewCell : UICollectionViewCell {
    
    var swipeView: UIView = {
        let view = UIView()
        return view
    }()
    
    var customTextLbl: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var customContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    var contentViewLeftConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint()
        return constraint
    }()
    
    var contentViewRightConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint()
        return constraint
    }()
    
    var startPoint = CGPoint()
    var startingRightLayoutConstraintConstant = CGFloat()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
