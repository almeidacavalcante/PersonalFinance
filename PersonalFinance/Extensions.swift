//
//  Extensions.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 19/10/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

//
//  Extensions.swift
//  RetroInstagram
//
//  Created by José de Almeida Cavalcante Neto on 02/05/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}


extension UIView {
    
    func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
    }
    
    func mask(withPath path: UIBezierPath, inverse: Bool = false) {
        let path = path
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, botton: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let botton = botton {
            self.bottomAnchor.constraint(equalTo: botton, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
}

extension UINavigationController {
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        
        if let rootViewController = self.viewControllers.first {
            return rootViewController.preferredStatusBarStyle
        }
        return super.preferredStatusBarStyle
        
    }
}

extension UICollectionViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UICollectionViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension NSDate {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(NSDate().timeIntervalSince(self as Date))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}

extension UIView
{
    func addBlurEffect(style: UIBlurEffectStyle) -> UIVisualEffectView
    {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
        
        return blurEffectView
    }
}

extension UIImage {
    func original() -> UIImage{
        let image = self.withRenderingMode(.alwaysOriginal)
        return image
    }
    func template() -> UIImage{
        let image = self.withRenderingMode(.alwaysTemplate)
        return image
    }
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}

extension FIRDatabase {
    
//    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()){
//        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let userDictionary = snapshot.value as? [String: Any] else {return}
//            let user = User(uid: uid, dictionary: userDictionary)
//            
//            completion(user)
//            
//        }) {(err) in
//            print("Failed to fetch the user with UID, ", err)
//        }
//    }
    
    static func fetchCategoriesWithUID(uid: String, completion: @escaping ([Category]) -> ()){
        FIRDatabase.database().reference().child("categories").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let allCategories = snapshot.value as? [String: Any] else {return}
            var categories = [Category]()
            
            allCategories.forEach({  (key, value) in
                let category = Category(id: key, dictionary: value as! [String : Any])
                categories.append(category)
            })
            
            completion(categories)
            
        }) {(err) in
            print("Failed to fetch the categories with UID", err)
        }
    }
    
//    static func fetchFollowedUsersWithUID(uid: String, completion: @escaping ([String: Int]) -> ()) {
//        FIRDatabase.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            
//            guard let usersUIDs = snapshot.value as? [String: Int] else {
//                //                print("nil snapshot from Firebase: ", snapshot)
//                return
//            }
//            
//            completion(usersUIDs)
//            
//        }) { (err) in
//            print("Failed to fetch followed users")
//        }
//    }    
}

