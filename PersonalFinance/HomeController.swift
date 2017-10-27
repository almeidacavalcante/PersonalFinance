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




class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, HeaderCellDelegate, CategoryCellDelegate {
    
    let footerContainer : UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.rgb(red: 255, green: 247, blue: 192)
        return container
    }()
    
    let finishButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("INSERIR", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.lightYellow
        button.addTarget(self, action: #selector(handleInsert), for: .touchUpInside)
        return button
    }()
    
    let noteButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "note").original(), for: .normal)
        button.backgroundColor = UIColor.lightYellow2
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
        
        self.categories = [Category(descriptionContent: "Health", assetName: "bandage"),
                            Category(descriptionContent: "Fuel", assetName: "gas"),
                            Category(descriptionContent: "Home", assetName: "home"),
                            Category(descriptionContent: "Energy", assetName: "lamp"),
                            Category(descriptionContent: "Food", assetName: "toast")]
        
        //134,172,151
        view.backgroundColor = UIColor.rgb(red: 134, green: 172, blue: 151)
        
        self.handleLogin()
        setupCollectionView()
        setupNavigationBar()
        setupContainerView()
        setupBlackView()
        

    }
    
//    func fetchCategories(){
//        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
//        
//        FIRDatabase.fetchCategoriesWithUID(uid: uid) { (categories) in
//            self.categories = categories
//            DispatchQueue.main.async {
//                self.collectionView?.reloadData()
//            }
//        }
//    }
    
    func handleInsert(){
//        self.saveImageAndGenerateUrl()
        
        self.showOverlayScreen()
        
        self.saveTheBill()

    }
    
    func handleNote(){
        self.noteButton.isEnabled = false
        
        self.showNoteOverlay()
    }
    
    func showNoteOverlay(){

        horizontalOverlay.backgroundColor = .white
        
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
        tf.textColor = UIColor(white: 0, alpha: 0.3)
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
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "info").withRenderingMode(.alwaysOriginal))
    
    func showsAddedNote(){
        UIView.animate(withDuration: 0.5) {
            self.imageView.alpha = 1
        }
    }
    
    func hidesAddedNote(){
        UIView.animate(withDuration: 0.5) {
            self.imageView.alpha = 0
        }
    }

    var separatorView : UIView?
    
    var submitButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    func setupNoteTextField(){
        view.addSubview(noteTextField)
        noteTextField.anchor(top: header?.bottomAnchor, left: view.leftAnchor, botton: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width-76, height: 40)
        
        noteTextField.becomeFirstResponder()
        
        separatorView = UIView()
        separatorView?.backgroundColor = .salmao
        horizontalOverlay.addSubview(submitButton)
        horizontalOverlay.addSubview(separatorView!)
        
        submitButton.anchor(top: horizontalOverlay.topAnchor, left: nil, botton: horizontalOverlay.bottomAnchor, right: horizontalOverlay.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        separatorView?.anchor(top: nil, left: horizontalOverlay.leftAnchor, botton: horizontalOverlay.bottomAnchor, right: horizontalOverlay.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        view.layoutIfNeeded()
    }
    
    
    
    func handleSend(){
        print("Handle Send.")

        
        
        
        noteTextField.text = ""
        noteTextField.removeFromSuperview()
        animateOutNoteTextField()
    }
    

    
    func drawACircle() -> CAShapeLayer{
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0), radius: CGFloat(25), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer() 
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.lightYellow.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.lightYellow.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 1.0
        return shapeLayer
    }
    
    func showOverlayScreen(){
        let overlay = UIView()
        let circle = UIView()
        
        let width = CGFloat(50)
        
        circle.layer.cornerRadius = width/2
        circle.backgroundColor = UIColor.lightYellow3
        circle.alpha = 0
        circle.frame.origin.x += 25
        circle.frame.origin.y += 25
        
        view.addSubview(overlay)
        overlay.addSubview(circle)
        
        overlay.backgroundColor = UIColor.lightYellow
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
        do {
            try FIRAuth.auth()?.signOut()
            DispatchQueue.main.async {
                let signInController = SignInController()
                self.navigationController?.pushViewController(signInController, animated: true)
                
            }
        } catch let signOutErr {
            print("Failed to sign out:", signOutErr)
        }
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
    
    
    
    fileprivate func saveTheBill(){
        var rawValue = header?.currencyField.text
        rawValue?.remove(at: (rawValue?.startIndex)!)
        print("RAW VALUE -------> ", rawValue)
        
        
        guard let value = Double(rawValue!) else {return}
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
        let userPostRef = FIRDatabase.database().reference().child("bills").child(uid)
        let ref = userPostRef.childByAutoId()
        let categoryId = selectedCategoryCell?.category?.assetName
        
        let values = ["value": value,
                      "categoryId": categoryId
                        ,"creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to save post values in DB:", err)
            }
            
            print("Successfully saved the post in DB:")
        }
    }
    
    //MARK: NAVIGATION BAR ITEMS
    lazy var addCategoryBarButton : UIBarButtonItem = {
            let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
        
        return barButton
    }()
    
    func handleAddCategory(){
        print("handleAddCategory")
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor.lightYellow
        setStatusBarBackgroundColor(color: UIColor.lightYellow2)
        navigationItem.rightBarButtonItem = addCategoryBarButton
        
        navigationItem.rightBarButtonItem?.imageInsets.top = 2
        navigationItem.rightBarButtonItem?.imageInsets.bottom = -2
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
    func setupContainerView(){
        
        let width = view.frame.width/3
        
        view.addSubview(footerContainer)
        footerContainer.addSubview(finishButton)
        footerContainer.addSubview(noteButton)
        
        
        footerContainer.anchor(top: collectionView?.bottomAnchor, left: view.leftAnchor, botton: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        finishButton.anchor(top: footerContainer.topAnchor, left: footerContainer.leftAnchor, botton: footerContainer.bottomAnchor, right: nil, paddingTop: 1, paddingLeft: 1, paddingBottom: 1, paddingRight: 0, width: 2.25 * width, height: 0)
        noteButton.anchor(top: footerContainer.topAnchor, left: finishButton.rightAnchor, botton: footerContainer.bottomAnchor, right: footerContainer.rightAnchor, paddingTop: 1, paddingLeft: 1, paddingBottom: 1, paddingRight: 1, width: 0, height: 0)
        
    }
    
    func setupCollectionView(){
        self.hideKeyboardWhenTappedAround()
        self.collectionView!.alwaysBounceVertical = true
        collectionView?.delegate = self
        
        //134,172,151
        collectionView?.backgroundColor = UIColor.lightYellow3
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
        cell.button.setImage(UIImage(named: assetName!)?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        cell.category = categories?[indexPath.item]
        
        cell.delegate = self
        
        //191,218,175
        cell.backgroundColor = UIColor.lightYellow2
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
        selectedCategoryCell?.backgroundColor = UIColor.salmao
    }
    
    fileprivate func resetCategoryCellColor(){
        guard let cell = selectedCategoryCell else {return}
        cell.backgroundColor = UIColor.lightYellow2
    }
    
    //MARK: HEADER
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! HeaderCell
        
        

        header.currencyField.delegate = self
        
        self.header = header
        
        setupAddedNote()
    
        return header
    }
    
    
    func setupAddedNote(){
        view.addSubview(imageView)
        imageView.anchor(top: self.header?.topAnchor, left: self.header?.leftAnchor, botton: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        imageView.alpha = 0
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
//        let title = ""
//        setupTitleLabelTransition(title: title)

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
        titleLabelView.textColor = UINavigationBar.appearance().tintColor
        titleLabelView.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabelView.text = ""
        self.navigationItem.titleView = titleLabelView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

		
