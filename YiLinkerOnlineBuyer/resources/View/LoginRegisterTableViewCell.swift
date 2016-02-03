//
//  LoginRegisterTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 2/1/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class LoginRegisterTableViewCell: UITableViewCell {
    
    

    //Cell Identifier
    let reuseIdentifierLogin: String = "SimplifiedLoginUICollectionViewCell"
    let reuseIdentifierRegistration: String = "SimplifiedRegistrationUICollectionViewCell"
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var screenWidth: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initializeViews()
        self.registerNibs()
        self.activateButton(self.signInButton)
        self.deActivateButton(self.registerButton)
    }

    func initializeViews() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.screenWidth = screenSize.width
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func registerNibs() {
        var cellNibLogin = UINib(nibName: reuseIdentifierLogin, bundle: nil)
        self.collectionView?.registerNib(cellNibLogin, forCellWithReuseIdentifier: reuseIdentifierLogin)
        
        var cellNibRegistration = UINib(nibName: reuseIdentifierRegistration, bundle: nil)
        self.collectionView?.registerNib(cellNibRegistration, forCellWithReuseIdentifier: reuseIdentifierRegistration)
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == self.signInButton {
            self.activateButton(self.signInButton)
            self.deActivateButton(self.registerButton)
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        } else if sender as! UIButton == self.registerButton {
            self.deActivateButton(self.signInButton)
            self.activateButton(self.registerButton)
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        }
    }
    //MARK: -
    //MARK: - Activate Button
    func activateButton(button: UIButton) {
        button.layer.cornerRadius = 20
        button.backgroundColor = Constants.Colors.appTheme
        button.layer.borderColor = Constants.Colors.appTheme.CGColor
        button.layer.borderWidth = 1
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    //MARK: -
    //MARK: - De Activate Button
    func deActivateButton(button: UIButton) {
        button.layer.cornerRadius = 20
        button.backgroundColor = .clearColor()
        button.layer.borderColor = Constants.Colors.appTheme.CGColor
        button.layer.borderWidth = 1
        button.setTitleColor(Constants.Colors.appTheme, forState: UIControlState.Normal)
    }
}

//MARK: - Data source and Delegate
//MARK: -  UICollectionViewDataSource and UICollectionViewDelegate
extension LoginRegisterTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell: SimplifiedLoginUICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierLogin, forIndexPath: indexPath) as! SimplifiedLoginUICollectionViewCell
            return cell
        } else {
            let cell: SimplifiedRegistrationUICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierRegistration, forIndexPath: indexPath) as! SimplifiedRegistrationUICollectionViewCell
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: self.screenWidth, height:342)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x < screenWidth {
            self.activateButton(self.signInButton)
            self.deActivateButton(self.registerButton)
        } else {
            self.deActivateButton(self.signInButton)
            self.activateButton(self.registerButton)
        }
    }
}
