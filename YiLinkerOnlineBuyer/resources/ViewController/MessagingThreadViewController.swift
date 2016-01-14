//
//  MessagingThreadViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 1/12/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

enum MessagingThreadRequestType {
    case GetConversation
    case AttachImage
    case SendImage
}

class MessagingThreadViewController: UIViewController {
    
    var requestType = MessagingThreadRequestType.GetConversation
    
    let MESSAGE_SENDER_TABLEVIEW_CELL_IDENTIFIER: String = "MessagingSenderTableViewCell"
    let MESSAGE_RECEIVER_TABLEVIEW_CELL_IDENTIFIER: String = "MessagingReceiverTableViewCell"
    let MESSAGE_SENDER_IMAGE_TABLEVIEW_CELL_IDENTIFIER: String = "MessagingSenderImageTableViewCell"
    let MESSAGE_RECEIVER_IMAGE_TABLEVIEW_CELL_IDENTIFIER: String = "MessagingReceiverImageTableViewCell"
    
    var sender: MessagingContactModel!
    var receiver: MessagingContactModel!
    
    var hud: MBProgressHUD?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newMessageView: UIView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var newMessageBottomContraint: NSLayoutConstraint!
    
    //Receiver navbar details
    var profileImageView: UIImageView!
    var onlineView: RoundedView!
    var profileNameLabel: UILabel!
    var onlineLabel: UILabel!
    
    var keyboardIsShown : Bool = false
    var tabBarHeight: CGFloat = 49.0
    var viewOriginY: CGFloat = 0
    
    var messageTableData: [MessagingMessageModel] = []
    
    //Get conversation params
    let TEMP_MESSAGE_ID = "-1"
    let LIMIT: Int = 30
    var page: Int = 1
    var isEndReached: Bool = false
    
    var lastIndexOfSeen: Int = 0
    
    var showHud: Bool = true
    
    //Message Temporary holder for refreshing of token
    var imageUploadTemp: UIImage = UIImage(named: "dummy-placeholder")!
    var messageTemp: String = ""
    var isImageTemp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set sender details
        self.sender = MessagingContactModel(userId: SessionManager.userId(), slug: "", fullName: SessionManager.userFullName(), profileImageUrl: SessionManager.profileImageStringUrl(), profileThumbnailImageUrl: "", profileSmallImageUrl: "", profileMediumImageUrl: "", profileLargeImageUrl: "", isOnline: "1", hasUnreadMessage: "0")
        
        self.initializeViews()
        
        self.resetAndGetDataWithHud(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.viewOriginY = self.view.frame.origin.y
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if receiver != nil {
            self.addReceiverDetailsView()
        }
        
        //Register notification observer for keyboard status and behavior
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        //Register notification observer for GCM
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onStatusUpdate:",
            name: appDelegate.statusKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onSeenMessage:",
            name: appDelegate.seenMessageKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onReceiveNewMessage:",
            name: appDelegate.messageKey, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Unregister notification observer for keyboard status and behavior
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
        //Unregister notification observer for GCM
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        NSNotificationCenter.defaultCenter().removeObserver(self, name: appDelegate.seenMessageKey, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: appDelegate.messageKey, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: appDelegate.statusKey, object: nil)
        
        self.removeReceiverDetailsView()
    }
    
    //MARK: View Customizations
    
