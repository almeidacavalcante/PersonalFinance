
//
//  AddCategoryController.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 27/10/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AddCategoryController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CategoryCellDelegate {
    

    let moreOverlay : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.currentColorScheme[0]
        return v
    }()

    let cellId = "cellId"
    let headerId = "headerId"
    
    var header : CategoryHeaderCell? {
        didSet{
            self.setupDoneButtonOnKeyboard()
        }
    }
    
    let insertButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.currentColorScheme[6]
        button.setTitle("CREATE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleInsertCategory), for: .touchUpInside)
        button.setTitleColor(UIColor.currentColorScheme[2], for: .normal)
        return button
    }()
    
    let availableIcons = [
        "bandage",
        "comment",
        "gas",
        "doc",
        "health",
        "home",
        "info",
        "lamp",
        "note",
        "plus",
        "task",
        "toast"
    ]
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.currentColorScheme[2]
        collectionView?.keyboardDismissMode = .interactive
        self.hideKeyboardWhenTappedAround()
        setupCollectionView()
        
        view.addSubview(insertButton)
        insertButton.anchor(top: collectionView?.bottomAnchor, left: view.leftAnchor, botton: view.bottomAnchor, right: view.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setupTitleLabelView()
        setupTitleLabelTransition(title: "New Category")
        
    }
    
    func handleInsertCategory(){
        self.insertCategory()
    }
    
    fileprivate func insertCategory(){
        let categoryName = header?.categoryNameTextField.text

        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
        let categoriesRef = FIRDatabase.database().reference().child("categories").child(uid)
        let ref = categoriesRef.childByAutoId()
        
        let assetName = selectedCategoryCell?.category?.assetName
        
        
        let values = ["name": categoryName,
                      "assetName": assetName]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to save category values in DB:", err)
            }
            
            print("Successfully saved the category in DB:")
        }
    }
    
    func setupDoneButtonOnKeyboard(){
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 40))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn, flexSpace], animated: false)
        toolbar.sizeToFit()
        
        //setting toolbar as inputAccessoryView
        self.header?.categoryNameTextField.inputAccessoryView = toolbar
    }
    
    func doneButtonAction() {
        self.view.endEditing(true)
    }

    let gradientView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.currentColorScheme[2]
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    func setupCollectionView(){
        
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(CategoryHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        view.addSubview(gradientView)
        gradientView.anchor(top: nil, left: collectionView?.leftAnchor, botton: collectionView?.bottomAnchor, right: collectionView?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
   
        collectionView?.backgroundColor = UIColor.currentColorScheme[0]
        collectionView?.anchor(top: view.topAnchor, left: view.leftAnchor, botton: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 100, paddingRight: 0, width: 0, height: 0)
        
        setupArrow()
    }
    
    var isHighlighted = false
    var arrow : UIImageView?
    var centerXConstraint : NSLayoutConstraint?
    var centerYConstraint : NSLayoutConstraint?
    
    func setupArrow(){

        arrow = UIImageView(image: #imageLiteral(resourceName: "arrow").withRenderingMode(.alwaysTemplate))
        arrow?.tintColor = UIColor.currentColorScheme[3]
        view.addSubview(arrow!)
        
        arrow?.translatesAutoresizingMaskIntoConstraints = false
        
        centerXConstraint = arrow?.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor)
        centerYConstraint = arrow?.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor)
        
        view.addConstraint(centerXConstraint!)
        view.addConstraint(centerYConstraint!)
        
    }
    
    override func viewDidLayoutSubviews() {
        if !masked {
            addGradientMask(targetView: gradientView)
            
            collectionView?.layoutIfNeeded()
        }
    }
    
    var masked = false
    // Add gradient mask to view
    func addGradientMask(targetView: UIView){
        masked = true
        let gradientMask = CAGradientLayer()
        
        
        gradientMask.frame = targetView.bounds

        gradientMask.colors = [UIColor.clear.cgColor, UIColor.lightYellow2.cgColor]
        gradientMask.locations = [0.0, 1.0]
        
        let maskView: UIView = UIView()
        maskView.layer.addSublayer(gradientMask)
        
        targetView.mask = maskView 
    }
    
    //MARK: Scroll behaviour.
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let contentOffset = scrollView.contentOffset.y
            let collectionViewHeigh = collectionView?.bounds.height
            let contentHeight = scrollView.contentSize.height
            
            let triggerOffset = contentHeight - collectionViewHeigh!

            if(contentOffset >= triggerOffset){
                if(!(gradientView.alpha == 0)){
                    dismissGradientOverlay()
                }
            }else{
                if(gradientView.alpha == 0){
                    
                    showGradientOverlay()
                }
            }
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }
    
    
    func dismissGradientOverlay(){
        self.isAlowedToAnimate = false
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.removeConstraint(self.centerYConstraint!)
            let constraint = self.centerYConstraint?.constant
            self.centerYConstraint = self.arrow?.centerYAnchor.constraint(equalTo: self.gradientView.centerYAnchor, constant: -constraint!-10)
            
            self.view.addConstraint(self.centerYConstraint!)
            
            self.gradientView.alpha = 0
            self.arrow?.alpha = 0
            
            self.view.layoutIfNeeded()
        }) { (true) in
            print("ARROW OUT!")
            
        }
    }
    
    func showGradientOverlay(){
        self.isAlowedToAnimate = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseOut, animations: {

            self.startArrowStandardAnimation()
            self.gradientView.alpha = 1
            self.arrow?.alpha = 1
            
            self.view.layoutIfNeeded()
        }) { (true) in
            print("ARROW IN!")
//            self.startArrowStandardAnimation()
        }
    }
    
    
    var isAlowedToAnimate = true
    func startArrowStandardAnimation(){
        print("ANIMATING...")
        print(isAlowedToAnimate)
        if self.isAlowedToAnimate{
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
                self.view.removeConstraint(self.centerYConstraint!)
                
                self.centerYConstraint = self.arrow?.centerYAnchor.constraint(equalTo: self.gradientView.centerYAnchor, constant: -3)
                
                self.view.addConstraint(self.centerYConstraint!)
                
                self.view.layoutIfNeeded()
            }) { (true) in
                if self.isAlowedToAnimate {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
                        self.view.removeConstraint(self.centerYConstraint!)
                        
                        self.centerYConstraint = self.arrow?.centerYAnchor.constraint(equalTo: self.gradientView.centerYAnchor, constant: 3)
                        
                        self.view.addConstraint(self.centerYConstraint!)
                        
                        self.view.layoutIfNeeded()
                        self.startArrowStandardAnimation()
                    })
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.isAlowedToAnimate = false
        print(isAlowedToAnimate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(animated){
            isAlowedToAnimate = true
            startArrowStandardAnimation()
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableIcons.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        
        cell.delegate = self
        
        cell.button.setImage(UIImage(named: availableIcons[indexPath.item])?.template(), for: .normal)
        cell.button.tintColor = UIColor.currentColorScheme[12]

        cell.resetColor()
        
        return cell
    }
    
    func didSelectCategory(cell: CategoryCell) {
        resetCategoryCellColor()
        self.selectedCategoryCell = cell
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            self.selectedCategoryCell?.backgroundColor = UIColor.currentColorScheme[6]
        })
    }
    
    
    var selectedCategoryCell : CategoryCell?
    
    
    func resetCategoryCellColor(){
        guard let cell = selectedCategoryCell else {return}
        cell.resetColor()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width/4-1
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        self.header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as? CategoryHeaderCell
        
        
        
        header?.backgroundColor = UIColor.currentColorScheme[0]
        return header!
    }
    
    
    //MARK: REPEATED CODE !!!! REFACTOR, PLEASE!
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

