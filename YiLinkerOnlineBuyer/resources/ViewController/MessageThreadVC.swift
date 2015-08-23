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
    
    let userId = 201
    let recipientId = 202
    
    var profile = W_Contact(full_name: "Patrick Tancioco", user_id: 69, profile_image_url: "Male-50.png")
    
    var profileImageView: UIImageView!
    var onlineImageView: UIImageView!
    var profileNameLabel: UILabel!
    var onlineLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    var imagePlaced : Bool = false
    var prevIsSame : Bool = false
    var keyboardIsShown : Bool = false
    var minimumYComposeView : CGFloat = 0.0
    var maximumXComposeTextView : CGFloat = 0.0
    var messages = [W_Messages()]

    let receiverIdentifier = "MessageBubbleReceiver"
    let senderIdentifier = "MessageBubbleSender"
    
    let receiverImageIndentifier = "MessageBubbleImageReceiver"
    let senderImageIndentifier = "MessageBubbleImageSender"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ref = W_Messages()
        messages = ref.testData()
        configureTableView()
        
        var rg : RequestGenerator = RequestGenerator()
        rg.getConversationMessagesEndpointAccess(self, page: "1", limit: "1", userId: "", accessToken: "")
        self.tableView.reloadData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasHidden:"), name:UIKeyboardWillHideNotification, object: nil);

        self.placeCustomBackImage()
        self.placeRightNavigationControllerDetails()
        
        composeTextView.becomeFirstResponder()
        
        minimumYComposeView = composeView.frame.origin.y
        maximumXComposeTextView = composeTextView.contentSize.height * 3
        
        //composeTextView.sizeToFit()
        //composeTextView.layoutIfNeeded()
        
        self.goToBottomTableView()
        
        
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
        profileNameLabel.text = profile.full_name
        profileNameLabel.font = UIFont(name: profileNameLabel.font.fontName, size: 15.0)
        profileNameLabel.textColor = UIColor.whiteColor()
        profileNameLabel.sizeToFit()
        
        var profileNameFrame = CGRectMake(navBarWidth-profileImageDimension - rightPadding - profileNameLabel.frame.width - rightPadding2, getMidpoint(navBarHeight!) - 2, profileNameLabel.frame.width, profileNameLabel.frame.height)
        
        profileNameLabel.frame = profileNameFrame
        
        profileImageView = UIImageView(frame: CGRectMake(navBarWidth-profileImageDimension - rightPadding, 0,profileImageDimension, profileImageDimension))
        profileImageView.image = UIImage(named: profile.profile_image_url)
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.masksToBounds = true
        
        onlineImageView = UIImageView(frame: CGRectMake(navBarWidth-profileImageDimension - rightPadding - onlineLabel.frame.width - rightPadding2 - 10 - rightPadding3, 8, 10, 10))
        onlineImageView.image = UIImage(named: "online.png")
        
        self.navigationController?.navigationBar.addSubview(profileImageView)
        self.navigationController?.navigationBar.addSubview(profileNameLabel)
        self.navigationController?.navigationBar.addSubview(onlineLabel)
        self.navigationController?.navigationBar.addSubview(onlineImageView)

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
    
    func goBack(){
        profileImageView.removeFromSuperview()
        onlineImageView.removeFromSuperview()
        profileNameLabel.removeFromSuperview()
        onlineLabel.removeFromSuperview()
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureTableView(){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
    }
    
    func keyboardWasHidden (notification: NSNotification){
        if (keyboardIsShown){
            keyboardIsShown = false
            var info = notification.userInfo!
            var keyBoardEndFrame : CGRect = (info [UIKeyboardFrameEndUserInfoKey])!.CGRectValue()
            var keyBoardBeginFrame : CGRect = (info [UIKeyboardFrameBeginUserInfoKey])!.CGRectValue()

            var newFrame : CGRect = self.composeView.frame
            var keyboardFrameEnd : CGRect = self.composeView.convertRect(keyBoardEndFrame, toView: nil)
            var keyboardFrameBegin : CGRect = self.composeView.convertRect(keyBoardBeginFrame, toView: nil)

            newFrame.origin.y += (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y)
            self.composeView.frame = newFrame
        
            println("keyboardWasHidden")
        }
    }
    
    func keyboardWasShown(notification: NSNotification) {
        if (!keyboardIsShown){
            keyboardIsShown = true
            var info = notification.userInfo!
            var keyBoardEndFrame : CGRect = (info [UIKeyboardFrameEndUserInfoKey])!.CGRectValue()
            var keyBoardBeginFrame : CGRect = (info [UIKeyboardFrameBeginUserInfoKey])!.CGRectValue()
        
        
        //var animationCurve : UIViewAnimationCurve = (info [UIKeyboardAnimationCurveUserInfoKey])!.integerValue
        //var animationDuration : NSTimeInterval = (info [UIKeyboardAnimationDurationUserInfoKey])?.integerValue

        //UIView.beginAnimations(nil, context: nil)
        //UIView.setAnimationDuration(animationDuration)
        //UIView.setAnimationCurve(animationCurve)
        
            var newFrame : CGRect = self.composeView.frame
            var keyboardFrameEnd : CGRect = self.composeView.convertRect(keyBoardEndFrame, toView: nil)
            var keyboardFrameBegin : CGRect = self.composeView.convertRect(keyBoardBeginFrame, toView: nil)
        
            newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y)
            self.composeView.frame = newFrame
        
            println("keyboardWasShown")
        }
    }
    
    @IBAction func onSend(sender: UIButton) {
        var rg : RequestGenerator = RequestGenerator()
        rg.sendMessageEndpointAccess(composeTextView.text, recipientId: String(recipientId), isImage: "0", accessToken: "TBA")
    }
    
}

