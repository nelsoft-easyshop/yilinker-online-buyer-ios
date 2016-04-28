//
//  ViewController.swift
//  FloatingActionButton
//
//  Created by Alvin John Tandoc on 1/20/16.
//  Copyright (c) 2016 YiAyOS. All rights reserved.
//

/*
    *** Object
    
        Collection View = Is the main layout of fab, we use custom collection view layout to add the cell vertical animation effect.

        FABCollectionViewLayout = Is the custom layout of our collection view

        TextAndIconModel = Is a model for get/set text and icons.

        dimView = Is the View behind the collection view. This is use to help us achieve the blur effect

    *** Variables

        layout = A Instance of FABCollectionViewLayout

        textAndIcons = array of TextAndIconModel

        numberOfCell = A variable for getting the number of cells to be displayed in the collection view. To set the value of numberOfCell, get the textAndIcons count

        delegate = A variable for storing the protocol

    *** Protocol

        fabViewController(viewController: FABViewController, didSelectIndex index: Int)  = to know the clicked index

        fabCollectionViewCellDidTapCell(fabCollectionViewCell: UICollectionViewCell)
        fABProfileCollectionViewCellDidTap(fABProfileCollectionViewCell: FABProfileCollectionViewCell)

    *** Functions

    Life Cycle func
        viewDidLoad()
        viewDidAppear(animated: Bool)
        func didReceiveMemoryWarning()

    Collection View func
        numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
        collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell

    Custom func
        animateCollectionView() = Func to animate collection view with bounce. Since animating the cell with bounce is complicated. This is the alternative way.
        
        registerCellWithNibName(nibName: String) = Func for registering the collection view cells like in table view.
        
        addtextAndIconsWithLeftText(leftText: String, rightText: String, icon: String, isProfile: Bool) = Func for appending data to textAndIcons. Since textAndIcons is private this is the only way to append data.
        
        addCells() = Func for adding collection view cells and showing the text and icon to the FAB.
        
        deleteCells(sender: UIButton) = Func for deleting collection view cells and showing the text and icon to the FAB
        
        stringSizeOfLabel(label: UILabel) -> CGFloat = Func for getting the text width size.
        
        initDimView() = Func for initializing default values of dim view.
        
        blurView(myView: UIView) = Func for add blur view effect to dim view.
        
        fabCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> FABCollectionViewCell = Func for setting up the fab collection view cell, instead of initializing cell value to cellAtIndexPath
            func of collection view, I create this func for better code readability

        fabProfileCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> FABProfileCollectionViewCell = Func for setting up the fab profile collection view cell, instead of initializing cell value to cellAtIndexPath
            func of collection view, I create this func for better code readability

    Action
        tap(sender: UIButton) = Everytime the buttons are clicked, this func is being triggered.

    Flow
        Accessor need's to initialize controller
        Accessor need's to add text and icons
        Accessor need's to present this controller with transparent view and OverCurrentContext modal style
        
        Self will animate the dim view
        Self will add the cells
        Self will setup the values of the cell, values are from accessors added text and icons
        
        If user tap an icon, self.protocl will be triggered and dim view will animate to alpha 0 and dismmis the view.
*/



import UIKit

protocol FABViewControllerDelegate {
    func fabViewController(viewController: FABViewController, didSelectIndex index: Int)
}

class TextAndIconModel: NSObject {
    
    var leftTitle: String = ""
    var rightTitle: String = ""
    var icon: String = ""
    var isProfile: Bool = false
    
    init(leftTitle: String, rightTitle: String, icon: String, isProfile: Bool) {
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
        self.icon = icon
        self.isProfile = isProfile
    }
}