    // Function to initializes views attributes
    func initializeViews() {
        self.edgesForExtendedLayout = UIRectEdge.None
        
        // Remove tableView's attributes
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = Constants.Colors.backgroundGray
        self.tableView.estimatedRowHeight = 270
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Register tableview's cell
        var nibSender = UINib(nibName: MESSAGE_SENDER_TABLEVIEW_CELL_IDENTIFIER, bundle: nil)
        self.tableView.registerNib(nibSender, forCellReuseIdentifier: MESSAGE_SENDER_TABLEVIEW_CELL_IDENTIFIER)
        var nibReceiver = UINib(nibName: MESSAGE_RECEIVER_TABLEVIEW_CELL_IDENTIFIER, bundle: nil)
        self.tableView.registerNib(nibReceiver, forCellReuseIdentifier: MESSAGE_RECEIVER_TABLEVIEW_CELL_IDENTIFIER)
        var nibSenderImage = UINib(nibName: MESSAGE_SENDER_IMAGE_TABLEVIEW_CELL_IDENTIFIER, bundle: nil)
        self.tableView.registerNib(nibSenderImage, forCellReuseIdentifier: MESSAGE_SENDER_IMAGE_TABLEVIEW_CELL_IDENTIFIER)
        var nibReceiverImage = UINib(nibName: MESSAGE_RECEIVER_IMAGE_TABLEVIEW_CELL_IDENTIFIER, bundle: nil)
        self.tableView.registerNib(nibReceiverImage, forCellReuseIdentifier: MESSAGE_RECEIVER_IMAGE_TABLEVIEW_CELL_IDENTIFIER)
        
        self.addBackButton()
    }
    
    // Add back button to navigation bar
    func addBackButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    // Add receiver's details in navigation bar
    func addReceiverDetailsView(){
        var navBarHeight = self.navigationController?.navigationBar.frame.height
        var navBarWidth = UIScreen.mainScreen().bounds.size.width
        var profileImageDimension : CGFloat = 35.0
        var rightPadding : CGFloat = 10.0
        var rightPadding2 : CGFloat = 4.0
        var rightPadding3 : CGFloat = 4.0
        
        //Initialize online status label
        onlineLabel = UILabel()
        onlineLabel.font = UIFont(name: "Panton", size: 11.0)
        onlineLabel.textColor = UIColor.whiteColor()
        onlineLabel.sizeToFit()
        
        var onlineLabelFrame = CGRectMake(navBarWidth-profileImageDimension - rightPadding - 35 - rightPadding2, 6, 35, 15)
        
        onlineLabel.frame = onlineLabelFrame
        
        //Initialize receiver's name label
        profileNameLabel = UILabel()
        profileNameLabel.text = receiver?.fullName
        profileNameLabel.font = UIFont(name: "Panton-Bold", size: 15.0)
        profileNameLabel.textColor = UIColor.whiteColor()
        profileNameLabel.sizeToFit()
        
        var profileNameFrame = CGRectMake(navBarWidth-profileImageDimension - rightPadding - profileNameLabel.frame.width - rightPadding2, (navBarHeight! / 2) - 2, profileNameLabel.frame.width, profileNameLabel.frame.height)
        
        profileNameLabel.frame = profileNameFrame
        
        //Initialize receiver's imageview
        profileImageView = UIImageView(frame: CGRectMake(navBarWidth-profileImageDimension - rightPadding, 5,profileImageDimension, profileImageDimension))
        var temp = receiver!.profileImageUrl ?? ""
        let url = NSURL(string: temp)
        profileImageView.contentMode = UIViewContentMode.ScaleAspectFill
        profileImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Male-50.png"))
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.masksToBounds = true
        
        onlineView = RoundedView(frame: CGRectMake(navBarWidth-profileImageDimension - rightPadding - onlineLabel.frame.width - rightPadding2 - 10 - rightPadding3, 8, 10, 10))
        
        //Check if user is online
        if (receiver?.isOnline == "1"){
            onlineLabel.text = LocalizedStrings.online
            onlineView.backgroundColor = Constants.Colors.onlineColor
        } else {
            onlineLabel.text = LocalizedStrings.offline
            onlineView.backgroundColor = Constants.Colors.offlineColor
        }
        
        onlineView.layer.cornerRadius = onlineView.frame.height/2
        onlineView.layer.masksToBounds = true
        
        self.navigationController?.navigationBar.addSubview(profileImageView)
        self.navigationController?.navigationBar.addSubview(profileNameLabel)
        self.navigationController?.navigationBar.addSubview(onlineLabel)
        self.navigationController?.navigationBar.addSubview(onlineView)
        
    }
    
    // Remove receiver's details in navigation bar
    func removeReceiverDetailsView(){
        if (profileImageView != nil){
            profileImageView.removeFromSuperview()
        }
        if (onlineView != nil){
            onlineView.removeFromSuperview()
        }
        if (profileNameLabel != nil){
            profileNameLabel.removeFromSuperview()
        }
        if (onlineLabel != nil){
            onlineLabel.removeFromSuperview()
        }
    }
    
