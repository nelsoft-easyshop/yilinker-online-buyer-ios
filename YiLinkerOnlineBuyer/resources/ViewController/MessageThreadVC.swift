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
    
    @IBOutlet weak var threadTableView: UITableView!
    
    @IBOutlet weak var composeView: UIView!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var composeTVConstraint: NSLayoutConstraint!
    
    var sender : W_Contact?
    var recipient : W_Contact?
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println(sender)
        if (segue.identifier == uploadImageSegueIdentifier){
            println("PREPARE FOR SEGUE CONTACT")
            var imageVC = segue.destinationViewController as! ImageVC

            imageVC.sender = self.sender
            imageVC.recipient = self.recipient
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ref = W_Messages()
        //messages = ref.testData()
        var temp = recipient?.userId ?? ""
        self.getMessagesFromEndpoint("1", limit: "30", userId: temp)
        configureTableView()
        

        self.placeCustomBackImage()
        self.placeRightNavigationControllerDetails()
        
        //composeTextView.becomeFirstResponder()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name:UIKeyboardDidShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasHidden:"), name:UIKeyboardDidHideNotification, object: nil);
        
        minimumYComposeView = composeView.frame.origin.y
        maximumXComposeTextView = composeTextView.contentSize.height * 3
        
        //composeTextView.sizeToFit()
        //composeTextView.layoutIfNeeded()
        
        
        var tap = UITapGestureRecognizer (target: self, action: Selector("tableTapped:"))
        self.threadTableView.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.goToBottomTableView()
    }
    
    func tableTapped(tap : UITapGestureRecognizer){
        var location = tap.locationInView(self.threadTableView)
        println(location)
        self.composeTextView.resignFirstResponder()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
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
        profileImageView.sd_setImageWithURL(url)
        if (profileImageView.image == nil){
            profileImageView.image = UIImage(named: "Male-50.png")
        }
        
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
            
            var newFrameTV : CGRect = self.composeView.frame
            var keyboardFrameEndTV : CGRect = self.composeView.convertRect(keyBoardEndFrame, toView: nil)
            
            var newFrame : CGRect = self.threadTableView.frame
            var keyboardFrameEnd : CGRect = self.threadTableView.convertRect(keyBoardEndFrame, toView: nil)
            
            UIView.animateWithDuration(0.7, delay: 0.5, options: .CurveEaseOut , animations: {
                println(keyBoardEndFrame)
                println("BEGIN = \(keyboardFrameEnd.height)")
                //newFrame = CGSize(width: newFrame.width, height: newFrame.height + keyboardFrameEnd.height)
                var newHeight = newFrame.height + keyboardFrameEnd.height
                newFrame = CGRectMake(0, 0, newFrame.width, newHeight)
                self.threadTableView.frame = newFrame
                
                newFrameTV.origin.y += keyboardFrameEndTV.height
                self.composeView.frame = newFrameTV
                
                }, completion: { finished in
                    println("keyboardWasShown")
                }
            )
            
        }
    }
    
    func keyboardWasShown(notification: NSNotification) {
        if (!keyboardIsShown){
            keyboardIsShown = true
            var info = notification.userInfo!
            var keyBoardEndFrame : CGRect = (info [UIKeyboardFrameEndUserInfoKey])!.CGRectValue()
            
            var newFrameTV : CGRect = self.composeView.frame
            var keyboardFrameEndTV : CGRect = self.composeView.convertRect(keyBoardEndFrame, toView: nil)
            var newFrame : CGRect = self.threadTableView.frame
            var keyboardFrameEnd : CGRect = self.threadTableView.convertRect(keyBoardEndFrame, toView: nil)
            
            UIView.animateWithDuration(0.7, delay: 0.5, options: .CurveEaseOut , animations: {
                    println(keyBoardEndFrame)
                println("BEGIN = \(keyboardFrameEnd.height)")
                //newFrame = CGSize(width: newFrame.width, height: newFrame.height - keyboardFrameEnd.height)
                var newHeight = newFrame.height - keyboardFrameEnd.height
                newFrame = CGRectMake(0, 0, newFrame.width, newHeight)
                    self.threadTableView.frame = newFrame
                
                    newFrameTV.origin.y -= keyboardFrameEndTV.height
                    self.composeView.frame = newFrameTV
                
                }, completion: { finished in
                    println("keyboardWasShown")
                }
            )
           
        }
    }
    
    @IBAction func onSend(senderButton: UIButton) {
        SVProgressHUD.show()
        
        let manager: APIManager = APIManager.sharedInstance
        manager.requestSerializer = AFHTTPRequestSerializer()
        
        var recipientId = recipient?.userId ?? ""
        var lastMessage = composeTextView.text
        
        let parameters: NSDictionary = [
            "message"       : "\(lastMessage)",
            "recipientId"  : "\(recipientId)",
            "is_image"      : "0",
            "access_token"  : SessionManager.accessToken()
            ]   as Dictionary<String, String>
        
        println(parameters)
        
        let url = APIAtlas.baseUrl + APIAtlas.ACTION_SEND_MESSAGE
        
        manager.POST(url, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            var senderId = self.sender?.userId ?? ""
            var dateSeen : NSDate? = NSDate()
            
            self.messages.append(W_Messages(message_id: 0, senderId: senderId, recipientId: recipientId, message: lastMessage, isImage: 0, timeSent: NSDate(), isSeen: 0, timeSeen: dateSeen!))
            
            self.threadTableView.reloadData()
            
            self.composeTextView.text = ""
            
            println(responseObject)
            SVProgressHUD.dismiss()
            self.goToBottomTableView()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                println(error.description)
                
                SVProgressHUD.dismiss()
        })
        
    }
    
    func getMessagesFromEndpoint(
        page : String,
        limit : String,
        userId: String){
            SVProgressHUD.show()
            
            let manager: APIManager = APIManager.sharedInstance
            manager.requestSerializer = AFHTTPRequestSerializer()
            
            let parameters: NSDictionary = [
                "page"          : "\(page)",
                "limit"         : "\(limit)",
                "userId"        : "\(userId)", //get user id from somewhere
                "access_token"  : SessionManager.accessToken()
                ]   as Dictionary<String, String>
            
            let url = APIAtlas.baseUrl + APIAtlas.ACTION_GET_CONVERSATION_MESSAGES
            println(url)
            println(parameters)
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.messages = W_Messages.parseMessages(responseObject as! NSDictionary)
                self.threadTableView.reloadData()
                
                SVProgressHUD.dismiss()
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    println("ERROR \(error.description)")
                    if !Reachability.isConnectedToNetwork() {
                        UIAlertController.displayNoInternetConnectionError(self)
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                    }
                    self.messages = Array<W_Messages>()
                    self.threadTableView.reloadData()
                    
                    SVProgressHUD.dismiss()
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
    
    /*
    func textViewDidChange(textView: UITextView) {
        
        if (maximumXComposeTextView > textView.contentSize.height){
            //println("TV \(textView.contentSize.height) \(composeTVConstraint.constant) \(threadTableView.frame.size) \(textView.superview?.frame.origin)")
            
            let fixedWidth = textView.frame.size.width
            var deltaSize = textView.contentSize.height - composeTVConstraint.constant
        
            var newSize =   textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
            
            var newFrame = textView.frame
            newFrame.size = CGSize(width: fixedWidth, height: newSize.height)
            textView.frame = newFrame

            composeTVConstraint.constant = textView.contentSize.height
            
            if (deltaSize != 0) {
                /* UIView Resize */
                let fixedViewWidth = textView.superview?.frame.size.width
                var position = textView.superview?.frame.origin.y
                position = position! - deltaSize
        
                var currentSize = textView.superview?.frame.height
                currentSize = currentSize! + deltaSize
        
                var newViewFrame = textView.superview?.frame
                newViewFrame? = CGRectMake(0, position!, fixedViewWidth!, currentSize!)
                textView.superview?.frame = newViewFrame!
            
                var newTableFrame = threadTableView.frame
                newTableFrame = CGRectMake(0, 0, threadTableView.frame.size.width, threadTableView.frame.size.height-deltaSize)
                threadTableView.frame = newTableFrame
                threadTableView.setNeedsDisplay()
            
                //self.goToBottomTableView()
            }
        }
    }
    
    */

}

