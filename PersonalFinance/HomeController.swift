//
//  HomeController.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 19/10/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MyButton: UIButton {

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsetsMake(-25, -25, -25, -25)
        let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
        return hitFrame.contains(point)
    }

}

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, HeaderCellDelegate, CategoryCellDelegate {
    
    let footerContainer : UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.currentColorScheme[2]
        return container
    }()
    
    let finishButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("INSERT", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.currentColorScheme[2], for: .normal)
        button.backgroundColor = UIColor.currentColorScheme[6]
        button.addTarget(self, action: #selector(handleInsert), for: .touchUpInside)
        return button
    }()
    
    let noteButton : UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "edit3").template(), for: .normal)
        button.tintColor = UIColor.currentColorScheme[2]
        button.backgroundColor = UIColor.currentColorScheme[11]
        button.addTarget(self, action: #selector(handleNote), for: .touchUpInside)
        return button
    }()
    
    
    
    var header : HeaderCell?
    
    //MODEL: Separate this in a model class
    var categories : [Category]?

    
    let cellId = "cellId"
    let headerId = "headerId"
    let footerId = "footerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.keyboardDismissMode = .interactive
        
        fetchCategories()
        
        
        //134,172,151
        view.backgroundColor = UIColor.currentColorScheme[3]
        
        self.handleLogin()
        setupCollectionView()
        setupNavigationBar()
        setupContainerView()
        setupBlackView()
        

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func fetchCategories(){
        LibraryAPI.sharedInstance.fetchCategories { (categories) in
            self.categories = categories
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func handleInsert(){
        self.showOverlayScreen()
        self.saveTheBill()
    }
    
    func handleNote(){
        self.noteButton.isEnabled = false
        
        self.showNoteOverlay()
    }
    
    func showNoteOverlay(){

        horizontalOverlay.backgroundColor = UIColor.currentColorScheme[3]
        
        view.addSubview(horizontalOverlay) 
        
        horizontalOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: horizontalOverlay, attribute: .left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: -1).isActive = true
        NSLayoutConstraint(item: horizontalOverlay, attribute: .top, relatedBy: .equal, toItem: header, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        heightConstraint = NSLayoutConstraint(item: horizontalOverlay, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 3)
        view.addConstraint(heightConstraint!)
        

        view.layoutIfNeeded()
        
        animateNoteTextField()
    }
    
    let noteTextField : TextField = {
        let tf = TextField()
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        tf.textAlignment = .left
        tf.contentVerticalAlignment = .center
        tf.placeholder = "Enter some note"
        tf.textColor = UIColor.currentColorScheme[9]
        return tf
    }()
    
    
    
    var heightConstraint : NSLayoutConstraint?
    var trailingConstraint : NSLayoutConstraint?
    var headerHeightConstraint : NSLayoutConstraint?
    
    let horizontalOverlay = UIView()
    
    func animateNoteTextField(){
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.trailingConstraint = NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: self.horizontalOverlay, attribute: .trailing, multiplier: 1, constant: 0)
            
            
            self.view.addConstraint(self.trailingConstraint!)
            

            self.view.layoutIfNeeded()

            
        }) { (success:Bool) in
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.view.removeConstraint(self.heightConstraint!)
                self.heightConstraint = NSLayoutConstraint(item: self.horizontalOverlay, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 10, constant: 40)
                
                self.view.addConstraint(self.heightConstraint!)
                
                self.view.layoutIfNeeded()
                
            }) { (success:Bool) in
                self.setupNoteTextField()
                print("IN---------------")
            }
        }
    }
    
    func animateOutNoteTextField(){
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.submitButton.removeFromSuperview()
            self.view.removeConstraint(self.heightConstraint!)
            self.heightConstraint = NSLayoutConstraint(item: self.horizontalOverlay, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 10, constant: 4)
            
            self.view.addConstraint(self.heightConstraint!)
            
            self.view.layoutIfNeeded()

            
        }) { (success:Bool) in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.view.removeConstraint(self.trailingConstraint!)
                self.view.removeConstraint(self.heightConstraint!)
                self.heightConstraint = NSLayoutConstraint(item: self.horizontalOverlay, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 4)
                self.view.addConstraint(self.heightConstraint!)
                
                self.view.layoutIfNeeded()
                
            }) { (success:Bool) in
                self.separatorView?.removeFromSuperview()
                self.view.removeConstraint(self.heightConstraint!)
                self.noteButton.isEnabled = true
                self.showsAddedNote()
                print("OUT---------------")
            }
        }
    }
    
    let infoButton : UIButton = {
        let button = UIButton(type: .system)
        button.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
//        button.backgroundColor = .black
        button.addTarget(self, action: #selector(handleInfo), for: .touchUpInside)
        return button
    }()
    
    
    let infoOverlay : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.currentColorScheme[3]
        return view
    }()
    var infoWidthConstraint : NSLayoutConstraint?
    
    
    func handleInfo(){
        view.addSubview(infoOverlay)
        infoOverlay.anchor(top: navigationController?.navigationBar.bottomAnchor, left: header?.leftAnchor, botton: nil, right: nil, paddingTop:1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        self.view.layoutIfNeeded()
        
        animateInfoIn()
    }
    
    let closeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "x").template(), for: .normal)
        button.tintColor = UIColor.currentColorScheme[9]
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    func handleClose(){
        animateInfoOut()
    }
    
    func animateInfoOut(){
        
        infoWidthConstraint = NSLayoutConstraint(item: infoOverlay, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.infoOverlay.removeShadow()
            self.view.removeConstraint(self.infoWidthConstraint!)
            self.view.addConstraint(self.infoWidthConstraint!)
            self.infoLabel.removeFromSuperview()
            self.view.layoutIfNeeded()
            
            
        }) { (true) in
            self.closeButton.removeFromSuperview()
            
            print("INFO ANIMATED OUT")
        }
    }
    
    func animateInfoIn(){
        
        if self.infoWidthConstraint != nil {
            self.view.removeConstraint(self.infoWidthConstraint!)
        }
        
        infoWidthConstraint = NSLayoutConstraint(item: infoOverlay, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            
            self.view.addConstraint(self.infoWidthConstraint!)
            
            self.view.layoutIfNeeded()
            
        }) { (true) in
            
            self.animateLabelAndCloseButton()
            self.infoOverlay.dropShadow()
            print("INFO ANIMATED")
        }
    }
    
    let infoLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.currentColorScheme[9]
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        
        return label
    }()
    
    func animateLabelAndCloseButton(){
        
        self.infoOverlay.addSubview(self.closeButton)
        self.infoOverlay.addSubview(self.infoLabel)
        
        self.closeButton.anchor(top: self.infoOverlay.topAnchor, left: nil, botton: nil, right: self.infoOverlay.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 20, height: 20)
        self.infoLabel.anchor(top: self.infoOverlay.topAnchor, left: self.infoOverlay.leftAnchor, botton: self.infoOverlay.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 170, height: 0)
        
        closeButton.alpha = 0
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3) {
            
            self.closeButton.alpha = 1
            self.infoLabel.text = self.lastNote
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    func showsAddedNote(){
        
        infoButton.tintColor = UIColor.currentColorScheme[3]
        UIView.animate(withDuration: 0.5) {
            self.infoButton.alpha = 1
        }
    }
    
    func hidesAddedNote(){
        UIView.animate(withDuration: 0.5) {
            self.infoButton.alpha = 0
        }
    }

    var separatorView : UIView?
    
    var submitButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ENTER", for: .normal)
        button.setTitleColor(UIColor.currentColorScheme[2], for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    func setupNoteTextField(){
        view.addSubview(noteTextField)
        noteTextField.anchor(top: header?.bottomAnchor, left: view.leftAnchor, botton: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width-76, height: 40)
        
        noteTextField.becomeFirstResponder()
        
        separatorView = UIView()
        separatorView?.backgroundColor = UIColor.currentColorScheme[1]
        horizontalOverlay.addSubview(submitButton)
        horizontalOverlay.addSubview(separatorView!)
        
        submitButton.anchor(top: horizontalOverlay.topAnchor, left: nil, botton: horizontalOverlay.bottomAnchor, right: horizontalOverlay.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        separatorView?.anchor(top: nil, left: horizontalOverlay.leftAnchor, botton: horizontalOverlay.bottomAnchor, right: horizontalOverlay.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        view.layoutIfNeeded()
    }
    
    
    var lastNote = ""
    
    func handleSend(){
        print("Handle Send.")
        
        if let text = noteTextField.text {
            lastNote = text
        }
        noteTextField.text = ""
        noteTextField.removeFromSuperview()
        animateOutNoteTextField()
    }
    

    
    func drawACircle() -> CAShapeLayer{
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0), radius: CGFloat(25), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer() 
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.currentColorScheme[4].cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.currentColorScheme[3].cgColor
        //you can change the line width
        shapeLayer.lineWidth = 1.0
        return shapeLayer
    }
    
    func showOverlayScreen(){
        let overlay = UIView()
        let circle = UIView()
        
        let width = CGFloat(50)
        
        circle.layer.cornerRadius = width/2
        circle.backgroundColor = UIColor.currentColorScheme[5]
        circle.alpha = 0
        circle.frame.origin.x += 25
        circle.frame.origin.y += 25
        
        view.addSubview(overlay)
        overlay.addSubview(circle)
        
        overlay.backgroundColor = UIColor.currentColorScheme[6]
        overlay.anchor(top: navigationController?.navigationBar.bottomAnchor, left: view.leftAnchor, botton: footerContainer.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        circle.anchor(top: nil, left: nil, botton: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: width, height: width)
        
        
        let rect = CGRect(x: overlay.layer.position.x, y: overlay.layer.position.y, width: self.view.frame.width, height: self.view.frame.height-footerContainer.frame.height)
        
        //circle.mask(withRect: rect, inverse: true)
        overlay.mask(withRect: rect)

        
        print("BOUNDS ---------->",overlay.layer.bounds)
        circle.centerXAnchor.constraint(equalTo: overlay.centerXAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: overlay.centerYAnchor).isActive = true
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            overlay.frame.origin.x += (self.view.frame.width)
            
        }) { (true) in
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
               circle.frame.origin.y += 20
               circle.alpha = 1
            }) { (true) in
                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {

                    let rate = self.view.frame.height*3/circle.frame.width
                    
                    circle.transform = CGAffineTransform(scaleX: rate, y: rate)
                    
                }) { (true) in
                    circle.removeFromSuperview()
                    overlay.removeFromSuperview()
                    self.resetScreen()
                }
            }
        }
    }
    
    func resetScreen(){
        header?.currencyField.text = "$0.00"
        resetCategoryCellColor()
        hidesAddedNote()
        selectedCategoryCell = nil
        setupTitleLabelTransition(title: "")
    }
    
    func handleLogin(){
        
        let email = "bill@bill.com"
        let password = "bill123"
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
            
            if let err = err {
                print("Failed to log beck in with email: ", err)
                return
            }
            
            print("Successfully logged in with the user id: ", user?.uid ?? "")
        })
    }
    
    func handleLogout(){
        print("Logging out")
    }
    
    
    fileprivate func insertCategory(imageUrl: String){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
        // Categories -> User Id -> Category Id
        let ref = FIRDatabase.database().reference().child("categories").child(uid).childByAutoId()
        
        let description = "Snacks and little things"
        
        let values = ["description": description,
                      "imageUrl": imageUrl]
        
        ref.updateChildValues(values)
    }
    
    func stringToPlainDouble(rawValue: String) -> Double{
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        let cleanValue = regex.stringByReplacingMatches(in: rawValue, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, rawValue.count), withTemplate: "")
        let double = Double(cleanValue)
        let value = double! / 100
        return value
    }
    
    fileprivate func saveTheBill(){
        guard let rawValue = header?.currencyField.text else {return}

        let value = stringToPlainDouble(rawValue: rawValue)
        
        //MARK: - Use the Adapter (Couping code)
        guard let uid = DefaultUser.currentUser.uid else {return}
        
        guard let category = selectedCategoryCell?.category else {return}
        guard let categoryId = category.id else {return}
        
        let userPostRef = FIRDatabase.database().reference().child("bills").child(uid)
        let ref = userPostRef.childByAutoId()

        let values = ["value": value,
                      "categoryId": categoryId,
                      "note" : lastNote,
                      "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to save post values in DB:", err)
            }
            
            print("Successfully saved the post in DB:")
        }
    }
    
    lazy var openMenuBarButton : UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        
        let icon = UIImage(named: "menu")?.template()
        
        guard let iconWidth = icon?.size.width else {return barButton}
            
        let iconSize = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: iconWidth, height: iconWidth))
        
        let size = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        let iconButton = UIButton()
            
        iconButton.addTarget(self, action: #selector(handleManu), for: .touchUpInside)
        iconButton.frame = size
        iconButton.imageView?.frame = iconSize
        iconButton.setImage(icon, for: .normal)
        iconButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
 
        barButton.customView = iconButton
    
        return barButton
    }()
    
    var menu : UIView = {
        let menu = UIView()
        menu.backgroundColor = UIColor.currentColorScheme[8]
        return menu
    }()
    
    func handleManu(){
        print("Open MENU")
        view.addSubview(menu)
        menu.anchor(top: view.topAnchor, left: view.leftAnchor, botton: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.layoutIfNeeded()
        
        if !isMenuOn {
            animateMenuIn()
        }else{
            animateMenuOut()
        }
        
    }
    
    var menuWidthConstraint : NSLayoutConstraint?
    var isMenuOn = false
    
    func animateMenuIn(){
        
        animateMenuIconIn()
        
        if self.menuWidthConstraint != nil {
            self.view.removeConstraint(self.menuWidthConstraint!)
        }
        
        menuWidthConstraint = NSLayoutConstraint(item: menu, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 54)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 6, options: .curveEaseInOut, animations: {
            
            self.view.addConstraint(self.menuWidthConstraint!)
            
            self.view.layoutIfNeeded()
            
        }) { (true) in
            self.isMenuOn = !self.isMenuOn
            self.menu.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: 1, height: 0), radius: 1, scale: true)

            self.view.layoutIfNeeded()
            print("MENU ANIMATED IN")
        }
        
        self.animateMenusIn()
        
    }
    
    //MARK: MENU
    let addCategoryButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "add2").template(), for: .normal)
        button.tintColor = UIColor.currentColorScheme[3]
        button.addTarget(self, action: #selector(handleAddCategory), for: .touchUpInside)
        return button
    }()
    let calendarDayButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "calendar1").template(), for: .normal)
        button.tintColor = UIColor.currentColorScheme[3]
        return button
    }()
    let calendarWeekButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "calendar7-").template(), for: .normal)
        button.tintColor = UIColor.currentColorScheme[3]
        button.addTarget(self, action: #selector(handleBillsController), for: .touchUpInside)
        return button
    }()
    let calendarMonthButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "calendar30").template(), for: .normal)
        button.tintColor = UIColor.currentColorScheme[3]
        button.addTarget(self, action: #selector(handleOpenMonthReport), for: .touchUpInside)
        return button
    }()
    
    func handleBillsController(){
        let controller = BillsController()
        controller.homeControllerRef = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleOpenMonthReport(){
//        guard let controller = monthReportController else {
//            let layout = UICollectionViewFlowLayout()
//            self.monthReportController = MonthReportController(collectionViewLayout: layout)
//            self.monthReportController?.homeControllerRef = self
//            navigationController?.pushViewController(self.monthReportController!, animated: true)
//            return
//        }
        
        let layout = UICollectionViewFlowLayout()
        let controller = MonthReportController(collectionViewLayout: layout)
        controller.homeControllerRef = self
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func animateMenusIn(){
        animateMenusIconsIndividuallyIn(buttons: [addCategoryButton,calendarDayButton,calendarWeekButton, calendarMonthButton], yOffset: 30, delay: 0.0)
    }
    
    func animateMenusOut(){
        animateMenusIconsIndividuallyOut(buttons: [addCategoryButton,calendarDayButton,calendarWeekButton, calendarMonthButton], delay: 0.0)
    }
    
    var menusXPositionConstraints : [NSLayoutConstraint] = []
    
    func animateMenusIconsIndividuallyIn(buttons: [UIButton], yOffset: CGFloat, delay: TimeInterval){
        

        let increment : CGFloat = 60
        var allButtons = buttons
        guard let button = buttons.first else {return}
        
        self.menu.addSubview(button)
        
        button.anchor(top: self.menu.topAnchor, left: self.menu.leftAnchor, botton: nil, right: nil, paddingTop: 4.0+yOffset, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        //Menu OUT Constraint
        var constraint = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: self.menu, attribute: .leading, multiplier: 1, constant: -50)
        
        
        self.view.addConstraint(constraint)
        button.alpha = 0
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            self.view.removeConstraint(constraint)
            
            //Menu In Constraint
            constraint = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: self.menu, attribute: .leading, multiplier: 1, constant: 6)
            
            self.view.addConstraint(constraint)
            self.menusXPositionConstraints.append(constraint)
            button.alpha = 1
            self.view.layoutIfNeeded()
            
        }, completion: { (true) in
            print("Individual menu animated")
        })
        
        allButtons.removeFirst()
        self.animateMenusIconsIndividuallyIn(buttons: allButtons, yOffset: yOffset+increment, delay: delay+0.1)

    }
    
    var menuIndex = 0
    
    func animateMenusIconsIndividuallyOut(buttons: [UIButton], delay: TimeInterval){
        
        var allButtons = buttons
        var constraint = menusXPositionConstraints[menuIndex]
        guard let button = buttons.first else {return}
        
        //New Constraint!
        constraint = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: self.menu, attribute: .leading, multiplier: 1, constant: -50)
        
        self.menusXPositionConstraints[menuIndex] = constraint
        
        UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            self.view.removeConstraint(constraint)
            self.view.addConstraint(constraint)
            
            button.alpha = 0
            self.view.layoutIfNeeded()
            
        }, completion: { (true) in
            print("Individual menu animated out")
            
        })
        

        allButtons.removeFirst()
        if menuIndex <= buttons.count {
            menuIndex += 1
            self.animateMenusIconsIndividuallyOut(buttons: allButtons, delay: delay)
        }else{
            menuIndex = 0
            self.menusXPositionConstraints.removeAll()
            self.addCategoryButton.removeFromSuperview()
            self.calendarDayButton.removeFromSuperview()
            self.calendarWeekButton.removeFromSuperview()
            self.calendarMonthButton.removeFromSuperview()
            self.view.removeConstraints(menusXPositionConstraints)
        }
    }
    
    func animateMenuOut(){
        
        animateMenuIconOut()
        animateMenusOut()
        
        menuWidthConstraint = NSLayoutConstraint(item: menu, attribute: .width, relatedBy: .equal
            , toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            
            self.view.removeConstraint(self.menuWidthConstraint!)
            self.menu.removeShadow()
            self.view.addConstraint(self.menuWidthConstraint!)
            
            self.view.layoutIfNeeded()
            
        }) { (true) in
            self.isMenuOn = !self.isMenuOn
        
            print("MENU ANIMATED OUT")
        }
    }
    
    func animateMenuIconIn(){
        //openMenuBarButton
        
    
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.33, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
        
            self.openMenuBarButton.customView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            let button = self.openMenuBarButton.customView as! UIButton
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0)
            self.openMenuBarButton.customView = button
            self.openMenuBarButton.customView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        })
        self.openMenuBarButton.customView?.layoutIfNeeded()
    }
    
    func animateMenuIconOut(){
        //openMenuBarButton

        let button = self.openMenuBarButton.customView as! UIButton
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.openMenuBarButton.customView = button
        self.openMenuBarButton.customView?.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.33, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            
            self.openMenuBarButton.customView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)

            self.openMenuBarButton.customView?.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    
    var addCategoryController : AddCategoryController?
    var monthReportController : MonthReportController?
    
    
    func handleAddCategory(){
        guard let controller = addCategoryController else {
            let layout = UICollectionViewFlowLayout()
            self.addCategoryController = AddCategoryController(collectionViewLayout: layout)
            self.addCategoryController?.homeControllerRef = self
            navigationController?.pushViewController(self.addCategoryController!, animated: true)
            return
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor.currentColorScheme[1]
        setStatusBarBackgroundColor(color: UIColor.currentColorScheme[2])
        
        navigationItem.leftBarButtonItem = openMenuBarButton
        
        navigationController?.navigationBar.tintColor = UIColor.currentColorScheme[3]
        
        navigationItem.rightBarButtonItem?.imageInsets.top = 2
        navigationItem.rightBarButtonItem?.imageInsets.bottom = -2
        navigationItem.leftBarButtonItem?.imageInsets.top = 2
        navigationItem.leftBarButtonItem?.imageInsets.bottom = -2
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
    func setupContainerView(){
        view.addSubview(footerContainer)
        footerContainer.addSubview(finishButton)
        finishButton.addSubview(noteButton)
        
        
        
        footerContainer.anchor(top: collectionView?.bottomAnchor, left: view.leftAnchor, botton: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        finishButton.anchor(top: footerContainer.topAnchor, left: footerContainer.leftAnchor, botton: footerContainer.bottomAnchor, right: footerContainer.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        noteButton.anchor(top: finishButton.topAnchor, left: nil, botton: nil, right: finishButton.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 60, height: 60)
        finishButton.layoutSubviews()
        
    }
    
    func setupCollectionView(){
        self.hideKeyboardWhenTappedAround()
        self.collectionView!.alwaysBounceVertical = true
        collectionView?.delegate = self
        
        //134,172,151
        collectionView?.backgroundColor = UIColor.currentColorScheme[0]
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView?.anchor(top: view.topAnchor, left: view.leftAnchor, botton: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 100, paddingRight: 0, width: 0, height: 0)
        

        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let unwrappedCategories = self.categories else {return 0}
        return unwrappedCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width-2)/3
        
        return CGSize(width: width, height: width - 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        
        let assetName = categories?[indexPath.item].assetName
        cell.button.setImage(UIImage(named: assetName!)?.template(), for: .normal)
        
        cell.category = categories?[indexPath.item]
        
        cell.delegate = self
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //MARK: DID SELECT CATEGORY
    
    var selectedCategoryCell : CategoryCell?
    
    func didSelectCategory(cell: CategoryCell) {
        resetCategoryCellColor()
        selectedCategoryCell = cell
        self.setupTitleLabelView()
        self.setupTitleLabelTransition(title: (selectedCategoryCell?.category?.descriptionContent)!)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            self.selectedCategoryCell?.backgroundColor = UIColor.currentColorScheme[6]
        })
        
    }
    
    fileprivate func resetCategoryCellColor(){
        guard let cell = selectedCategoryCell else {return}
        cell.resetColor()
    }
    
    //MARK: HEADER
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! HeaderCell
        
        

        header.currencyField.delegate = self
        
        self.header = header
        
        setupAddedNote()
    
        return self.header!
    }
    
    
    func setupAddedNote(){
        infoButton.setImage(#imageLiteral(resourceName: "info").template(), for: .normal)
        
        view.addSubview(infoButton)
        infoButton.anchor(top: self.header?.topAnchor, left: self.header?.leftAnchor, botton: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        infoButton.alpha = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let screenWidth = view.frame.width
        return CGSize(width: screenWidth, height: 100)
    }
    
    
    //MARK: TextField Delegation
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    let blackView = UIView()
    func setupBlackView(){
        let label = UILabel()
        label.text = "Dismiss keyboard"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        blackView.addSubview(label)
        label.anchor(top: blackView.topAnchor, left: blackView.leftAnchor, botton: nil, right: blackView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(didFinishEditing))
        blackView.addGestureRecognizer(gestureRec)
    }

    
    func didFinishEditing(){
        guard let header = self.header else {return}
        self.dismissKeyboard()
//        header.didFinishEditing()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {        
        
        view.addSubview(blackView)
        
        
        blackView.anchor(top: textField.bottomAnchor, left: view.leftAnchor, botton: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        

        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            
            self.header?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
            
            self.blackView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)

        }) { (_) in

        }
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            
            self.blackView.backgroundColor = UIColor(white: 1, alpha: 0)
            
            self.blackView.removeFromSuperview()
            
            
        }) { (_) in
            print("animated")
        }
        
    }

    fileprivate func setupTitleLabelTransition(title: String){
        let titleAnimation = CATransition()
        titleAnimation.duration = 0.5
        titleAnimation.type = kCATransitionFade
        titleAnimation.subtype = kCATransitionFromTop
        titleAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        self.navigationItem.titleView!.layer.add(titleAnimation, forKey: "changeTitle")
        (self.navigationItem.titleView as! UILabel).text = title
        
        // I added this to autosize the title after setting new text
        (self.navigationItem.titleView as! UILabel).sizeToFit()
    }
    
    fileprivate func setupTitleLabelView(){
        let titleLabelView = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        titleLabelView.backgroundColor = UIColor.clear
        titleLabelView.textAlignment = .center
        // this next line picks up the UINavBar tint color instead of fixing it to a particular one as in Gavin's solution
        titleLabelView.textColor = UIColor.currentColorScheme[3]
        titleLabelView.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabelView.text = ""
        self.navigationItem.titleView = titleLabelView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

		