extension MessageThreadVC : UITextViewDelegate{
    
    func textViewDidChange(textView: UITextView) {
        
        if (maximumXComposeTextView > textView.contentSize.height){
            println("TV \(textView.contentSize.height) \(composeTVConstraint.constant) \(threadTableView.frame.size) \(textView.superview?.frame.origin)")
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
            
                self.goToBottomTableView()
            }
        }
    }

}

extension MessageThreadVC : UITableViewDataSource{
    
    func goToBottomTableView(){
        
        var lastIndexPath : NSIndexPath = getLastIndexPath(threadTableView)
        
        threadTableView.scrollToRowAtIndexPath(lastIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
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
            if (messages[indexPath.row].sender_id == messages[indexPath.row-1].sender_id){
                prevIsSame = true
            } else {
                prevIsSame = false
            }
        }
        
        if (!prevIsSame){
            imagePlaced = false
        }
        
        if (messages[indexPath.row].is_image == 1){
            if (userId == messages[indexPath.row].sender_id){
                let cell = tableView.dequeueReusableCellWithIdentifier(senderImageIndentifier) as! MessageThreadImageTVC
                
                if(!imagePlaced){
                    //cell.contact_image.image = UIImage(named: "Male-50.png")
                    
                    let url = NSURL(string: "http://placehold.it/350x150")
                    cell.contact_image.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Male-50.png"))
                    imagePlaced = true
                }
                cell.timestamp_label.text = DateUtility.convertDateToString(NSDate()) as String
                cell.message_image.image = UIImage(named: messages[indexPath.row].image_url)
                
                cell.message_image.superview?.layer.cornerRadius = 5.0
                cell.message_image.superview?.layer.shadowRadius = 1.0
                cell.message_image.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_image.superview?.layer.shadowOpacity = 0.4
                cell.message_image.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(receiverImageIndentifier) as! MessageThreadImageTVC
                
                if(!imagePlaced){
                    //cell.contact_image.image = UIImage(named: "Male-50.png")
                    
                    let url = NSURL(string: "http://placehold.it/350x150")
                    cell.contact_image.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Male-50.png"))
                    imagePlaced = true
                }
                cell.timestamp_label.text = DateUtility.convertDateToString(NSDate()) as String
                cell.message_image.image = UIImage(named: messages[indexPath.row].image_url)
                
                cell.message_image.superview?.layer.cornerRadius = 5.0
                cell.message_image.superview?.layer.shadowRadius = 1.0
                cell.message_image.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_image.superview?.layer.shadowOpacity = 0.4
                cell.message_image.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                
                return cell
            }
        } else {
            if (userId == messages[indexPath.row].sender_id){
                let cell = tableView.dequeueReusableCellWithIdentifier(senderIdentifier) as! MessageThreadTVC
                
                cell.message_label.text = messages[indexPath.row].message as String
                
                if(!imagePlaced){
                    cell.contact_image.image = UIImage(named: "Male-50.png")
                    
                    //let url = NSURL(string: "http://placehold.it/350x150")
                    //scell.contact_image.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Male-50.png"))
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
                
                if (messages[indexPath.row].is_opened == 0) {
                    cell.setSeenOff("sender")
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(receiverIdentifier) as! MessageThreadTVC
                
                cell.message_label.text = messages[indexPath.row].message as String
                if(!imagePlaced){
                    cell.contact_image.image = UIImage(named: "Male-50.png")
                    imagePlaced = true
                }
                
                cell.timestamp_label.text = DateUtility.convertDateToString(NSDate()) as String
                
                cell.message_label.superview?.layer.cornerRadius = 5.0
                
                cell.message_label.superview?.layer.shadowRadius = 1.0
                cell.message_label.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_label.superview?.layer.shadowOpacity = 0.4
                cell.message_label.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                //println("Index: \(indexPath.row)  H:\(cell.message_label.frame.height) W:\(cell.message_label.frame.width)")
                //println("Index: \(indexPath.row) H:\(cell.message_label.superview?.frame.height) W:\(cell.message_label.superview?.frame.width) LENGTH \(count(cell.message_label.text!))")
                
                if (messages[indexPath.row].is_opened == 0) {
                    cell.setSeenOff("receiver")
                }
                return cell
            }
                
        }
        
    }

}