extension MessageThreadVC : UITableViewDataSource, UITableViewDelegate{
    
    
    func goToBottomTableView(){
        if(threadTableView.numberOfRowsInSection(0) > 0) {
            var lastIndexPath : NSIndexPath = getLastIndexPath(threadTableView)
            threadTableView.scrollToRowAtIndexPath(lastIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
    }
    
    func getLastIndexPath(param : UITableView) -> NSIndexPath{
        var lastSectionIndex : NSInteger = max(0, param.numberOfSections() - 1)
        var lastRowIndex : NSInteger = max(0, param.numberOfRowsInSection(lastSectionIndex) - 1)
        
        println("lastRowIndex \(lastRowIndex)")
        
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
        }
        
        if (messages[indexPath.row].isImage == 1){
            if (sender?.userId == messages[indexPath.row].senderId){
                let cell = tableView.dequeueReusableCellWithIdentifier(senderImageIndentifier) as! MessageThreadImageTVC
                
                if(!imagePlaced){
                    
                    var temp = recipient!.profileImageUrl ?? ""
                    let url = NSURL(string: temp)
                    cell.contact_image.sd_setImageWithURL(url)
                    if (cell.contact_image.image == nil){
                        cell.contact_image.image = UIImage(named: "Male-50.png")
                    }
                    imagePlaced = true
                }
                cell.timestamp_label.text = DateUtility.convertDateToString(NSDate()) as String
                
                let url = NSURL(string: messages[indexPath.row].message)
                cell.message_image.sd_setImageWithURL(url)
                if (cell.message_image.image == nil){
                    cell.message_image.image = UIImage()
                }
                
                cell.message_image.superview?.layer.cornerRadius = 5.0
                cell.message_image.superview?.layer.shadowRadius = 1.0
                cell.message_image.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_image.superview?.layer.shadowOpacity = 0.4
                cell.message_image.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(receiverImageIndentifier) as! MessageThreadImageTVC
                
                if(!imagePlaced){
                    
                    var temp = recipient!.profileImageUrl ?? ""
                    let url = NSURL(string: temp)
                    cell.contact_image.sd_setImageWithURL(url)
                    if (cell.contact_image.image == nil){
                        cell.contact_image.image = UIImage(named: "Male-50.png")
                    }
                    imagePlaced = true
                }
                cell.timestamp_label.text = DateUtility.convertDateToString(NSDate()) as String

                let url = NSURL(string: messages[indexPath.row].message)
                cell.message_image.sd_setImageWithURL(url)
                if (cell.message_image.image == nil){
                    cell.message_image.image = UIImage()
                }
                
                cell.message_image.superview?.layer.cornerRadius = 5.0
                cell.message_image.superview?.layer.shadowRadius = 1.0
                cell.message_image.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_image.superview?.layer.shadowOpacity = 0.4
                cell.message_image.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                
                return cell
            }
        } else {
            if (sender?.userId == messages[indexPath.row].senderId){
                let cell = tableView.dequeueReusableCellWithIdentifier(senderIdentifier) as! MessageThreadTVC
                
                cell.message_label.text = messages[indexPath.row].message as String
                
                if(!imagePlaced){
                    
                    var temp = recipient!.profileImageUrl ?? ""
                    let url = NSURL(string: temp)
                    cell.contact_image.sd_setImageWithURL(url)
                    if (cell.contact_image.image == nil){
                        cell.contact_image.image = UIImage(named: "Male-50.png")
                    }
                    imagePlaced = true
                }
                
                cell.timestamp_label.text = DateUtility.convertDateToString(NSDate()) as String
                
                cell.message_label.superview?.layer.cornerRadius = 5.0
                
                cell.message_label.superview?.layer.shadowRadius = 1.0
                cell.message_label.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_label.superview?.layer.shadowOpacity = 0.4
                cell.message_label.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                //println("Index: \(indexPath.row)  H:\(cell.message_label.frame.height) W:\(cell.message_label.frame.width)")
                //println("Index: \(indexPath.row) H:\(cell.message_label.superview?.frame.height) W:\(cell.message_label.superview?.frame.width) LENGTH: \(count(cell.message_label.text!))")
                
                if (messages[indexPath.row].isSeen == 0) {
                    cell.setSeenOff("sender")
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(receiverIdentifier) as! MessageThreadTVC
                
                cell.message_label.text = messages[indexPath.row].message as String
                if(!imagePlaced){
                    var temp = recipient?.profileImageUrl ?? ""
                    let url = NSURL(string: temp)
                    cell.contact_image.sd_setImageWithURL(url)
                    if (cell.contact_image.image == nil){
                        cell.contact_image.image = UIImage(named: "Male-50.png")
                    }
                }
                
                cell.timestamp_label.text = DateUtility.convertDateToString(NSDate()) as String
                
                cell.message_label.superview?.layer.cornerRadius = 5.0
                
                cell.message_label.superview?.layer.shadowRadius = 1.0
                cell.message_label.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_label.superview?.layer.shadowOpacity = 0.4
                cell.message_label.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                //println("Index: \(indexPath.row)  H:\(cell.message_label.frame.height) W:\(cell.message_label.frame.width)")
                //println("Index: \(indexPath.row) H:\(cell.message_label.superview?.frame.height) W:\(cell.message_label.superview?.frame.width) LENGTH \(count(cell.message_label.text!))")
                
                if (messages[indexPath.row].isSeen == 0) {
                    cell.setSeenOff("receiver")
                }
                return cell
            }
                
        }
        
    }

}
