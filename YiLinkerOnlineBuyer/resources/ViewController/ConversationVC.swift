//
//  MessagesVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/2/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

struct LocalizedStrings{
    static let title = StringHelper.localizedStringWithKey("MESSAGING_TITLE")
    static let errorMessage = StringHelper.localizedStringWithKey("MESSAGING_SOMETHING_WENT_WRONG")
    static let errorTitle = StringHelper.localizedStringWithKey("MESSAGING_ERROR_TITLE")
    static let titleNewMessage = StringHelper.localizedStringWithKey("MESSAGING_NEW")
    static let online = StringHelper.localizedStringWithKey("MESSAGING_ONLINE")
    static let offline = StringHelper.localizedStringWithKey("MESSAGING_OFFLINE")
    
    
    static let send = StringHelper.localizedStringWithKey("MESSAGING_SEND")
    static let camera = StringHelper.localizedStringWithKey("MESSAGING_CAMERA")
    static let cameraRoll = StringHelper.localizedStringWithKey("MESSAGING_CAMERA_ROLL")
    static let connectionUnreachableTitle = StringHelper.localizedStringWithKey("CONNECTION_UNREACHABLE_LOCALIZE_KEY")
    static let connectionUnreachableMessage = StringHelper.localizedStringWithKey("PLEASE_CHECK_INTERNET_LOCALIZE_KEY")
    static let pickImageFirst = StringHelper.localizedStringWithKey("MESSAGING_PICK_IMAGE_ERROR")
    static let ok = StringHelper.localizedStringWithKey("OKBUTTON_LOCALIZE_KEY")
    static let saveFailed = StringHelper.localizedStringWithKey("MESSAGING_SAVE_FAILED")
    static let saveFailedMessage = StringHelper.localizedStringWithKey("MESSAGING_SAVE_FAILED_MESSAGE")
    static let typeYourMessage = StringHelper.localizedStringWithKey("MESSAGING_TYPE_YOUR_MESSAGE")
    
    static let seen = StringHelper.localizedStringWithKey("MESSAGING_SEEN")
    static let photoMessage = StringHelper.localizedStringWithKey("MESSAGING_PHOTO_MESSAGE")
    static let newMessage = StringHelper.localizedStringWithKey("MESSAGING_NEW_MESSAGE")
}

class ConversationVC: UIViewController, EmptyViewDelegate{
    
    @IBOutlet weak var conversationTableView: UITableView!
    var conversations = [W_Conversation]()
    var filteredConversations = [W_Conversation]()
    
    let profileImageSquareDimension = 40
    
    var searchActive : Bool = false
    
    let cellIdentifier = "MessageCell"
    
    var offlineColor = UIColor(red: 218/255, green: 32/255, blue: 43/255, alpha: 1.0)
    var onlineColor = UIColor(red: 84/255, green: 182/255, blue: 167/255, alpha: 1.0)
    
    var selectedContact : W_Contact?
    let messageThreadSegueIdentifier = "message_thread"
    