    //MARK: IBActions
    @IBAction func buttonAction(sender: AnyObject) {
        if sender as? UIButton == sendButton {
            /* Call API to send message and add the message to messageTableData to
            *  avoid  extra call for getting of conversation/messages*/
            self.messageTemp = self.messageTextField.text
            self.isImageTemp = false
            self.fireSendMessage(self.messageTextField.text, isImage: false)
            self.closeKeyboard()
            self.messageTableData.append(MessagingMessageModel(
                messageId: self.TEMP_MESSAGE_ID,
                senderId: SessionManager.userId(),
                recipientId: self.receiver.userId,
                senderProfileImageUrl: self.sender.profileImageUrl,
                senderProfileThumbnailImageUrl: "",
                senderProfileSmallImageUrl: "",
                senderProfileMediumImageUrl: "",
                senderProfileLargeImageUrl: "",
                message: self.messageTextField.text,
                isImage: "0",
                timeSent: NSDate().formatDateToString("yyyy-MM-dd HH:mm:ss"),
                isSeen: "0",
                timeSeen: NSDate().formatDateToString("yyyy-MM-dd HH:mm:ss"),
                isSenderOnline: self.receiver.isOnline,
                isSent: false,
                hasError: false,
                image: UIImage(named: "dummy-placeholder")!))
            self.tableView.reloadData()
            self.messageTextField.text = ""
            self.goToBottomTableView()
        } else if sender as? UIButton == addPhotoButton {
            self.openImageActionSheet()
        }
    }
    