class FABViewController: UIViewController, FABCollectionViewCellDelegate, FABProfileCollectionViewCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let fabCollectionViewCellIdentifier = "FABCollectionViewCell"
    let fabProfileCollectionViewCellIdentifier = "FABProfileCollectionViewCell"
    
    var numberOfCell: Int = 0
    
    var layout: FABCollectionViewLayout = FABCollectionViewLayout()
    
    private var textAndIcons: [TextAndIconModel] = []
    
    @IBOutlet weak var dimView: UIView!
    
    var delegate: FABViewControllerDelegate?
    
    var oldPushNotifData: String = ""
    
    //MARK: - 
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onNewMessage:",
            name: appDelegate.messageKey, object: nil)
        
        self.registerCellWithNibName(self.fabCollectionViewCellIdentifier)
        self.registerCellWithNibName(self.fabProfileCollectionViewCellIdentifier)
        self.initDimView()
        self.collectionView.reloadData()
        
        self.numberOfCell = 0
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.backgroundView = UIView()
    }

    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.dimView.alpha = 1.0
        })
        
        Delay.delayWithDuration(0.1, completionHandler: { (success) -> Void in
            self.layout = FABCollectionViewLayout()
            self.layout.textAndIcons = self.textAndIcons
            self.collectionView.collectionViewLayout = self.layout
            self.addCells()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -
    //MARK: - Animate Collection View
    //To simulate bounce effect of first version
    func animateCollectionView() {
        let width: CGFloat = self.collectionView.frame.size.width
        let height: CGFloat = self.collectionView.frame.size.height
        let originX: CGFloat = self.collectionView.frame.origin.x
        let originY: CGFloat = self.collectionView.frame.origin.y
        
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.TransitionNone, animations: ({
            self.collectionView.frame = CGRectMake(originX, originY - 10, width, height)
        }), completion: nil)
    }

    //MARK: -
    //MARK: - Register Cell
    func registerCellWithNibName(nibName: String) {
        let nib: UINib = UINib(nibName: nibName, bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: nibName)
    }
    
    //MARK: - 
    //MARK: - Add Text And Icons
    func addtextAndIconsWithLeftText(leftText: String, rightText: String, icon: String, isProfile: Bool, profileImage: UIImage = UIImage()) {
        let textAndIcon: TextAndIconModel = TextAndIconModel(leftTitle: leftText, rightTitle: rightText, icon: icon, isProfile: isProfile)
        self.textAndIcons.append(textAndIcon)
    }
    
    //MARK: -
    //MARK: - Collection View Data Source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfCell
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if !self.textAndIcons[indexPath.row].isProfile {
            return self.fabCollectionViewCellWithIndexPath(indexPath)
        } else {
            return self.fabProfileCollectionViewCellWithIndexPath(indexPath)
        }
    }
    
    //MARK: - 
    //MARK: - Add Cells
    func addCells() {
        self.animateCollectionView()
        var indexPaths: [NSIndexPath] = []
        for i in 0..<self.textAndIcons.count {
            let indexPath: NSIndexPath = NSIndexPath(forItem: self.numberOfCell, inSection: 0)
            self.numberOfCell++
            indexPaths.append(indexPath)
        }
        
        self.collectionView.insertItemsAtIndexPaths(indexPaths)
    }
    
    //MARK: -
    //MARK: - Delete Cells
    func deleteCells(sender: UIButton) {
        var indexPaths: [NSIndexPath] = []
        for i in 0..<self.numberOfCell {
            let indexPath: NSIndexPath = NSIndexPath(forItem: i, inSection: 0)
            self.numberOfCell--
            indexPaths.append(indexPath)
        }
        
        self.collectionView.performBatchUpdates({ () -> Void in
            self.collectionView.deleteItemsAtIndexPaths(indexPaths)
            }, completion: { (Bool) -> Void in
                self.layout.invalidateLayout()
        })
        
        UIView.animateWithDuration(0.5, animations: {
            self.dimView.alpha = 0.0
            }, completion: { finished in
                self.dismissViewControllerAnimated(false, completion: nil)
        })
    }
    
    //MARK: -
    //MARK: - Tap
    @IBAction func tap(sender: UIButton) {
        self.deleteCells(sender)
    }
    
    //MARK: -
    //MARK: - String Size Of Label
    func stringSizeOfLabel(label: UILabel) -> CGFloat {
        return label.intrinsicContentSize().width
    }
    
    //MARK: - 
    //MARK: - Fab Collection View Cell Did Tap Cell
    func fabCollectionViewCellDidTapCell(fabCollectionViewCell: UICollectionViewCell) {
        let indexPath: NSIndexPath = self.collectionView.indexPathForCell(fabCollectionViewCell)!
        self.deleteCells(UIButton())
        self.delegate!.fabViewController(self, didSelectIndex: indexPath.row - 1)
    }
    
    //MARK: -
    //MARK: - Fab Profile Collection View Cell Did Tap Cell
    func fABProfileCollectionViewCellDidTap(fABProfileCollectionViewCell: FABProfileCollectionViewCell) {
        let indexPath: NSIndexPath = self.collectionView.indexPathForCell(fABProfileCollectionViewCell)!
        self.deleteCells(UIButton())
        self.delegate!.fabViewController(self, didSelectIndex: indexPath.row - 1)
    }
    
    //MARK: - 
    //MARK: - Init Dim View
    private func initDimView() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.dimView.alpha = 0.0
        dimView.userInteractionEnabled = true
        dimView.backgroundColor = UIColor.clearColor()
        
        self.blurView(self.dimView)
    }
    
    //MARK: - 
    //MARK: - Blur View
    func blurView(myView: UIView) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRectMake(0, 0, screenSize.width + 50, screenSize.height + 50)
        myView.addSubview(blurEffectView)
    }
    
    //MARK: -
    //MARK: - FAB Collection View Cell With IndexPath
    func fabCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> FABCollectionViewCell {
        let leftLabelPadding: CGFloat = 20.0
        let rightLabelPadding: CGFloat = 10.0
        var insetSpace: CGFloat = 10
        
        let fabCollectionViewCell: FABCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.fabCollectionViewCellIdentifier, forIndexPath: indexPath) as! FABCollectionViewCell
        
        fabCollectionViewCell.delegate = self
        fabCollectionViewCell.leftLabel.text = self.textAndIcons[indexPath.row].leftTitle
        let width: CGFloat = self.stringSizeOfLabel(fabCollectionViewCell.leftLabel)
        fabCollectionViewCell.leftLabelWidth.constant = width + rightLabelPadding
        
        fabCollectionViewCell.iconButton.setImage(UIImage(named: self.textAndIcons[indexPath.row].icon), forState: UIControlState.Normal)
        fabCollectionViewCell.iconButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        fabCollectionViewCell.iconButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        fabCollectionViewCell.iconButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        fabCollectionViewCell.iconButton.clipsToBounds = true
        
        if self.textAndIcons[indexPath.row].leftTitle == "" {
            fabCollectionViewCell.leftLabel.hidden = true
            fabCollectionViewCell.iconButton.backgroundColor = Constants.Colors.appTheme
            fabCollectionViewCell.iconButton.layer.borderColor = UIColor.clearColor().CGColor
            fabCollectionViewCell.iconButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        } else {
            fabCollectionViewCell.iconButton.backgroundColor = UIColor.clearColor()
            fabCollectionViewCell.leftLabel.hidden = false
            fabCollectionViewCell.iconButton.layer.borderColor = UIColor.whiteColor().CGColor
            fabCollectionViewCell.iconButton.imageEdgeInsets = UIEdgeInsetsMake(insetSpace, insetSpace, insetSpace, insetSpace)
        }
        
        if self.textAndIcons[indexPath.row].rightTitle == "0 unread message(s)" || self.textAndIcons[indexPath.row].rightTitle == "" {
            fabCollectionViewCell.rightLabel.hidden = true
        } else {
            fabCollectionViewCell.rightLabel.hidden = false
            fabCollectionViewCell.rightLabel.text = self.textAndIcons[indexPath.row].rightTitle
            let width2: CGFloat = self.stringSizeOfLabel(fabCollectionViewCell.rightLabel)
            fabCollectionViewCell.rightLabelWidth.constant = width2 + rightLabelPadding
        }
        
        return fabCollectionViewCell
    }
    
    //MARK: - 
    //MARK: - FAB Profile Collection View Cell With IndexPath
    func fabProfileCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> FABProfileCollectionViewCell {
        let leftLabelPadding: CGFloat = 20.0
        let fabProfileCollectionViewCell: FABProfileCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.fabProfileCollectionViewCellIdentifier, forIndexPath: indexPath) as! FABProfileCollectionViewCell
        
        fabProfileCollectionViewCell.profileImageView.transform = CGAffineTransformIdentity
        fabProfileCollectionViewCell.profileNameLabel.text = self.textAndIcons[indexPath.row].rightTitle
        
        fabProfileCollectionViewCell.leftLabel.text = self.textAndIcons[indexPath.row].leftTitle
        let width: CGFloat = self.stringSizeOfLabel(fabProfileCollectionViewCell.leftLabel)
        fabProfileCollectionViewCell.leftLabelWidth.constant = width + leftLabelPadding
        fabProfileCollectionViewCell.delegate = self
        
        let profileImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, fabProfileCollectionViewCell.profileImageView.frame.size.width, fabProfileCollectionViewCell.profileImageView.frame.size.height))
        fabProfileCollectionViewCell.profileImageView.addSubview(profileImageView)
        fabProfileCollectionViewCell.profileImageView.clipsToBounds = true
        profileImageView.sd_setImageWithURL(NSURL(string: self.textAndIcons[indexPath.row].icon), placeholderImage: UIImage(named: "dummy-placeholder"))
        profileImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        UIView.animateWithDuration(1.5, delay: 0.1, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            fabProfileCollectionViewCell.profileImageView.transform = CGAffineTransformMakeScale(1.5, 1.5)
        }), completion: nil)
        
        return fabProfileCollectionViewCell
    }
    
    //MARK: -
    //MARK: - On New Message
    func onNewMessage(notification : NSNotification){
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding){
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        if self.oldPushNotifData != data {
                            var count = SessionManager.getUnReadMessagesCount() + 1
                            SessionManager.setUnReadMessagesCount(count)
                            if count != 0 {
                                self.textAndIcons[1].rightTitle = "\(SessionManager.getUnReadMessagesCount()) unread meassage(s)"
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
                self.oldPushNotifData = data
            }
        }
    }
}
