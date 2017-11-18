//
//  MonthReportCell.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 05/11/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import Foundation
import UIKit

class MonthReportCell: UICollectionViewCell {
    
    lazy var monthLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.currentColorScheme[8]
//        label.backgroundColor = .red
        return label
    }()
    
    lazy var valueLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.currentColorScheme[3]
//        label.backgroundColor = .yellow
        return label
    }()
    
    let arrow : UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "arrow3").template()
        view.tintColor = UIColor.currentColorScheme[3]
        return view
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(monthLabel)
        addSubview(valueLabel)
        addSubview(arrow)
        
        
        backgroundColor = UIColor.currentColorScheme[0]
        
        let height = frame.height - 16
        let width = (frame.width/1.7) - 32
        let valueLabelWidth = (frame.width/2.7) - 32
        
        monthLabel.anchor(top: topAnchor, left: leftAnchor, botton: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: width, height: height)
        valueLabel.anchor(top: topAnchor, left: nil, botton: nil, right: arrow.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: valueLabelWidth, height: height)
        
        arrow.anchor(top: topAnchor, left: nil, botton: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 15, height: 15)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