    //MARK: API Requests
    /* Function to get conversation/message list
    * and process it to convert it to object */
    func fireGetConversationList() {
        if isEndReached {
            Toast.displayToastWithMessage(MessagingLocalizedStrings.noMoreMessages, duration: 1.5, view: self.view)
        } else {
            if self.showHud {
                self.showHUD()
            } else {
                 UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            }
            
            if let tempUserId: String = self.receiver?.userId {
                WebServiceManager.fireGetConversationThreadListWithUrl("\(APIAtlas.ACTION_GET_CONVERSATION_MESSAGES_V2)?access_token=\(SessionManager.accessToken())", page: "\(self.page)", limit: "\(self.LIMIT)", userId: tempUserId, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                    
                    self.hud?.hide(true)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    if successful {
                        if self.page == 1 {
                            self.messageTableData.removeAll(keepCapacity: false)
                        }
                        
                        /*Parsing of data and loop to data object to parse json
                        * and converts the json to objects */
                        let dictionary: NSDictionary = responseObject as! NSDictionary
                        if let tempArray = dictionary["data"] as? NSArray {
                            for item in tempArray {
                                if let tempItem = item as? NSDictionary {
                                    self.messageTableData.insert(MessagingMessageModel.parseDataFromDictionary(tempItem), atIndex: 0)
                                }
                            }
                            
                            self.tableView.reloadData()
                            if self.page == 1 {
                                self.goToBottomTableView()
                            }
                            
                            //Check if the pagination reaches end
                            if self.messageTableData.count % self.LIMIT != 0 || tempArray.count == 0 {
                                self.isEndReached = true
                            } else {
                                self.page++
                            }
                            
                            self.fireSetConversationAsRead()
                        }
                    } else {
                        if requestErrorType == .ResponseError {
                            //Error in api requirements
                            let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                            Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                        } else if requestErrorType == .AccessTokenExpired {
                            self.fireRefreshToken()
                        } else if requestErrorType == .PageNotFound {
                            //Page not found
                            Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                        } else if requestErrorType == .NoInternetConnection {
                            //No internet connection
                            Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                        } else if requestErrorType == .RequestTimeOut {
                            //Request timeout
                            Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                        } else if requestErrorType == .UnRecognizeError {
                            //Unhandled error
                            Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                        }
                    }
                    
                })
            } else {
                Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
            }
        }
    }
    
    /* Function to send message.
    *  When API request is successful, the values of sent message of messageTableData
    *  are updated to values from the server. */
    func fireSendMessage(message: String, isImage: Bool) {
        var URL: String = ""
        
        self.setSendButtonEnabled(false)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
        URL = "\(APIAtlas.ACTION_SEND_MESSAGE_V2)?access_token=\(SessionManager.accessToken())"
        
        WebServiceManager.fireSendMessageWithUrl(URL, isImage: isImage, recipientId: self.receiver.userId, message: message, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.setSendButtonEnabled(true)
            if successful {
                /*Parsing of data to update the values sent message of messageTableData
                * to values from the server. */
                let dictionary: NSDictionary = responseObject as! NSDictionary
                if let tempDict = dictionary["data"] as? NSDictionary {
                    let indexLast: Int = self.lastIndexOfSenderMessage()
                    if let tempVar = tempDict["message"] as? String {
                        self.messageTableData[indexLast].message = tempVar
                    }
                    
                    if let tempVar = tempDict["dateSent"] as? String {
                        self.messageTableData[indexLast].timeSent = tempVar
                    }
                    self.messageTableData[indexLast].isSent = true
                    self.tableView.reloadData()
                }
            } else {
                //Set tableView's last cell to its's error view
                if self.lastIndexOfSenderMessage() != -1 {
                    self.messageTableData[self.lastIndexOfSenderMessage()].hasError = true
                    self.tableView.reloadData()
                }
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken()
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
            }
            
        })
    }
    
    // Function to set current message thread as read/seen
    func fireSetConversationAsRead() {
        var URL: String = "\(APIAtlas.ACTION_SET_AS_READ_V2)?access_token=\(SessionManager.accessToken())"
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        WebServiceManager.fireSetConversationAsReadWithUrl(URL, userId: self.receiver.userId, access_token: SessionManager.accessToken(), actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if successful {
                println(responseObject)
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken()
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
            }
            
        })
    }
    
    /* Function to attach message
    * It uploads the image to the server and parse the JSON to 
    * get the URL of the image and send it as message */
    func fireAttachImage(image: UIImage) {
        var URL: String = ""
        
        self.setSendButtonEnabled(false)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        URL = "\(APIAtlas.ACTION_IMAGE_ATTACH_V2)?access_token=\(SessionManager.accessToken())"
        WebServiceManager.fireAttachImageWithUrl(URL, image: image, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                //Parsing of data to get the URL and send it as a plain text message
                let dictionary: NSDictionary = responseObject as! NSDictionary
                if let tempDict = dictionary["data"] as? NSDictionary {
                    self.setSendButtonEnabled(false)
                    let indexLast: Int = self.lastIndexOfSenderMessage()
                    if let tempVar = tempDict["url"] as? String {
                        self.isImageTemp = true
                        self.fireSendMessage(tempVar, isImage: true)
                    }
                }
            } else {
                //Set tableView's last cell to its's error view
                if self.lastIndexOfSenderMessage() != -1 {
                    self.messageTableData[self.lastIndexOfSenderMessage()].hasError = true
                    self.tableView.reloadData()
                }
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken()
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
            }
            
        })
    }
    
    
    //MARK: - Fire Refresh Token
    /*Function called when access_token is already expired. */
    func fireRefreshToken() {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                
                switch self.requestType {
                case .GetConversation :
                    self.fireGetConversationList()
                case .AttachImage :
                    self.fireAttachImage(self.imageUploadTemp)
                case .SendImage:
                    self.fireSendMessage(self.messageTemp, isImage: self.isImageTemp)
                }
                
                self.fireGetConversationList()
            } else {
                //Forcing user to logout.
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logout()
                    FBSDKLoginManager().logOut()
                    GPPSignIn.sharedInstance().signOut()
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.startPage()
                })
            }
        })
    }
    
    
    //MARK: GCM Notifications
    /*Function called when change of status is sent through GCM.
    * Parse JSON return from GCM to get the userId and isOnline status of user.
    * And change the status of user and update the views according to status */
    func onStatusUpdate(notification: NSNotification){
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding){
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        if let userId = json["userId"] as? Int{
                            if (String(userId) == self.receiver.userId){
                                if let status = json["isOnline"] as? Bool{
                                    if (!status){
                                        self.receiver.isOnline = "0"
                                        self.onlineView.backgroundColor = Constants.Colors.offlineColor
                                        self.onlineLabel.text = MessagingLocalizedStrings.offline
                                    } else {
                                        self.receiver.isOnline = "1"
                                        self.onlineView.backgroundColor = Constants.Colors.onlineColor
                                        self.onlineLabel.text = MessagingLocalizedStrings.online
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /*Function called when seen status is sent through GCM.
    * Parse JSON return from GCM to get the userId and check if it is for the current user.
    * And change the seen status of object and reload the tableview to update the 
    * seen status of tableview cell*/
    func onSeenMessage(notification : NSNotification){
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding){
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        if let userId = json["userId"] as? Int{
                            if (String(userId) == self.sender.userId){
                                self.messageTableData[self.messageTableData.count - 1].isSeen = "1"
                                self.tableView.reloadData()
//                                self.resetAndGetDataWithHud(false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func onReceiveNewMessage(notification : NSNotification){
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding){
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        if let userId = json["senderUid"] as? Int{
                            if (String(userId) == self.receiver.userId){
                                if let message = json["message"] as? String  {
                                    self.messageTableData.append(MessagingMessageModel(
                                        messageId: self.TEMP_MESSAGE_ID,
                                        senderId: self.receiver.userId,
                                        recipientId: SessionManager.userId(),
                                        senderProfileImageUrl: self.receiver.profileImageUrl,
                                        senderProfileThumbnailImageUrl: "",
                                        senderProfileSmallImageUrl: "",
                                        senderProfileMediumImageUrl: "",
                                        senderProfileLargeImageUrl: "",
                                        message: message,
                                        isImage: "0",
                                        timeSent: NSDate().formatDateToString("yyyy-MM-dd HH:mm:ss"),
                                        isSeen: "0",
                                        timeSeen: NSDate().formatDateToString("yyyy-MM-dd HH:mm:ss"),
                                        isSenderOnline: self.receiver.isOnline,
                                        isSent: false,
                                        hasError: false,
                                        image: UIImage(named: "dummy-placeholder")!))
                                    self.tableView.reloadData()
                                }
                                
                                self.resetAndGetDataWithHud(false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Util Functions
    
    func resetAndGetDataWithHud(showHud: Bool) {
        self.isEndReached = false
        self.page = 1
        self.showHud = showHud
        self.fireGetConversationList()
    }
    
    //Get last index of sender's message
    func lastIndexOfSenderMessage() -> Int {
        for var i: Int = 0; i < self.messageTableData.count; i++ {
            if !self.messageTableData[i].isSent {
                return i
            }
        }
        return -1
    }
    
    //Set enabled send button
    func setSendButtonEnabled(enabled: Bool) {
        if enabled {
            self.sendButton.alpha = 1.0
            self.sendButton.enabled = true
            self.addPhotoButton.alpha = 1.0
            self.addPhotoButton.enabled = true

        } else {
            self.sendButton.alpha = 0.5
            self.sendButton.enabled = false
            self.addPhotoButton.alpha = 0.5
            self.addPhotoButton.enabled = false
        }
    }
    
    //Close Keyboard
    func closeKeyboard() {
        self.messageTextField.resignFirstResponder()
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
        self.tabBarController!.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    // Keyboard notification function
    /* Update frame of whole view when keyboard is showing by subtracting keyboard height to
     * original Y origin of view and adding the tab bar height */
    func keyboardWillShow (notification: NSNotification){
        if let userInfo = notification.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.view.frame = CGRectMake(0, (self.viewOriginY - keyboardHeight + self.tabBarHeight), self.view.frame.width, self.view.frame.height)
                        self.goToBottomTableView()
                    }, completion: nil)
            }
        }
    }
    
    /* Update frame of whole view when keyboard is hiding by setting its original frame*/
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.view.frame = CGRectMake(0, self.viewOriginY, self.view.frame.width, self.view.frame.height)
                    },  completion: nil)
            }
        }
    }
}

extension MessagingThreadViewController: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageTableData.count
    }
    
    /*Check if message is an image and set its height fixed value,
    * else set its height to dymanic value */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tempModel: MessagingMessageModel = messageTableData[indexPath.row]
        
        if tempModel.isImage == "1" {
            return 270.0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    /*Check type of message by comparing the userId, 
    * and set values/data to tableview cell */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let tempModel: MessagingMessageModel = messageTableData[indexPath.row]
        
        if tempModel.isImage == "1" {
            if tempModel.senderId == SessionManager.userId() {
                var cell: MessagingSenderImageTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(MESSAGE_SENDER_IMAGE_TABLEVIEW_CELL_IDENTIFIER) as! MessagingSenderImageTableViewCell
                if tempModel.message.isEmpty {
                    cell.messageImageView.image = tempModel.image
                } else {
                    cell.messageImageView.sd_setImageWithURL(NSURL(string: tempModel.message), placeholderImage: UIImage(named: "dummy-placeholder"))
                }
                
                cell.profileImageView.sd_setImageWithURL(NSURL(string: tempModel.senderProfileImageUrl), placeholderImage: UIImage(named: "dummy-placeholder"))
                cell.setHasError(tempModel.hasError)
                cell.setIsSent(tempModel.isSent)
                if tempModel.isSeen == "1" {
                    cell.setSeen(true)
                    cell.setDate(tempModel.timeSeen)
                } else {
                    cell.setSeen(false)
                    cell.setDate(tempModel.timeSent)
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            } else {
                var cell: MessagingReceiverImageTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(MESSAGE_RECEIVER_IMAGE_TABLEVIEW_CELL_IDENTIFIER) as! MessagingReceiverImageTableViewCell
                cell.messageImageView.sd_setImageWithURL(NSURL(string: tempModel.message), placeholderImage: UIImage(named: "dummy-placeholder"))
                cell.profileImageView.sd_setImageWithURL(NSURL(string: tempModel.senderProfileImageUrl), placeholderImage: UIImage(named: "dummy-placeholder"))
                cell.setDate(tempModel.timeSent)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
        } else {
            if tempModel.senderId == SessionManager.userId() {
                var cell: MessagingSenderTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(MESSAGE_SENDER_TABLEVIEW_CELL_IDENTIFIER) as! MessagingSenderTableViewCell
                cell.messageLabel.text = tempModel.message
                cell.profileImageView.sd_setImageWithURL(NSURL(string: tempModel.senderProfileImageUrl), placeholderImage: UIImage(named: "dummy-placeholder"))
                cell.setHasError(tempModel.hasError)
                cell.setIsSent(tempModel.isSent)
                if tempModel.isSeen == "1"{
                    cell.setSeen(true)
                    cell.setDate(tempModel.timeSeen)
                } else {
                    cell.setSeen(false)
                    cell.setDate(tempModel.timeSent)
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            } else {
                var cell: MessagingReceiverTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(MESSAGE_RECEIVER_TABLEVIEW_CELL_IDENTIFIER) as! MessagingReceiverTableViewCell
                cell.messageLabel.text = tempModel.message
                cell.profileImageView.sd_setImageWithURL(NSURL(string: tempModel.senderProfileImageUrl), placeholderImage: UIImage(named: "dummy-placeholder"))
                cell.setDate(tempModel.timeSent)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
        }
    }
    
    // UITableViewDelegate
    /*Check if message is an image and redirect to viewing of image,
    * else close the keyboard */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let tempModel: MessagingMessageModel = messageTableData[indexPath.row]
        
        if tempModel.isImage == "1" {
            let productFullScreen: ProductFullScreenViewController = ProductFullScreenViewController(nibName: "ProductFullScreenViewController", bundle: nil)
            productFullScreen.images.append(self.messageTableData[indexPath.row].message)
            productFullScreen.index = 0
            productFullScreen.screenSize = self.view.frame
            
            self.navigationController?.presentViewController(productFullScreen, animated: false, completion: nil)
        } else {
            self.closeKeyboard()
        }
    }
    
    // UIScrollViewDelegate
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset: CGPoint = scrollView.contentOffset
        if offset.y < 0 {
            self.fireGetConversationList()
        }
    }
    
    //Table view Utils
    // Scroll to bottom of tableview
    func goToBottomTableView(){
        if(tableView.numberOfRowsInSection(0) > 0) {
            var lastIndexPath : NSIndexPath = getLastIndexPath(tableView)
            tableView.scrollToRowAtIndexPath(lastIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
        }
    }
    
    func getLastIndexPath(param : UITableView) -> NSIndexPath{
        var lastSectionIndex : NSInteger = max(0, param.numberOfSections() - 1)
        var lastRowIndex : NSInteger = max(0, param.numberOfRowsInSection(lastSectionIndex) - 1)
        
        return NSIndexPath(forRow: lastRowIndex, inSection: lastSectionIndex)
    }
}

extension MessagingThreadViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate {
    func openImageActionSheet(){
        if( controllerAvailable()){
            handleIOS8()
        } else {
            var actionSheet:UIActionSheet
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
                actionSheet = UIActionSheet(title: MessagingLocalizedStrings.addPhotoLocalizeString, delegate: self, cancelButtonTitle: MessagingLocalizedStrings.cancelLocalizeString, destructiveButtonTitle: nil, otherButtonTitles: MessagingLocalizedStrings.selectPhotoLocalizeString, MessagingLocalizedStrings.takePhotoLocalizeString)
            } else {
                actionSheet = UIActionSheet(title: MessagingLocalizedStrings.addPhotoLocalizeString, delegate: self, cancelButtonTitle: MessagingLocalizedStrings.cancelLocalizeString, destructiveButtonTitle: nil,otherButtonTitles: MessagingLocalizedStrings.selectPhotoLocalizeString)
            }
            actionSheet.delegate = self
            actionSheet.showInView(self.view)
            /* Implement the delegate for actionSheet */
        }
    }
    
    //Method for
    func handleIOS8(){
        let imageController = UIImagePickerController()
        imageController.editing = false
        imageController.delegate = self
        let alert = UIAlertController(title: MessagingLocalizedStrings.addPhotoLocalizeString, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let libButton = UIAlertAction(title: MessagingLocalizedStrings.selectPhotoLocalizeString, style: UIAlertActionStyle.Default) { (alert) -> Void in
            imageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imageController, animated: true, completion: nil)
        }
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title:MessagingLocalizedStrings.takePhotoLocalizeString, style: UIAlertActionStyle.Default) { (alert) -> Void in
                imageController.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(imageController, animated: true, completion: nil)
                
            }
            alert.addAction(cameraButton)
        } else {
            
        }
        let cancelButton = UIAlertAction(title: MessagingLocalizedStrings.cancelLocalizeString, style: UIAlertActionStyle.Cancel) { (alert) -> Void in
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.imageUploadTemp = image
        self.fireAttachImage(image)
        
        self.closeKeyboard()
        self.messageTableData.append(MessagingMessageModel(
            messageId: TEMP_MESSAGE_ID,
            senderId: SessionManager.userId(),
            recipientId: self.receiver.userId,
            senderProfileImageUrl: self.sender.profileImageUrl,
            senderProfileThumbnailImageUrl: "",
            senderProfileSmallImageUrl: "",
            senderProfileMediumImageUrl: "",
            senderProfileLargeImageUrl: "",
            message: "",
            isImage: "1",
            timeSent: NSDate().formatDateToString("yyyy-MM-dd HH:mm:ss"),
            isSeen: "0",
            timeSeen: NSDate().formatDateToString("yyyy-MM-dd HH:mm:ss"),
            isSenderOnline: self.receiver.isOnline,
            isSent: false,
            hasError: false,
            image: image))
        self.tableView.reloadData()
        self.messageTextField.text = ""
        self.goToBottomTableView()
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let imageController = UIImagePickerController()
        imageController.editing = false
        imageController.delegate = self;
        if buttonIndex == 1 {
            imageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        } else if buttonIndex == 2 {
            imageController.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            
        }
        self.presentViewController(imageController, animated: true, completion: nil)
    }
    
    //Check if UIAlertController if available
    func controllerAvailable() -> Bool {
        if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
            return true;
        }
        else {
            return false;
        }
    }

}
