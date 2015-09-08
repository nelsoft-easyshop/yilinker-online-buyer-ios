//
//  MessageThreadVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/3/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit
import AVFoundation

class MessageThreadVC: UIViewController {
    
    let captureSession = AVCaptureSession()
    
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var threadTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var threadTableView: UITableView!
    
    @IBOutlet weak var composeViewBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var composeView: UIView!
    @IBOutlet weak var composeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var composeTextView: TextViewAutoHeight!
    @IBOutlet weak var composeTVConstraint: NSLayoutConstraint!
    
    let composeViewHeight : CGFloat = 50.0
    
    var sender : W_Contact?
    var recipient : W_Contact?
    
    var screenWidth : CGFloat?
    var screenHeight: CGFloat?
    var tabBarHeight: CGFloat = 49.0
    
    var profileImageView: UIImageView!
    var onlineView: RoundedView!
    var profileNameLabel: UILabel!
    var onlineLabel: UILabel!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    var imagePlaced : Bool = false
    var prevIsSame : Bool = false
    var keyboardIsShown : Bool = false
    var minimumYComposeView : CGFloat = 0.0
    var maximumXComposeTextView : CGFloat = 0.0
    var messages = [W_Messages()]
    
    var onlineColor = UIColor(red: 84/255, green: 182/255, blue: 167/255, alpha: 1.0)
    
    let receiverIdentifier = "MessageBubbleReceiver"
    let senderIdentifier = "MessageBubbleSender"
    
    let receiverImageIndentifier = "MessageBubbleImageReceiver"
    let senderImageIndentifier = "MessageBubbleImageSender"
    
    let uploadImageSegueIdentifier = "upload_image"
    
