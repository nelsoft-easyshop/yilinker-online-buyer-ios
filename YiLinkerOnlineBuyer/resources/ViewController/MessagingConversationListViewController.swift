//
//  MessagingConversationListViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 1/8/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct  MessagingLocalizedStrings {
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
    
    static let minutesAgo = StringHelper.localizedStringWithKey("MESSAGING_MINUTES_AGO")
    static let hoursAgo = StringHelper.localizedStringWithKey("MESSAGING_HOURS_AGO")
    static let daysAgo = StringHelper.localizedStringWithKey("MESSAGING_DAYS_AGO")
    static let minuteAgo = StringHelper.localizedStringWithKey("MESSAGING_MINUTE_AGO")
    static let hourAgo = StringHelper.localizedStringWithKey("MESSAGING_HOUR_AGO")
    static let dayAgo = StringHelper.localizedStringWithKey("MESSAGING_DAY_AGO")
    
    static let noMoreMessages = StringHelper.localizedStringWithKey("MESSAGING_NO_MESSAGE")
    static let writeTo = StringHelper.localizedStringWithKey("MESSAGING_WRITE_TO")
}

class MessagingConversationListViewController: UIViewController {
    
    let CONVERSATION_TABLEVIEW_CELL_IDENTIFIER: String = "MessagingConversationTableViewCell"

    @IBOutlet var tableView: UITableView!
    @IBOutlet var newMessageButton: UIButton!
    
    var hud: MBProgressHUD?
    
    var conversationsTableData: [MessagingConversationModel] = []
    
    //Get conversation params
    let LIMIT: Int = 30
    var page: Int = 1
    var isEndReached: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.isEndReached = false
        self.page = 1
        self.conversationsTableData.removeAll(keepCapacity: false)
        self.fireGetConversationList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: View Customizations
    
    // Function to initializes views attributes
    func initializeViews() {
        self.title = MessagingLocalizedStrings.title
        self.edgesForExtendedLayout = UIRectEdge.None
        
        // Initialize tableview delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register tableview's cell
        var nib = UINib(nibName: CONVERSATION_TABLEVIEW_CELL_IDENTIFIER, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: CONVERSATION_TABLEVIEW_CELL_IDENTIFIER)
        
        // Remove tableView's footer
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = Constants.Colors.backgroundGray
        
        // Make newMessageButton circular and add shadow
        self.newMessageButton.layer.cornerRadius = self.newMessageButton.frame.height / 2
        // Aadd shadow to newMessageButton
        self.newMessageButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.newMessageButton.layer.shadowOffset = CGSizeMake(1.0, 2.0);
        self.newMessageButton.layer.shadowOpacity = 0.75;
        self.newMessageButton.layer.shadowRadius = 2.0;
        
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
    
    //MARK: IBActions
    @IBAction func newMessageAction(sender: AnyObject) {
        // Open contacts page
        var contactsViewController = MessagingContactListViewController(nibName: "MessagingContactListViewController", bundle: nil)
        self.navigationController?.pushViewController(contactsViewController, animated:true)
    }
    
    
    //MARK: API Requests
    // Function to get conversation list
    func fireGetConversationList() {
        if isEndReached {
            Toast.displayToastWithMessage(MessagingLocalizedStrings.noMoreMessages, duration: 1.5, view: self.view)
        } else {
            self.showHUD()
            WebServiceManager.fireGetConversationListWithUrl("\(APIAtlas.ACTION_GET_CONVERSATION_HEAD_V2)?access_token=\(SessionManager.accessToken())", page: "\(self.page)", limit: "\(self.LIMIT)", actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
                println(responseObject)
                self.hud?.hide(true)
                if successful {
                    //Parsing of data
                    //Loop to data object to parse json
                    let dictionary: NSDictionary = responseObject as! NSDictionary
                    if let tempArray = dictionary["data"] as? NSArray {
                        for item in tempArray {
                            if let tempItem = item as? NSDictionary {
                                self.conversationsTableData.append(MessagingConversationModel.parseDataFromDictionary(tempItem))
                            }
                        }
                        
                        //Check if the pagination reaches end
                        if self.conversationsTableData.count % self.LIMIT != 0 || tempArray.count == 0 {
                            self.isEndReached = true
                        } else {
                            self.page++
                        }
                    }
                    
                    self.tableView.reloadData()
                    
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
    }
    
    //MARK: - Fire Refresh Token
    func fireRefreshToken() {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
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
    
    //MARK: Util Functions
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
}

extension MessagingConversationListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversationsTableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: MessagingConversationTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(CONVERSATION_TABLEVIEW_CELL_IDENTIFIER) as! MessagingConversationTableViewCell
        
        let tempModel: MessagingConversationModel = conversationsTableData[indexPath.row]
        
        if tempModel.message.isNotEmpty() {
            cell.messageLabel.text = tempModel.message
        } else {
            cell.messageLabel.text = ""
        }
        
        if tempModel.lastMessageDate.isNotEmpty() {
            cell.setDate(tempModel.lastMessageDate)
        } else {
            cell.dateLabel.text = ""
        }
        
        if let tempContactModel: MessagingContactModel = tempModel.contactDetails {
            cell.senderNameLabel.text = tempContactModel.fullName
            cell.senderImageView.sd_setImageWithURL(NSURL(string: tempContactModel.profileImageUrl), placeholderImage: UIImage(named: "dummy-placeholder"))
            
            if tempContactModel.isOnline == "1" {
                cell.setIsOnline(true)
            } else {
                cell.setIsOnline(false)
            }
            
            if tempContactModel.hasUnreadMessage.isNotEmpty() || tempContactModel.hasUnreadMessage != "0" {
                cell.messageLabel.boldFont()
            } else {
                cell.messageLabel.unboldFont()
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 76.0
    }
    
    // UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // UIScrollViewDelegate
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset: CGPoint = scrollView.contentOffset
        var bounds: CGRect = scrollView.bounds
        var size: CGSize = scrollView.contentSize
        var inset: UIEdgeInsets = scrollView.contentInset
        var y: CGFloat = offset.y + bounds.size.height - inset.bottom
        var h: CGFloat = size.height
        var reload_distance: CGFloat = 10
        var temp: CGFloat = h + reload_distance
        if y > temp {
            self.fireGetConversationList()
        }
    }
}
