
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
    
    var homeControllerRef : HomeController?
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
    
    
    
    
    var availableIcons : [(key: String, value: Int)] = [
        ("bandage", 0),
        ("comment", 0),
        ("gas", 0),
        ("doc", 0),
        ("health", 0),
        ("home", 0),
        ("info", 0),
        ("lamp", 0),
        ("note", 0),
        ("plus", 0),
        ("task", 0),
        ("toast", 0),
        ("love", 0),
        ("dollar", 0),
        ("dollar2", 0),
        ("hugby", 0),
        ("hugby2", 0),
        ("bus", 0),
        ("phone", 0),
        ("cam", 0),
        ("book", 0),
        ("books2", 0),
        ("books", 0),
        ("auction", 0)
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
        
        guard let categoryName = header?.categoryNameTextField.text else {return}
        guard let assetName = selectedCategoryCell?.category?.assetName else {return}
        
        let category = Category(descriptionContent: categoryName, assetName: assetName)
        
        guard let uid = DefaultUser.currentUser.uid else {return}
        
        let categoriesRef = FIRDatabase.database().reference().child("categories").child(uid)
        let usedAssetsRef = FIRDatabase.database().reference().child("usedAssets").child(uid)
        
        let ref = categoriesRef.childByAutoId()
        let assetRef = usedAssetsRef.childByAutoId()
        
        let values = ["name": category.descriptionContent,
                      "assetName": category.assetName]
        
//        let assetValue = ["assetName": category.assetName]
//
//        assetRef.updateChildValues(assetValue) { (err, ref) in
//            if let err = err {
//                print("Failed to save the asset name in DB:", err)
//            }
//            print("Successfully save the asset name in DB")
//        }
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to save category values in DB:", err)
            }
            
            print("Successfully saved the category in DB:")
            DispatchQueue.main.async {
                
                self.resetScreen()
            }
        }
    }
    
    func resetScreen(){
        homeControllerRef?.fetchCategories()
        collectionView?.resetScrollPositionToTop()
        collectionView?.reloadData()
        header?.categoryNameTextField.text = ""
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

    fileprivate func setupSelectableCategory(_ indexPath: IndexPath, _ cell: CategoryCell) {
        let category = Category(descriptionContent: "", assetName: availableIcons[indexPath.item].key)
        
        cell.category = category
        cell.button.setImage(UIImage(named: category.assetName!)?.template(), for: .normal)
        cell.button.tintColor = UIColor.currentColorScheme[12]
        
        if selectedIndexPath == indexPath {
            
            cell.didSelectCategory()
            
        }
    }
    
    fileprivate func setupUnselectableCategory(_ indexPath: IndexPath, _ cell: CategoryCell) {
        let category = Category(descriptionContent: "", assetName: availableIcons[indexPath.item].key)
        
        cell.category = category
        cell.button.setImage(UIImage(named: category.assetName!)?.template(), for: .normal)
        cell.button.tintColor = UIColor.currentColorScheme[12]
        cell.backgroundColor = UIColor.currentColorScheme[14]
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        

        cell.delegate = self
        cell.indexPath = indexPath
        
        if cell.category?.assetName == nil {
            
            if availableIcons[indexPath.item].value == 0 {
                setupSelectableCategory(indexPath, cell)
                return cell
            }
            else if availableIcons[indexPath.item].value == 1 {
                setupUnselectableCategory(indexPath, cell)
                return cell
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
        cell.indexPath = indexPath
        
        if selectedIndexPath == indexPath{
            self.didDeselectCategory(cell: cell)
            selectedIndexPath = nil
        }else if availableIcons[indexPath.item].value == 0{
            self.didSelectCategory(cell: cell)
        }
    }
    
    var selectedIndexPath: IndexPath?
    var selectedCategoryCell : CategoryCell?
    
    func didSelectCategory(cell: CategoryCell) {
        resetCategoryCellColor()
        self.selectedCategoryCell = cell
        self.selectedIndexPath = cell.indexPath
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            self.selectedCategoryCell?.backgroundColor = UIColor.currentColorScheme[6]
        })
    }
    
    func didDeselectCategory(cell: CategoryCell){
        cell.indexPath = nil
        self.selectedIndexPath = nil
        self.selectedCategoryCell = nil
        cell.resetColor()
    }
    
    
    
    
    
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

