//
//  CircularMenuViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct CircularMenuString {
    static let notYetAvailableTitle: String = StringHelper.localizedStringWithKey("CUSTOMIZE_SHOPPING_ALERT_TITLE_LOCALIZE_KEY")
    static let notYetAvailableMessage: String = StringHelper.localizedStringWithKey("CUSTOMIZE_SHOPPING_ALERT_MESSAGE_LOCALIZE_KEY")
    
    static let cantProceedTitle: String = StringHelper.localizedStringWithKey("MESSAGE_LOGIN_ERROR_TITLE_LOCALIZE_KEY")
    static let cantProceedMessage: String = StringHelper.localizedStringWithKey("MESSAGE_LOGIN_ERROR_MESSAGE_LOCALIZE_KEY")
    
    static let helpMessage: String = StringHelper.localizedStringWithKey("HELP_ALERT_MESSAGE_LOCALIZE_KEY")
}


class CircularMenuViewController: UIViewController {
    
    @IBOutlet weak var roundedButton: RoundedButton!
    
    @IBOutlet weak var dimView: UIView!
    
    var profileImageIndex: Int = 5
    
    var buttonImages: [String] = []
    var buttonTitles: [String] = []
    var buttonRightText: [String] = []
    var customTabBarController: CustomTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDimView()
        self.view.bringSubviewToFront(self.roundedButton)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onNewMessage:",
            name: appDelegate.messageKey, object: nil)
        
        self.closeButton()
    }
    
    //MARK: - Close Button
    func closeButton() {
        var insetSpace: CGFloat = 15
        roundedButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        roundedButton.imageEdgeInsets = UIEdgeInsetsMake(insetSpace, insetSpace, insetSpace, insetSpace)
    }
    
    func onNewMessage(notification : NSNotification){
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding){
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        var count = SessionManager.getUnReadMessagesCount() + 1
                        SessionManager.setUnReadMessagesCount(count)
                    }
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        if self.view.subviews.count <= self.profileImageIndex {
            let xPosition: CGFloat = (self.view.frame.size.width / 2) - 25
            var yPosition: CGFloat = self.roundedButton.frame.origin.y - 70
            for (index, imageName) in enumerate(self.buttonImages) {
                let button: UIButton = UIButton(frame: CGRectMake(xPosition, self.view.frame.size.height + 100, 50, 50))
                button.backgroundColor = UIColor.clearColor()
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.whiteColor().CGColor
                button.layer.cornerRadius = button.frame.size.width / CGFloat(2)
                button.tag = index + 1
                
                if index == self.profileImageIndex && SessionManager.isLoggedIn() {
                    let profileImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, button.frame.size.width, button.frame.size.height))
                    button.addSubview(profileImageView)
                    button.clipsToBounds = true
                    println("image name: \(imageName)")
                    profileImageView.sd_setImageWithURL(NSURL(string: imageName), placeholderImage: UIImage(named: "dummy-placeholder"))
                    profileImageView.contentMode = UIViewContentMode.ScaleAspectFill
                    profileImageView.backgroundColor = UIColor.greenColor()
                }
                var insetSpace: CGFloat = 10
                button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
                button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
                button.imageEdgeInsets = UIEdgeInsetsMake(insetSpace, insetSpace, insetSpace, insetSpace)
                button.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
                button.clipsToBounds = true
                button.addTarget(self, action: "menuClick:", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(button)
                
                var stringSize: CGSize = self.buttonTitles[index].sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(12.0)])
                var fontSize: CGFloat = 10
                if IphoneType.isIphone5() {
                    stringSize = self.buttonTitles[index].sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(10.0)])
                    fontSize = 9
                } else if IphoneType.isIphone4() {
                    
                }
                
                var verticalMargin: CGFloat = 0.0
                var verticalMarginLabel: CGFloat = 0.0
                
                if IphoneType.isIphone4() {
                    verticalMargin = 5
                    verticalMarginLabel = 30
                } else if IphoneType.isIphone5() {
                    verticalMargin = 15
                    verticalMarginLabel = 30
                } else {
                    verticalMargin = 20
                    verticalMarginLabel = 15
                }
                
                var labelPosition: CGFloat = xPosition - (stringSize.width + 30)
                if index != self.profileImageIndex {
                    var width: CGFloat = stringSize.width + 20
                    if IphoneType.isIphone6() {
                        if stringSize.width > 137 {
                            width = width - 10
                            labelPosition = labelPosition + 10
                        }
                    } else if IphoneType.isIphone5() {
                        if stringSize.width > 115 {
                            width = width - 15
                            labelPosition = labelPosition + 15
                        }
                    } else if IphoneType.isIphone4() {
                        if index != 0 {
                            width = width - 40
                            labelPosition = labelPosition + 40
                        }
                     
                        fontSize = 8
                    }
                    //left label except logout
                    let label: UILabel = UILabel(frame: CGRectMake(labelPosition, yPosition + verticalMarginLabel, width, 20))
                    label.backgroundColor = UIColor.whiteColor()
                    label.text = self.buttonTitles[index]
                    label.adjustsFontSizeToFitWidth = true
                    label.textAlignment = NSTextAlignment.Center
                    label.layer.cornerRadius = 10
                    label.clipsToBounds = true
                    label.font = UIFont(name: label.font.fontName, size: fontSize)
                    label.tag = 100 + index
                    label.alpha = 0
                    self.view.addSubview(label)
                    
                    if self.buttonRightText[index] != "" && index != self.profileImageIndex {
                        
                        var labelWidth: CGFloat = 150
                        var fontSize: CGFloat = 10.0
                        if IphoneType.isIphone4() {
                            labelWidth = 120
                            fontSize = 8
                        } else if IphoneType.isIphone5() {
                            labelWidth = 120
                            fontSize = 8
                        }
                        
                        var horizontalSpaceToIcon: CGFloat = 0
                        
                        if SessionManager.isLoggedIn() {
                            horizontalSpaceToIcon = 60
                        } else {
                            horizontalSpaceToIcon = 30
                        }
                        
                        //right label except name and adress
                        let label: UILabel = UILabel(frame: CGRectMake(xPosition + horizontalSpaceToIcon, yPosition + verticalMarginLabel, labelWidth, 20))
                        label.text = self.buttonRightText[index]
                        label.adjustsFontSizeToFitWidth = true
                        label.textAlignment = NSTextAlignment.Center
                        label.layer.cornerRadius = 10
                        label.clipsToBounds = true
                        label.font = UIFont(name: label.font.fontName, size: fontSize)
                        label.textColor = UIColor.whiteColor()
                        label.tag = 100 + index
                        label.alpha = 0
                        
                        if SessionManager.isLoggedIn() && index == 1 {
                            label.backgroundColor = UIColor.redColor()
                            
                            if SessionManager.unreadMessageCount() == "" || SessionManager.unreadMessageCount() == "You have 0 unread messages" {
                                label.hidden = true
                            }
                            
                        } else {
                            label.backgroundColor = UIColor.clearColor()
                        }
                        
                        self.view.addSubview(label)

                    }
                    
                    yPosition = yPosition - button.frame.size.height - verticalMargin
                } else {
                    
                    var labelWidth: CGFloat = 100
                    var fontSize: CGFloat = 14.0
                    if IphoneType.isIphone4() {
                        labelWidth = 120
                        fontSize = 10
                    } else if IphoneType.isIphone5() {
                        labelWidth = 120
                        fontSize = 10
                    }
                    
                    //logout Button
                    if SessionManager.isLoggedIn() {
                        var logoutPosition: CGFloat = xPosition - 125
                        let logoutButton: UIButton = UIButton(frame: CGRectMake(logoutPosition, yPosition + 15, 100, 20))
                        logoutButton.backgroundColor = UIColor.whiteColor()
                        logoutButton.setTitle(self.buttonTitles[index], forState: UIControlState.Normal)
                        logoutButton.layer.cornerRadius = 10
                        logoutButton.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 10)
                        logoutButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                        logoutButton.clipsToBounds = true
                        logoutButton.tag = 100 + index
                        logoutButton.alpha = 0
                        self.view.addSubview(logoutButton)
                    } else {
                        
                        var width: CGFloat = stringSize.width + 20
                        if IphoneType.isIphone6() {
                            if stringSize.width > 137 {
                                width = width - 10
                                labelPosition = labelPosition + 10
                            }
                        } else if IphoneType.isIphone5() {
                            if stringSize.width > 115 {
                                width = width - 15
                                labelPosition = labelPosition + 15
                            }
                        } else if IphoneType.isIphone4() {
                            if index != 0 {
                                width = width - 40
                                labelPosition = labelPosition + 40
                            }
                            
                            fontSize = 8
                        }

                        
                        let label: UILabel = UILabel(frame: CGRectMake(labelPosition, yPosition + verticalMarginLabel, width, 20))
                        label.text = self.buttonTitles[index]
                        label.adjustsFontSizeToFitWidth = true
                        label.textAlignment = NSTextAlignment.Center
                        label.layer.cornerRadius = 10
                        label.clipsToBounds = true
                        label.font = UIFont(name: label.font.fontName, size: 10)
                        label.tag = 100 + index
                        label.alpha = 0
                        label.adjustsFontSizeToFitWidth = true
                        self.view.addSubview(label)
                    }
                   
                    
                    //name label and address
                    if  self.buttonRightText[index] != "" {
                        if IphoneType.isIphone4() {
                            
                        } else if IphoneType.isIphone5() {
                            yPosition = yPosition - 20
                        } else {
                            yPosition = yPosition - 30
                        }
                        
                        let label: UILabel = UILabel(frame: CGRectMake(xPosition + 75, yPosition, labelWidth, 100))
                        label.backgroundColor = UIColor.clearColor()
                        label.text = self.buttonRightText[index]
                        label.adjustsFontSizeToFitWidth = true
                        label.textAlignment = NSTextAlignment.Left
                        label.font = UIFont(name: label.font.fontName, size: fontSize)
                        label.textColor = UIColor.whiteColor()
                        label.tag = 100 + index
                        label.alpha = 0
                        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        label.numberOfLines = 0
                        self.view.addSubview(label)
                    }
                }
         
            }
            
            self.presentCirculardMenuAnimate()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeCircularMenuView(sender: AnyObject) {
        dissmissViewControllerAnimated()
    }
    
    private func presentCirculardMenuAnimate() {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            
            var yPosition: CGFloat = self.roundedButton.frame.origin.y - 70
            if IphoneType.isIphone4() {
                yPosition = self.roundedButton.frame.origin.y - 55
            } else if IphoneType.isIphone5() {
                yPosition = self.roundedButton.frame.origin.y - 55
            }
            
           
            let xPosition: CGFloat = (self.view.frame.size.width / 2) - 25
            
            var verticalMargin: CGFloat = 0.0
            
            if IphoneType.isIphone4() {
                verticalMargin = 5
            } else if IphoneType.isIphone5() {
                verticalMargin = 15
            } else {
                verticalMargin = 20
            }
            
            for tempView in self.view.subviews {
                if tempView.tag != 0 && tempView.tag < 100 {
                    let buttonView: UIButton = tempView as! UIButton
                    //adjust the vertical margin of last button if the user is login
                    if SessionManager.isLoggedIn() {
                        if IphoneType.isIphone4() {
                            if tempView.tag == self.profileImageIndex + 1{
                                yPosition = yPosition - 20
                            }
                        } else {
                            if tempView.tag == self.profileImageIndex + 1 {
                                yPosition = yPosition - 15
                            }
                        }
                    }
                    
                    buttonView.frame = CGRectMake(xPosition, yPosition, 50, 50)
                    yPosition = yPosition - buttonView.frame.size.height - verticalMargin
                } else if tempView.tag > 99 {
                    let tempView: UIView = tempView as! UIView
                    tempView.alpha = 1
                }
            }
            self.dimView.alpha = 1.0
            //self.showTitles()
        }), completion: { (value: Bool) in
            if SessionManager.isLoggedIn() {
                self.animateProfileImage()
            }
            
        })
    }
    
    func animateProfileImage() {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            var yPosition: CGFloat = self.roundedButton.frame.origin.y - 70
            let xPosition: CGFloat = (self.view.frame.size.width / 2) - 25
            
            for tempView in self.view.subviews {
                if tempView.tag != 0 && tempView.tag < 99 {
                    let buttonView: UIButton = tempView as! UIButton
                    if tempView.tag == self.profileImageIndex + 1 {
                        buttonView.transform = CGAffineTransformMakeScale(1.6, 1.6)
                    }
                }
            }
            //self.showTitles()
        }), completion: nil)
    }
    
     func dissmissViewControllerAnimated() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            let xPosition: CGFloat = (self.view.frame.size.width / 2) - 25
            self.roundedButton.alpha = 0
            for tempView in self.view.subviews {
                if tempView.tag != 0 && tempView.tag < 99 {
                    let buttonView: UIButton = tempView as! UIButton
                    buttonView.frame = CGRectMake(xPosition, screenSize.size.height, 50, 50)
                    buttonView.transform = CGAffineTransformMakeScale(0.3, 0.3)
                    buttonView.alpha = 0
                } else if tempView.tag > 99 {
                    let tempView: UIView = tempView as! UIView
                    tempView.alpha = 0
                }
            }
            self.dimView.alpha = 0.0
        }), completion: {
            (value: Bool) in
            
              self.dismissViewControllerAnimated(false, completion: nil)
            
        })
    }
    
    private func initDimView() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.dimView.alpha = 0.0
        dimView.userInteractionEnabled = true
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dissmissViewControllerAnimated")
        dimView.addGestureRecognizer(tapGesture)
        dimView.backgroundColor = UIColor.clearColor()
        
        
        dimView.blurView()
    }

    @IBAction func logout(sender: AnyObject) {
        //logout function
    }
    
    @IBAction func menuClick(sender: UIButton) {
        let index: Int = sender.tag - 1
        
    
        self.customTabBarController?.isValidToSwitchToMenuTabBarItems = true
        if SessionManager.isLoggedIn() {

        } else {
            if index == 0 {
                
            }
        }
        
        self.customTabBarController?.selectedIndex = 2
        let navigationController: UINavigationController = self.customTabBarController!.viewControllers![2] as! UINavigationController
        navigationController.popToRootViewControllerAnimated(false)
        let hiddenViewController: HiddenViewController = navigationController.viewControllers[0] as! HiddenViewController
        hiddenViewController.selectViewControllerAtIndex(index)
        
        self.customTabBarController?.isValidToSwitchToMenuTabBarItems = false
        self.dissmissViewControllerAnimated()
    }
    
    //logout
    
    func logout() {
        SessionManager.logout()
        FBSDKLoginManager().logOut()
        GPPSignIn.sharedInstance().signOut()
        self.dissmissViewControllerAnimated()
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.changeRootToHomeView()
    }
    
}
