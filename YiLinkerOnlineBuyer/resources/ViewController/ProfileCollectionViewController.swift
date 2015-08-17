//
//  ProfileCollectionViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/15/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfileCollectionViewController: UICollectionViewController, ProfileHeaderCollectionViewCellDelegate {
    let reuseIdentifierGrid = "profileHistoryCollectionViewCell"
    let reuseIdentifierList = "profileHistoryListCollectionViewCell"
    let reuseIdentifierHeader = "profileHeaderCollectionViewCell"
    var isGrid = false
    
    var tableData: [String] = ["btn1", "btn2", "btn3", "btn4", "btn5", "btn6",]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeCollectionView () {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
            
        var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0.25
        layout.headerReferenceSize = CGSize(width: screenWidth, height: 310.0)
        
        if !isGrid {
            isGrid = true
            layout.itemSize = CGSize(width: ((screenWidth / 2) - 0.5), height: 185)
            
            self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
            self.collectionView?.backgroundColor = UIColor.whiteColor()
            self.collectionView?.bounces = true
            self.collectionView?.alwaysBounceVertical = true
            
            var cellNib = UINib(nibName: "ProfileHistoryCollectionViewCell", bundle: nil)
            self.collectionView?.registerNib(cellNib, forCellWithReuseIdentifier: reuseIdentifierGrid)
        } else {
            isGrid = false
            layout.itemSize = CGSize(width: screenWidth, height: 120)
            layout.minimumLineSpacing = 1.0
            self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
            self.collectionView?.backgroundColor = UIColor.whiteColor()
            self.collectionView?.bounces = true
            self.collectionView?.alwaysBounceVertical = true
            
            var cellNib = UINib(nibName: "ProfileHistoryListCollectionViewCell", bundle: nil)
            self.collectionView?.registerNib(cellNib, forCellWithReuseIdentifier: reuseIdentifierList)
        }
        
        var cellHeaderNib = UINib(nibName: "ProfileHeaderCollectionViewCell", bundle: nil)
        self.collectionView?.registerNib(cellHeaderNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifierHeader)
        
        self.collectionView?.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return tableData.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if isGrid {
            let cell: ProfileHistoryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierGrid, forIndexPath: indexPath) as! ProfileHistoryCollectionViewCell
            return cell
        } else {
            let cell: ProfileHistoryListCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierList, forIndexPath: indexPath) as! ProfileHistoryListCollectionViewCell
            return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            switch kind {
            case UICollectionElementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseIdentifierHeader, forIndexPath: indexPath) as! ProfileHeaderCollectionViewCell
                headerView.delegate = self
                if isGrid {
                    headerView.viewTypeButton.imageView?.image = UIImage(named: "list")
                } else {
                    headerView.viewTypeButton.imageView?.image = UIImage(named: "grid")
                }
                return headerView
            default:
                assert(false, "Unexpected element kind")
            }
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        var orderHistoryModal = ProfileOrderHistoryViewController(nibName: "ProfileOrderHistoryViewController", bundle: nil)
        orderHistoryModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        orderHistoryModal.providesPresentationContextTransitionStyle = true
        orderHistoryModal.definesPresentationContext = true
        self.tabBarController?.presentViewController(orderHistoryModal, animated: true, completion: nil)
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    
    // MARK: ProfileHeaderCollectionViewCellDelegate

    func editProfileButtonActionForIndex(sender: AnyObject) {
        var editProfileController = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        self.tabBarController?.presentViewController(editProfileController, animated: false, completion: nil)

    }
    
    func switchViewButtonActionForIndex(sender: AnyObject) {
        initializeCollectionView()
    }
    
}
