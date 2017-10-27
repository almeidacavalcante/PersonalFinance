
//
//  AddCategoryController.swift
//  PersonalFinance
//
//  Created by José de Almeida Cavalcante Neto on 27/10/17.
//  Copyright © 2017 José de Almeida Cavalcante Neto. All rights reserved.
//


import UIKit

class AddCategoryController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let categoryNameTextField : TextField = {
        let tf = TextField()
        tf.backgroundColor = .lightYellow4
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textAlignment = .left
        tf.contentVerticalAlignment = .center
        
        return tf
    }()
    
    let categoryNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Category Name: "
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    let moreOverlay : UIView = {
        let v = UIView()
        v.backgroundColor = .lightYellow2
        return v
    }()

    
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var header : UICollectionViewCell?
    
    override func viewDidLoad() {
        view.backgroundColor = .lightYellow2
        
        setupCollectionView()
        
        collectionView?.addSubview(categoryNameTextField)
        collectionView?.addSubview(categoryNameLabel)
        
        categoryNameLabel.anchor(top: collectionView?.topAnchor, left: collectionView?.leftAnchor, botton: nil, right: collectionView?.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        categoryNameTextField.anchor(top: categoryNameLabel.bottomAnchor, left: collectionView?.leftAnchor, botton: nil, right: collectionView?.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        
//        collectionView?.layoutIfNeeded()
        
    }
    
    let gradientView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightYellow2
        view.isUserInteractionEnabled = false
        return view
    }()
    
    func setupCollectionView(){
        
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        view.addSubview(gradientView)
        gradientView.anchor(top: nil, left: collectionView?.leftAnchor, botton: collectionView?.bottomAnchor, right: collectionView?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        

   
        collectionView?.backgroundColor = .lightYellow2
        collectionView?.anchor(top: view.topAnchor, left: view.leftAnchor, botton: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 100, paddingRight: 0, width: 0, height: 0)
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        cell.button.setImage(#imageLiteral(resourceName: "task").withRenderingMode(.alwaysOriginal), for: .normal)
        cell.backgroundColor = .lightYellow
        return cell
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
        self.header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as? UICollectionViewCell
        
        
        
        header?.backgroundColor = .lightYellow2
        return header!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