    var hud: MBProgressHUD?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == uploadImageSegueIdentifier){
            println("PREPARE FOR SEGUE IMAGE")
            var imageVC = segue.destinationViewController as! ImageVC
            
            imageVC.sender = self.sender
            imageVC.recipient = self.recipient
            imageVC.imageVCDelegate = self
            
        }
    }
    
    override func viewDidLoad() {
        println("viewDidLoad")
        super.viewDidLoad()
        var ref = W_Messages()
        //messages = ref.testData()
        var r_temp = recipient?.userId ?? ""
        self.getMessagesFromEndpoint("1", limit: "30", userId: r_temp)
        //self.setConversationAsReadFromEndpoint(r_temp)
        configureTableView()
        
        minimumYComposeView = composeView.frame.origin.y
        maximumXComposeTextView = composeTextView.contentSize.height * 3
        
        screenWidth = UIScreen.mainScreen().bounds.size.width
        screenHeight = UIScreen.mainScreen().bounds.size.height
        
        
        var tableFrame : CGRect = self.threadTableView.frame
        tableFrame = CGRectMake(0.0, 0.0, screenWidth!, screenHeight! - composeViewHeight)
        self.threadTableView.frame = tableFrame
        self.threadTableViewConstraint.constant = tableFrame.height
        
        
        self.threadTableView.layoutIfNeeded()
        self.threadTableView.layoutMarginsDidChange()
        
        
        var composeFrame : CGRect = self.composeView.frame
        composeFrame = CGRectMake(0.0, tableFrame.height, screenWidth!, composeViewHeight)
        self.composeView.frame = composeFrame
        self.composeViewHeightConstraint.constant = composeViewHeight
        self.composeViewBottomLayout.constant = 0
        
        self.composeView.layoutIfNeeded()
        self.composeView.layoutMarginsDidChange()
        
        self.composeTextView.maxHeight = 60.0
        self.composeTextView.heightConstraint = self.composeTVConstraint
        self.composeTextView.containerConstraint = self.composeViewHeightConstraint
        self.composeTextView.tableContentInset = self.threadTableView.contentInset
        
        var tap = UITapGestureRecognizer (target: self, action: Selector("tableTapped:"))
        self.threadTableView.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        println("viewDidAppear")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasHidden:"), name: UIKeyboardWillHideNotification, object: nil)
        
        self.placeCustomBackImage()
        self.placeRightNavigationControllerDetails()
        
        self.composeTextView.becomeFirstResponder()
    }
    
    func tableTapped(tap : UITapGestureRecognizer){
        var location = tap.locationInView(self.threadTableView)
        self.composeTextView.resignFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        println("viewWillDisappear")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        //self.findAndResignFirstResponder()
        println("viewDidDisappear")
        
    }
    
    func placeRightNavigationControllerDetails(){
        var navBarHeight = self.navigationController?.navigationBar.frame.height
        var navBarWidth = UIScreen.mainScreen().bounds.size.width
        var profileImageDimension : CGFloat = 40.0
        var rightPadding : CGFloat = 10.0
        var rightPadding2 : CGFloat = 4.0
        var rightPadding3 : CGFloat = 4.0
        
        onlineLabel = UILabel()
        onlineLabel.text = "Online"
        onlineLabel.font = UIFont(name: onlineLabel.font.fontName, size: 11.0)
        onlineLabel.textColor = UIColor.whiteColor()
        onlineLabel.sizeToFit()
        
        var onlineLabelFrame = CGRectMake(navBarWidth-profileImageDimension - rightPadding - onlineLabel.frame.width - rightPadding2, 6, onlineLabel.frame.width, onlineLabel.frame.height)
        
        onlineLabel.frame = onlineLabelFrame
        
        profileNameLabel = UILabel()
        profileNameLabel.text = recipient?.fullName
        profileNameLabel.font = UIFont(name: profileNameLabel.font.fontName, size: 15.0)
        profileNameLabel.textColor = UIColor.whiteColor()
        profileNameLabel.sizeToFit()
        
        var profileNameFrame = CGRectMake(navBarWidth-profileImageDimension - rightPadding - profileNameLabel.frame.width - rightPadding2, getMidpoint(navBarHeight!) - 2, profileNameLabel.frame.width, profileNameLabel.frame.height)
        
        profileNameLabel.frame = profileNameFrame
        
        profileImageView = UIImageView(frame: CGRectMake(navBarWidth-profileImageDimension - rightPadding, 0,profileImageDimension, profileImageDimension))
        ///profileImageView.image = UIImage(named: sender?.profileImageUrl)
        var temp = recipient!.profileImageUrl ?? ""
        let url = NSURL(string: temp)
        profileImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Male-50.png"))
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.masksToBounds = true
        
        onlineView = RoundedView(frame: CGRectMake(navBarWidth-profileImageDimension - rightPadding - onlineLabel.frame.width - rightPadding2 - 10 - rightPadding3, 8, 10, 10))
        onlineView.backgroundColor = onlineColor
        
        onlineView.layer.cornerRadius = onlineView.frame.height/2
        onlineView.layer.masksToBounds = true
        
        self.navigationController?.navigationBar.addSubview(profileImageView)
        self.navigationController?.navigationBar.addSubview(profileNameLabel)
        self.navigationController?.navigationBar.addSubview(onlineLabel)
        self.navigationController?.navigationBar.addSubview(onlineView)
        
    }
    
    func getMidpoint(temp : CGFloat) -> CGFloat{
        return temp/2
    }
    
    func placeCustomBackImage(){
        var backImage = UIImage(named: "left.png")
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 12.0, height: 24.0), false, 0.0)
        backImage?.drawInRect(CGRectMake(0, 0, 12, 24))
        
        var tempImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var backItem = UIBarButtonItem(image: tempImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goBack"))
        
        self.navigationItem.setLeftBarButtonItem(backItem, animated: true)
    }
    
    @IBAction func onCamera(sender: UIButton) {
        self.clearProfileView()
    }
    
    func goBack(){
        self.clearProfileView()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func clearProfileView(){
        profileImageView.removeFromSuperview()
        onlineView.removeFromSuperview()
        profileNameLabel.removeFromSuperview()
        onlineLabel.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureTableView(){
        threadTableView.rowHeight = UITableViewAutomaticDimension
        threadTableView.estimatedRowHeight = 160.0
    }
    
    func keyboardWasHidden (notification: NSNotification){
        if (keyboardIsShown){
            keyboardIsShown = false
            var info = notification.userInfo!
            var keyBoardEndFrame : CGRect = (info [UIKeyboardFrameEndUserInfoKey])!.CGRectValue()
            
            var keyFrame : CGRect = (info [UIKeyboardFrameEndUserInfoKey])!.CGRectValue()
            
            var newFrame : CGRect = self.composeView.frame
            newFrame.origin.y += keyFrame.size.height
            
            var newTableFrame : CGRect = self.threadTableView.frame
            
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                //self.threadTableView.setContentOffset(UIEdgeInsetsZero, animated: true)
                self.threadTableView.contentInset = UIEdgeInsetsMake(60, 0, self.tabBarHeight, 0)
                
                self.composeView.frame = newFrame
                self.composeViewBottomLayout.constant -= (keyFrame.size.height - self.tabBarHeight)
                
                /*
                self.threadTableView.frame = CGRectMake(0, 0, newTableFrame.height + keyFrame.size.height, newTableFrame.width)
                self.threadTableViewConstraint.constant = newTableFrame.height + keyFrame.size.height
                */
                self.goToBottomTableView()
                }, completion: nil)
            
        }
    }
    
    func keyboardWasShown(notification: NSNotification) {
        if (!keyboardIsShown){
            keyboardIsShown = true
            var info = notification.userInfo!
            var keyBoardEndFrame : CGRect = (info [UIKeyboardFrameEndUserInfoKey])!.CGRectValue()
            
            var keyFrame : CGRect = (info [UIKeyboardFrameEndUserInfoKey])!.CGRectValue()
            
            var newFrame : CGRect = self.composeView.frame
            var newTableFrame : CGRect = self.threadTableView.frame
            
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.composeView.frame = CGRectMake(newFrame.origin.x, newFrame.origin.y - keyFrame.size.height, newFrame.width, newFrame.height)
                self.composeViewBottomLayout.constant += (keyFrame.size.height - self.tabBarHeight)
                self.threadTableView.contentInset = UIEdgeInsetsMake(60, 0, keyFrame.size.height, 0)
                /*self.threadTableView.frame = CGRectMake(0, 0, newTableFrame.height - keyFrame.size.height, newTableFrame.width)
                self.threadTableViewConstraint.constant = newTableFrame.height - keyFrame.size.height
                self.view.setNeedsLayout()
                self.view.setNeedsUpdateConstraints()
                */
                self.goToBottomTableView()
                
                
                }, completion: nil)
        }
    }
    
    @IBAction func onSend(senderButton: UIButton) {
        var lastMessage = composeTextView.text
        self.createMessage(lastMessage, isImage: "0")
    }
    
    func createMessage(lastMessage: String, isImage : String){
        var dateSeen : NSDate? = nil
        
        var recipientId = recipient?.userId ?? ""
        var senderId = self.sender?.userId ?? ""
        
        self.messages.append(W_Messages(message_id: 0, senderId: senderId, recipientId: recipientId, message: lastMessage, isImage: 0, timeSent: NSDate(), isSeen: 0, timeSeen: dateSeen, isSent : 0))
        
        self.threadTableView.reloadData()
        self.goToBottomTableView()
        self.sendMessageToEndpoint(lastMessage, recipientId: recipientId, isImage: isImage)
    }
    
    func sendMessageToEndpoint(lastMessage : String, recipientId : String, isImage : String){
        let manager: APIManager = APIManager.sharedInstance
        manager.requestSerializer = AFHTTPRequestSerializer()
        
        
        let parameters: NSDictionary = [
            "message"       : "\(lastMessage)",
            "recipientId"  : "\(recipientId)",
            "is_image"      : "\(isImage)",
            "access_token"  : SessionManager.accessToken()
            ]   as Dictionary<String, String>
        
        
        /* uncomment + "a" to test retry sending */
        let url = APIAtlas.baseUrl + APIAtlas.ACTION_SEND_MESSAGE //+ "a"
        
        manager.POST(url, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.messages[self.messages.count-1].isSent = 1
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken()
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                }
                
                self.messages[self.messages.count-1].isSent = 0
                println(error.description)
                
        })
        self.composeTextView.text = ""
        self.threadTableView.reloadData()
    }
    
    func getMessagesFromEndpoint(
        page : String,
        limit : String,
        userId: String){
            //SVProgressHUD.show()
            self.showHUD()
            
            let manager: APIManager = APIManager.sharedInstance
            manager.requestSerializer = AFHTTPRequestSerializer()
            
            let parameters: NSDictionary = [
                "page"          : "\(page)",
                "limit"         : "\(limit)",
                "userId"        : "\(userId)", //get user id from somewhere
                "access_token"  : SessionManager.accessToken()
                ]   as Dictionary<String, String>
            
            let url = APIAtlas.baseUrl + APIAtlas.ACTION_GET_CONVERSATION_MESSAGES
            
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.messages = W_Messages.parseMessages(responseObject as! NSDictionary)
                self.threadTableView.reloadData()
                
                self.hud?.hide(true)
                //SVProgressHUD.dismiss()
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.fireRefreshToken()
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                    }
                    
                    self.messages = Array<W_Messages>()
                    self.threadTableView.reloadData()
                    
                    self.hud?.hide(true)
                    //SVProgressHUD.dismiss()
            })
            
            self.goToBottomTableView()
    }
    
    //Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    func fireRefreshToken() {
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = ["client_id": Constants.Credentials.clientID, "client_secret": Constants.Credentials.clientSecret, "grant_type": Constants.Credentials.grantRefreshToken, "refresh_token":  SessionManager.refreshToken()]
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SVProgressHUD.dismiss()
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
        })
        
    }
    
    func setConversationAsReadFromEndpoint(userId : String){
        
        let manager: APIManager = APIManager.sharedInstance
        manager.requestSerializer = AFHTTPRequestSerializer()
        
        let parameters: NSDictionary = [
            "userId"        : "\(userId)", //get user id from somewhere
            "access_token"  : SessionManager.accessToken()
            ]   as Dictionary<String, String>
        
        let url = APIAtlas.baseUrl + APIAtlas.ACTION_SET_AS_READ
        
        manager.POST(url, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
        })

    }
    
}

