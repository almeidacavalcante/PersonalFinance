//
//  Colors.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 21/10/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import UIKit

extension UIColor {

    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        
    }
    
    open class var dutchTeal : UIColor {
        get{
            return UIColor.rgb(red: 22, green: 147, blue: 165)
        }
    }
    
    open class var blackCian : UIColor {
        get{
            return UIColor.rgb(red: 42, green: 54, blue: 59)
        }
    }
    
    open class var lightGreen : UIColor {
        get{
            return UIColor.rgb(red: 191, green: 218, blue: 175)
        }
    }
    
    open class var musgoGreen : UIColor {
        get{
            return UIColor.rgb(red: 134, green: 172, blue: 151)
        }
    }
    
    
    open class var lightYellow : UIColor {
        get{
            return UIColor.rgb(red: 236, green: 193, blue: 84)
        }
    }
    
    open class var lightYellow2 : UIColor {
        get {
            //231,176,38
            return UIColor.rgb(red: 231, green: 176, blue: 38)
        }
    }
    
    open class var lightYellow3 : UIColor {
        get {
            //244,218,153
            return UIColor.rgb(red: 244, green: 218, blue: 153)
        }
    }
    
    open class var lightYellow4 : UIColor {
        get {
            return UIColor.rgb(red: 250, green: 240, blue: 214)
        }
    }
    
    
    open class var salmao : UIColor {
        get{
            return rgb(red: 231, green: 80, blue: 38)
        }
    }
    
}
