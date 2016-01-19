 //
//  MessagingContactListViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 1/11/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class MessagingContactListViewController: UIViewController {
    
    let CONTACT_TABLEVIEW_CELL_IDENTIFIER: String = "MessagingContactTableViewCell"
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    var emptyView : EmptyView?
    
    var hud: MBProgressHUD?
    
    var contactsTableData: [MessagingContactModel] = []
    
    //Get conversation params
    let LIMIT: Int = 30
    var page: Int = 1
    var keyword: String = ""
    var isEndReached: Bool = false
    var isFromSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.emptyView?.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.resetData()
        self.contactsTableData.removeAll(keepCapacity: false)
        self.fireGetContactList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: View Customizations
    
    // Function to initializes views attributes
    func initializeViews() {
        self.title = MessagingLocalizedStrings.titleNewMessage
        self.edgesForExtendedLayout = UIRectEdge.None
        
        // Initialize tableview delegate and data source
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Register tableview's cell
        var nib = UINib(nibName: CONTACT_TABLEVIEW_CELL_IDENTIFIER, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: CONTACT_TABLEVIEW_CELL_IDENTIFIER)
        
        // Remove tableView's footer
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = Constants.Colors.backgroundGray
        
        self.addBackButton()
        
        // Set textfield placeholder text and color
        self.searchTextField.attributedPlaceholder = NSAttributedString(string:MessagingLocalizedStrings.writeTo,
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.searchTextField.tintColor = UIColor.whiteColor()
        
        //Initialize no results label
        self.noResultLabel.hidden = true
        self.noResultLabel.text = MessagingLocalizedStrings.noResultLocalizeString
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
    
    @IBAction func editingChange(sender: AnyObject) {
        self.resetData()
        self.keyword = self.searchTextField.text
        self.isFromSearch = true
        self.fireGetContactList()
    }
    
    //MARK: API Requests
    // Function to get contact list
    func fireGetContactList() {
        if !isEndReached {
            if self.page == 1 && !isFromSearch{
                self.showHUD()
            } else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            }
            
            WebServiceManager.fireGetContactListWithUrl("\(APIAtlas.ACTION_GET_CONTACTS_V2)?access_token=\(SessionManager.accessToken())", keyword: self.keyword, page: "\(self.page)", limit: "\(self.LIMIT)", actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                
                self.hud?.hide(true)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if successful {
                    
                    if self.isFromSearch {
                        self.contactsTableData.removeAll(keepCapacity: false)
                    }
                    
                    //Parsing of data
                    //Loop to data object to parse json
                    let dictionary: NSDictionary = responseObject as! NSDictionary
                    if let tempArray = dictionary["data"] as? NSArray {
                        for item in tempArray {
                            if let tempItem = item as? NSDictionary {
                                println(tempItem)
                                self.contactsTableData.append(MessagingContactModel.parseDataFromDictionary(tempItem))
                                println(MessagingContactModel.parseDataFromDictionary(tempItem).fullName)
                            }
                        }
                        
                        if self.contactsTableData.count == 0 {
                            self.noResultLabel.hidden = false
                        } else {
                            self.noResultLabel.hidden = true
                        }
                        
                        //Check if the pagination reaches end
                        if self.contactsTableData.count % self.LIMIT != 0 || tempArray.count == 0 {
                            self.isEndReached = true
                        } else {
                            self.page++
                        }
                    }
                    
                    self.tableView.reloadData()
                    
                } else {
                    self.addEmptyView()
                    if requestErrorType == .ResponseError {
                        //Error in api requirements
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                    } else if requestErrorType == .AccessTokenExpired {
                        self.fireRefreshToken()
                    } else if requestErrorType == .PageNotFound {
                        //Page not found
                        Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                    } else if requestErrorType == .NoInternetConnection && !Reachability.isConnectedToNetwork() {
                        //No internet connection
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    } else if requestErrorType == .RequestTimeOut {
                        //Request timeout
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    } else if requestErrorType == .UnRecognizeError {
                        //Unhandled error
                        Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                    } else {
                        self.emptyView?.hidden = true
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
                self.fireGetContactList()
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
    
    //Reset data
    func resetData() {
        self.isFromSearch = false
        self.isEndReached = false
        self.keyword = ""
        self.page = 1
    }
}

extension MessagingContactListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactsTableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: MessagingContactTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(CONTACT_TABLEVIEW_CELL_IDENTIFIER) as! MessagingContactTableViewCell
        
        let tempModel: MessagingContactModel = contactsTableData[indexPath.row]
        cell.contactName.text = tempModel.fullName
        cell.contactImageView.sd_setImageWithURL(NSURL(string: tempModel.profileImageUrl), placeholderImage: UIImage(named: "dummy-placeholder"))
        
        if tempModel.isOnline == "1" {
            cell.setIsOnline(true)
        } else {
            cell.setIsOnline(false)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 53
    }
    
    // UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var viewController = MessagingThreadViewController(nibName: "MessagingThreadViewController", bundle: nil)
        viewController.receiver = self.contactsTableData[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated:true)
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
            self.fireGetContactList()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.searchTextField.resignFirstResponder()
    }
}
 
 extension MessagingContactListViewController : EmptyViewDelegate{
    func addEmptyView() {
        self.contactsTableData.removeAll(keepCapacity: false)
        self.tableView.reloadData()
        if self.emptyView == nil {
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView?.frame = self.view.frame
            self.emptyView!.delegate = self
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
        }
    }
    
    func didTapReload() {
        self.resetData()
        self.contactsTableData.removeAll(keepCapacity: false)
        self.fireGetContactList()
        self.emptyView?.hidden = true
    }
 }