    var emptyView : EmptyView?
    var contentViewFrame: CGRect?
    var hud: MBProgressHUD?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == messageThreadSegueIdentifier){
            var messageThreadVC = segue.destinationViewController as! MessageThreadVC
            let indexPath = conversationTableView.indexPathForCell(sender as! ConversationTVC)
            selectedContact = conversations[indexPath!.row].contact
            
            var isOnline = "-1"
            if (SessionManager.isLoggedIn()){
                isOnline = "1"
            } else {
                isOnline = "0"
            }
            
            println("IMAGE URL \(SessionManager.profileImageStringUrl())")
            //messageThreadVC.sender = W_Contact(fullName: SessionManager.userFullName() , userRegistrationIds: "", userIdleRegistrationIds: "", userId: SessionManager.accessToken(), profileImageUrl: SessionManager.profileImageStringUrl(), isOnline: isOnline)
            messageThreadVC.sender = W_Contact(fullName: SessionManager.userFullName() , userRegistrationIds: "", userIdleRegistrationIds: "", userId: SessionManager.accessToken(), profileImageUrl: SessionManager.profileImageStringUrl(), isOnline: isOnline)
            messageThreadVC.recipient = selectedContact
        }
    }
    
    override func viewDidLoad() {
        println(" access token \(SessionManager.accessToken())")
        var test = W_Conversation()
        //conversations = test.testData()
        //self.placeCustomBackImage()
        
        conversationTableView.tableFooterView = UIView(frame: CGRectZero)
        
        super.viewDidLoad()
        
        var locX = UIScreen.mainScreen().bounds.size.width * 0.75
        var locY = UIScreen.mainScreen().bounds.size.height * 0.70
        
        let createMessageButton = UIButton()
        createMessageButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        createMessageButton.frame = CGRectMake(locX, locY, 55, 55)
        createMessageButton.addTarget(self, action: "createMessage:", forControlEvents: .TouchUpInside)
        createMessageButton.setImage(UIImage(named: "edit2"), forState: UIControlState.Normal)
        createMessageButton.imageEdgeInsets = UIEdgeInsetsMake(13, 13, 13, 13)
        
        createMessageButton.layer.cornerRadius = createMessageButton.frame.width/2
        createMessageButton.backgroundColor = UIColor(red: 117.0/255.0, green: 52.0/255.0, blue: 138.0/255.0, alpha: 1.0)
        createMessageButton.layer.shadowColor = UIColor.blackColor().CGColor
        createMessageButton.layer.shadowRadius = 100.0
        createMessageButton.layer.shadowOpacity = 0.9
        createMessageButton.layer.shadowOffset = CGSizeMake(1, 1)
        
        createMessageButton.layer.masksToBounds = true
        
        
        self.view.addSubview(createMessageButton)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 117.0/255.0, green: 52.0/255.0, blue: 138.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.contentViewFrame = self.view.frame
        
        self.navigationItem.title = LocalizedStrings.title
        
    }
    
    func onStatusUpdate(notification: NSNotification){
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding){
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        if let userId = json["userId"] as? Int{
                            for (index,convo) in enumerate(conversations){
                                if (convo.contact.userId == String(userId)) {
                                    if let status = json["isOnline"] as? Bool{
                                        if (!status){
                                            convo.contact.isOnline = "0"
                                        } else {
                                            convo.contact.isOnline = "1"
                                        }
                                        self.conversationTableView.reloadData()
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func receivedMessage(notification : NSNotification){
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding){
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        if let userId = json["senderUid"] as? Int{
                            for (index,convo) in enumerate(conversations){
                                if (convo.contact.userId == String(userId)) {
                                    if let newMessage = json["message"] as? String {
                                        convo.lastMessage = newMessage
                                        convo.hasUnreadMessage = "1"
                                    }
                                    self.conversationTableView.reloadData()
                                    break
                                }
                            }
                        }
                        
                        if let receipientId = json["recipientUid"] as? Int{
                            for (index,convo) in enumerate(conversations){
                                if (convo.contact.userId == String(receipientId)) {
                                    if let newMessage = json["message"] as? String {
                                        convo.lastMessage = newMessage
                                        convo.hasUnreadMessage = "1"
                                    }
                                    self.conversationTableView.reloadData()
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.fireLogin()
        self.getConversationsFromEndpoint("1", limit: "10")
        SessionManager.setUnReadMessagesCount(0)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onStatusUpdate:",
            name: appDelegate.statusKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedMessage:",
            name: appDelegate.messageKey, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: appDelegate.statusKey, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: appDelegate.messageKey, object: nil)
    }
    
    func addEmptyView() {
        println(self.emptyView)
        if self.emptyView == nil {
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView?.frame = self.contentViewFrame!
            self.emptyView!.delegate = self
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
        }
    }
    
    func didTapReload() {
        self.getConversationsFromEndpoint("1", limit: "30")
        self.emptyView?.hidden = true
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
        //self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createMessage(sender: UIButton!){
        self.performSegueWithIdentifier("show_contacts", sender: self)
    }
    
    func fireCreateRegistration(registrationID : String) {
        
        self.showHUD()
        
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = [
            "registrationId": "\(registrationID)",
            "access_token"  : SessionManager.accessToken()
            ]   as Dictionary<String, String>
        
        let url = APIAtlas.baseUrl + APIAtlas.ACTION_GCM_CREATE
        
        manager.POST(url, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            //SVProgressHUD.dismiss()
            self.hud?.hide(true)
            //self.showSuccessMessage()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    if (SessionManager.isLoggedIn()){
                        self.fireRefreshToken()
                    }
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: LocalizedStrings.errorMessage, title: LocalizedStrings.errorTitle)
                }
                
                //SVProgressHUD.dismiss()
                self.hud?.hide(true)
                self.addEmptyView()
        })
    }
    
    func fireLogin() {
        
        if(Reachability.isConnectedToNetwork()){
            
            self.showHUD()
            
            let manager: APIManager = APIManager.sharedInstance
            //seller@easyshop.ph
            //password
            let parameters: NSDictionary = ["email": "buyer@easyshop.ph","password": "password", "client_id": Constants.Credentials.clientID, "client_secret": Constants.Credentials.clientSecret, "grant_type": Constants.Credentials.grantBuyer]
            
            manager.POST(APIAtlas.loginUrl, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                //SVProgressHUD.dismiss()
                self.hud?.hide(true)
                //self.showSuccessMessage()
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        if (SessionManager.isLoggedIn()){
                            self.fireRefreshToken()
                        }
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: LocalizedStrings.errorMessage, title: LocalizedStrings.errorTitle)
                    }
                    
                    //SVProgressHUD.dismiss()
                    self.hud?.hide(true)
                    self.addEmptyView()
            })
        } else {
            self.addEmptyView()
        }
        
    }
    
    func getConversationsFromEndpoint(
        page : String,
        limit : String){
            
            self.showHUD()
            //SVProgressHUD.show()
            
            let manager: APIManager = APIManager.sharedInstance
            manager.requestSerializer = AFHTTPRequestSerializer()
            
            let parameters: NSDictionary = [
                "page"          : "\(page)",
                "limit"         : "\(limit)",
                "access_token"  : SessionManager.accessToken()
                ]   as Dictionary<String, String>
            
            /* uncomment + "a" to test retry sending */
            let url = APIAtlas.baseUrl + APIAtlas.ACTION_GET_CONVERSATION_HEAD //+ "a"
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.conversations = W_Conversation.parseConversations(responseObject as! NSDictionary)
                self.conversationTableView.reloadData()
                
                self.hud?.hide(true)
                //SVProgressHUD.dismiss()
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    
                    println("REACHABILITY \(Reachability.isConnectedToNetwork())")
                    if (Reachability.isConnectedToNetwork()){
                        let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                        
                        if task.statusCode == 401 {
                            if (SessionManager.isLoggedIn()){
                                self.fireRefreshToken()
                            }
                        } else {
                            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: LocalizedStrings.errorMessage, title: LocalizedStrings.errorTitle)
                        }
                        
                        self.conversations = Array<W_Conversation>()
                        self.conversationTableView.reloadData()
                        
                        self.hud?.hide(true)
                        //SVProgressHUD.dismiss()
                        
                        self.addEmptyView()
                        
                    } else {
                        self.addEmptyView()
                    }
            })
            
    }
    
    func fireRefreshToken() {
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = ["client_id": Constants.Credentials.clientID, "client_secret": Constants.Credentials.clientSecret, "grant_type": Constants.Credentials.grantRefreshToken, "refresh_token":  SessionManager.refreshToken()]
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: LocalizedStrings.errorMessage, title: LocalizedStrings.errorTitle)
        })
        
    }
    
}