extension MessageThreadVC : UITextViewDelegate{
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "Enter Your Message"
            textView.textColor = UIColor.lightGrayColor()
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGrayColor() {
                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            }
        }
    }
}

extension MessageThreadVC : UITableViewDataSource, UITableViewDelegate{
    
    func resendButtonTapped(sender: UIButton, event : UIEvent!){
        var touches : NSSet = event.allTouches()!
        var touch : UITouch = touches.anyObject() as! UITouch
        
        var currentTouchPosition : CGPoint = touch.locationInView(self.threadTableView)
        var indexPath : NSIndexPath = self.threadTableView.indexPathForRowAtPoint(currentTouchPosition)!
        if (!indexPath.isEqual(nil)) {
            if (messages[indexPath.row].isImage == 0) {
                let cell = self.threadTableView.cellForRowAtIndexPath(indexPath) as! MessageThreadTVC
                self.sendMessageToEndpoint(cell.message_label.text!, recipientId: messages[indexPath.row].recipientId, isImage: "0")
            }
        }
    }
    
    func goToBottomTableView(){
        if(threadTableView.numberOfRowsInSection(0) > 0) {
            var lastIndexPath : NSIndexPath = getLastIndexPath(threadTableView)
            threadTableView.scrollToRowAtIndexPath(lastIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
        }
    }
    
    func getLastIndexPath(param : UITableView) -> NSIndexPath{
        var lastSectionIndex : NSInteger = max(0, param.numberOfSections() - 1)
        var lastRowIndex : NSInteger = max(0, param.numberOfRowsInSection(lastSectionIndex) - 1)
        
        return NSIndexPath(forRow: lastRowIndex, inSection: lastSectionIndex)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row != 0) {
            if (messages[indexPath.row].senderId == messages[indexPath.row-1].senderId){
                prevIsSame = true
            } else {
                prevIsSame = false
            }
        }
        
        if (!prevIsSame){
            imagePlaced = false
        } else {
            imagePlaced = true
        }
        
        var index : Int = indexPath.row
        //index = (messages.count - indexPath.row) - 1
        
        if (messages[index].isImage == 1){
            if (sender?.userId == messages[index].senderId){
                let cell = tableView.dequeueReusableCellWithIdentifier(senderImageIndentifier) as! MessageThreadImageTVC
                
                if(!imagePlaced){
                    
                    var temp = sender!.profileImageUrl ?? ""
                    let url = NSURL(string: temp)
                    cell.contact_image.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Male-50.png"))
                    imagePlaced = true
                }
                
                let url = NSURL(string: messages[index].message)
                cell.message_image.sd_setImageWithURL(url, placeholderImage: nil)
                
                cell.message_image.superview?.layer.cornerRadius = 5.0
                cell.message_image.superview?.layer.shadowRadius = 1.0
                cell.message_image.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_image.superview?.layer.shadowOpacity = 0.4
                cell.message_image.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                
                if (messages[index].isSent == 1) {
                    cell.timestamp_label.text = DateUtility.convertDateToString(NSDate()) as String
                    cell.resendButton.hidden = true
                    cell.timestamp_label.hidden = false
                    cell.timestamp_image.hidden = false
                } else {
                    cell.resendButton.hidden = false
                    cell.timestamp_label.hidden = true
                    cell.timestamp_image.hidden = true
                }
                cell.resendButton.addTarget(self, action: Selector("resendButtonTapped:event:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                if (messages[index].isSeen == 0) {
                    cell.setSeenOff("sender")
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(receiverImageIndentifier) as! MessageThreadImageTVC
                
                if(!imagePlaced){
                    
                    var temp = recipient!.profileImageUrl ?? ""
                    let url = NSURL(string: temp)
                    cell.contact_image.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Male-50.png"))
                    imagePlaced = true
                }
                cell.timestamp_label.text = DateUtility.convertDateToString(NSDate()) as String
                
                let url = NSURL(string: messages[index].message)
                cell.message_image.sd_setImageWithURL(url, placeholderImage: nil)
                
                cell.message_image.superview?.layer.cornerRadius = 5.0
                cell.message_image.superview?.layer.shadowRadius = 1.0
                cell.message_image.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_image.superview?.layer.shadowOpacity = 0.4
                cell.message_image.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                
                if (messages[index].isSeen == 0) {
                    cell.setSeenOff("sender")
                }
                return cell
            }
        } else {
            if (sender?.userId == messages[index].senderId){
                let cell = tableView.dequeueReusableCellWithIdentifier(senderIdentifier) as! MessageThreadTVC
                
                cell.message_label.text = messages[index].message as String
                
                if(!imagePlaced){
                    
                    var temp = sender!.profileImageUrl ?? ""
                    let url = NSURL(string: temp)
                    cell.contact_image.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Male-50.png"))
                    imagePlaced = true
                }
                
                cell.message_label.superview?.layer.cornerRadius = 5.0
                
                cell.message_label.superview?.layer.shadowRadius = 1.0
                cell.message_label.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_label.superview?.layer.shadowOpacity = 0.4
                cell.message_label.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                
                if (messages[index].isSent == 1) {
                    cell.timestamp_label.text = DateUtility.convertDateToString(NSDate()) as String
                    cell.resendButton.hidden = true
                    cell.timestamp_label.hidden = false
                    cell.timestamp_image.hidden = false
                } else {
                    cell.resendButton.hidden = false
                    cell.timestamp_label.hidden = true
                    cell.timestamp_image.hidden = true
                    
                }
                cell.resendButton.addTarget(self, action: Selector("resendButtonTapped:event:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                if (messages[index].isSeen == 0) {
                    cell.setSeenOff("sender")
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(receiverIdentifier) as! MessageThreadTVC
                
                cell.message_label.text = messages[index].message as String
                if(!imagePlaced){
                    var temp = recipient?.profileImageUrl ?? ""
                    let url = NSURL(string: temp)
                    cell.contact_image.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Male-50.png"))
                }
                
                cell.timestamp_label.text = DateUtility.convertDateToString(NSDate()) as String
                
                cell.message_label.superview?.layer.cornerRadius = 5.0
                
                cell.message_label.superview?.layer.shadowRadius = 1.0
                cell.message_label.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_label.superview?.layer.shadowOpacity = 0.4
                cell.message_label.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                
                if (messages[index].isSeen == 0) {
                    cell.setSeenOff("receiver")
                }
                return cell
            }
            
        }
        
    }
    
}

extension MessageThreadVC : ImageVCDelegate{
    
    func sendMessage(url : String){
        self.createMessage(url, isImage: "1")
    }
}
