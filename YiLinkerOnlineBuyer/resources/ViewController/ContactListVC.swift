//
//  ContactListVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/15/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class ContactListVC: UIViewController, EmptyViewDelegate{
    
    @IBOutlet weak var contactTableView: UITableView!
    
    var resultSearchController = UISearchController()
    
    var contacts = [W_Contact]()
    var filteredContacts = [W_Contact]()
    
    let contactIdentifier = "contactCell"
    let messageThreadSegueIdentifier = "message_thread"
    
    var offlineColor = UIColor(red: 218/255, green: 32/255, blue: 43/255, alpha: 1.0)
    var onlineColor = UIColor(red: 84/255, green: 182/255, blue: 167/255, alpha: 1.0)
    
    var selectedContact : W_Contact?
    
    var hud: MBProgressHUD?
    var emptyView : EmptyView?
    var contentViewFrame: CGRect?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == messageThreadSegueIdentifier){
            println("PREPARE FOR SEGUE CONTACT")
            var messageThreadVC = segue.destinationViewController as! MessageThreadVC
            
            let indexPath = contactTableView.indexPathForCell(sender as! ContactListTVC)
            selectedContact = contacts[indexPath!.row]
            
            var isOnline = "-1"
            if (SessionManager.isLoggedIn()){
                isOnline = "1"
            } else {
                isOnline = "0"
            }
            
            messageThreadVC.sender = W_Contact(fullName: SessionManager.userFullName(), userRegistrationIds: "", userIdleRegistrationIds: "", userId: SessionManager.accessToken() , profileImageUrl: SessionManager.profileImageStringUrl(), isOnline: isOnline)
            messageThreadVC.recipient = selectedContact
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ref = W_Contact()
        self.contentViewFrame = self.view.frame
        
        self.getContactsFromEndpoint("1", limit: "30", keyword: "")
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            self.contactTableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.navigationItem.title = LocalizedStrings.titleNewMessage
        self.placeCustomBackImage()
        // Do any additional setup after loading the view.
    }
    
    func onStatusUpdate(notification: NSNotification){
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding){
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        if let userId = json["userId"] as? Int{
                            for contact in contacts{
                                if (contact.userId == String(userId)) {
                                    if let status = json["isOnline"] as? Bool{
                                        if (!status){
                                            contact.isOnline = "0"
                                        } else {
                                            contact.isOnline = "1"
                                        }
                                        self.contactTableView.reloadData()
                                        break
                                    }
                                }
                            }
                            
                            for contact in filteredContacts{
                                if (contact.userId == String(userId)) {
                                    if let status = json["isOnline"] as? Bool{
                                        if (!status){
                                            contact.isOnline = "0"
                                        } else {
                                            contact.isOnline = "1"
                                        }
                                        self.contactTableView.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onStatusUpdate:",
            name: appDelegate.statusKey, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.resultSearchController.active = false
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: appDelegate.statusKey, object: nil)
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
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getContactsFromEndpoint(
        page : String,
        limit : String,
        keyword: String){
            //SVProgressHUD.show()
            if (Reachability.isConnectedToNetwork()) {
                self.showHUD()
                
                let manager: APIManager = APIManager.sharedInstance
                manager.requestSerializer = AFHTTPRequestSerializer()
                
                let parameters: NSDictionary = [
                    "page"          : "\(page)",
                    "limit"         : "\(limit)",
                    "keyword"       : keyword,
                    "access_token"  : SessionManager.accessToken()
                    ]   as Dictionary<String, String>
                
                let url = APIAtlas.baseUrl + APIAtlas.ACTION_GET_CONTACTS
                
                manager.POST(url, parameters: parameters, success: {
                    (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                    self.contacts = W_Contact.parseContacts(responseObject as! NSDictionary)
                    self.contactTableView.reloadData()
                    
                    //SVProgressHUD.dismiss()
                    self.hud?.hide(true)
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
                        
                        self.contacts = Array<W_Contact>()
                        self.contactTableView.reloadData()
                        
                        //SVProgressHUD.dismiss()
                        self.hud?.hide(true)
                })
            } else {
                self.addEmptyView()
            }
            
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
                
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: LocalizedStrings.errorMessage, title: LocalizedStrings.errorTitle)
        })
        
    }
    
    func addEmptyView() {
        if self.emptyView == nil {
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView?.frame = self.contentViewFrame!
            self.emptyView!.delegate = self
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
            println("unhide empty view")
        }
    }
    
    func didTapReload() {
        self.getContactsFromEndpoint("1", limit: "30", keyword: "")
        self.emptyView?.hidden = true
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

extension ContactListVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.resultSearchController.active){
            return filteredContacts.count
        } else {
            return contacts.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(contactIdentifier) as! ContactListTVC
        
        if(self.resultSearchController.active){
            let url = NSURL(string: filteredContacts[indexPath.row].profileImageUrl)
            cell.profile_image.sd_setImageWithURL(url)
            if (cell.profile_image.image == nil){
                cell.profile_image.image = UIImage(named: "Male-50.png")
            }
            cell.profile_image.layer.cornerRadius = cell.profile_image.frame.width/2
            cell.profile_image.layer.masksToBounds = true
            cell.user_name.text = filteredContacts[indexPath.row].fullName
            if (filteredContacts[indexPath.row].isOnline == "1"){
                cell.online_text.text = LocalizedStrings.online
                cell.online_view.backgroundColor = onlineColor
            } else {
                cell.online_text.text = LocalizedStrings.offline
                cell.online_view.backgroundColor = offlineColor
            }
        } else {
            let url = NSURL(string: contacts[indexPath.row].profileImageUrl)
            cell.profile_image.sd_setImageWithURL(url)
            if (cell.profile_image.image == nil){
                cell.profile_image.image = UIImage(named: "Male-50.png")
            }
            
            cell.profile_image.layer.cornerRadius = cell.profile_image.frame.width/2
            cell.profile_image.layer.masksToBounds = true
            cell.user_name.text = contacts[indexPath.row].fullName
            if (contacts[indexPath.row].isOnline == "1"){
                cell.online_text.text = LocalizedStrings.online
                cell.online_view.backgroundColor = onlineColor
            } else {
                cell.online_text.text = LocalizedStrings.offline
                cell.online_view.backgroundColor = offlineColor
            }
        }
        return cell
    }
    
}

extension ContactListVC : UISearchResultsUpdating{
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredContacts.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF.fullName CONTAINS[c] %@", searchController.searchBar.text)
        
        let array = (contacts as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredContacts = array as! [W_Contact]
        
        self.contactTableView.reloadData()
    }
}