extension ConversationVC : UITableViewDataSource{
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(searchActive){
            let convoCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath : indexPath) as! ConversationTVC
            
            convoCell.user_name.text = filteredConversations[indexPath.row].contact.fullName as String
            
            if (filteredConversations[indexPath.row].isImage == "1"){
                convoCell.user_message.text = LocalizedStrings.photoMessage
            } else {
                convoCell.user_message.text = filteredConversations[indexPath.row].lastMessage as String
            }
            convoCell.user_message.text = filteredConversations[indexPath.row].lastMessage as String
            convoCell.user_dt.text = DateUtility.convertDateToString(filteredConversations[indexPath.row].lastMessageDt) as String
            //convoCell.user_thumbnail.image = filteredConversations[indexPath.row].contact.profileImageUrl
            convoCell.user_thumbnail.layer.cornerRadius = convoCell.user_thumbnail.frame.width/2
            convoCell.user_thumbnail.layer.masksToBounds = true
            
            
            return convoCell
        } else {
            let convoCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath : indexPath) as! ConversationTVC
            
            convoCell.user_name.text = conversations[indexPath.row].contact.fullName as String
            if (conversations[indexPath.row].isImage == "1"){
                convoCell.user_message.text = LocalizedStrings.photoMessage
            } else {
                convoCell.user_message.text = conversations[indexPath.row].lastMessage as String
            }
            
            if (conversations[indexPath.row].hasUnreadMessage == "0"){
                convoCell.user_message.font = UIFont.systemFontOfSize(13.0)
            } else {
                convoCell.user_message.font = UIFont.boldSystemFontOfSize(13.0)
            }
            
            convoCell.user_dt.text = DateUtility.convertDateToString(conversations[indexPath.row].lastMessageDt) as String
            //convoCell.user_thumbnail.image = conversations[indexPath.row].contact.profileImageUrl
            let url = NSURL(string: conversations[indexPath.row].contact.profileImageUrl)
            convoCell.user_thumbnail.sd_setImageWithURL(url, placeholderImage: UIImage(named : "Male-50.png"))
            convoCell.user_thumbnail.layer.cornerRadius = convoCell.user_thumbnail.frame.width/2
            convoCell.user_thumbnail.layer.masksToBounds = true
            
            convoCell.user_online.layer.borderWidth = 1.0
            convoCell.user_online.layer.borderColor = UIColor.whiteColor().CGColor
            convoCell.user_online.layer.masksToBounds = true
            if (conversations[indexPath.row].contact.isOnline == "1"){
                convoCell.user_online.backgroundColor = onlineColor
            } else {
                convoCell.user_online.backgroundColor = offlineColor
            }
            
            return convoCell
        }
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
}
