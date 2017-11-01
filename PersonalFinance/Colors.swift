//
//  Colors.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 21/10/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import UIKit

extension UIColor {
    

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    
    open class var standardColorScheme : [UIColor] {
        get{
            var scheme = [UIColor]()
            scheme.append(UIColor(rgb: 0x01899B)) // [0]
            scheme.append(UIColor(rgb: 0x028090)) // [1]
            scheme.append(UIColor(rgb: 0x017382)) // [2]
            scheme.append(UIColor(rgb: 0xF0F3BD)) // [3] Pale Spring Bud
            scheme.append(UIColor(rgb: 0x0197A8)) // [4] Blue Munsell
            scheme.append(UIColor(rgb: 0x00A896)) // [5] Persian Green
            scheme.append(UIColor(rgb: 0x02C39A)) // [6] Caribbean Grenn
            scheme.append(UIColor(rgb: 0x02CE91)) // [7] Caribbean Grenn Lighter
            scheme.append(UIColor(rgb: 0x034059)) // [8] Midnight Green
            scheme.append(UIColor(white: 0, alpha: 0.3)) // [9] Placeholder Color
            scheme.append(UIColor(rgb: 0xEAF260)) // [10] Icterine
            scheme.append(UIColor(rgb: 0x2CCD98)) // [11] Mountain Meadow (greenish)
            scheme.append(UIColor(rgb: 0x026976)) // [12] Skobeloff (dark blue)
            scheme.append(UIColor.rgb(red: 250, green: 240, blue: 214))
            scheme.append(UIColor.rgb(red: 231, green: 80, blue: 38))
            return scheme
        }
    }
    
    open class var newColorScheme : [UIColor] {
        get{
            var scheme = [UIColor]()
            scheme.append(.rgb(red: 169, green: 69, blue: 56))
            scheme.append(.rgb(red: 193, green: 48, blue: 71))
            scheme.append(.rgb(red: 55, green: 36, blue: 96))
            scheme.append(.rgb(red: 29, green: 69, blue: 96))
            scheme.append(.rgb(red: 5, green: 77, blue: 67))
            return scheme
        }
    }
    
    open class var currentColorScheme : [UIColor] {
        get {
            return standardColorScheme
        }
    }
    
    

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
