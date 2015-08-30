//
//  ContactListVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/15/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class ContactListVC: UIViewController {

    @IBOutlet weak var contactTableView: UITableView!
    
    var resultSearchController = UISearchController()
    
    var contacts = [W_Contact()]
    var filteredContacts = [W_Contact()]
    
    let contactIdentifier = "contactCell"
    let messageThreadSegueIdentifier = "message_thread"
    
    var offlineColor = UIColor(red: 218/255, green: 32/255, blue: 43/255, alpha: 1.0)
    var onlineColor = UIColor(red: 84/255, green: 182/255, blue: 167/255, alpha: 1.0)
    
    var selectedContact : W_Contact?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println(sender)
        if (segue.identifier == messageThreadSegueIdentifier){
            println("PREPARE FOR SEGUE CONTACT")
            var messageThreadVC = segue.destinationViewController as! MessageThreadVC
            
            let indexPath = contactTableView.indexPathForCell(sender as! ContactListTVC)
            selectedContact = contacts[indexPath!.row]

            messageThreadVC.sender = W_Contact(fullName: "Jan Dennis Nora", userRegistrationIds: "", userIdleRegistrationIds: "", userId: "5", profileImageUrl: "http://online.api.easydeal.ph/assets/images/uploads/users/4292229bce95d32748bf08b642f0a070a70bc194.png?", isOnline: "1")
            messageThreadVC.recipient = selectedContact
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ref = W_Contact()
        //contacts = ref.testData()
        self.getContactsFromEndpoint("1", limit: "30", keyword: "")
        
        self.contactTableView.contentInset = UIEdgeInsetsMake(
            contactTableView.rowHeight, 0, 0, 0)
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            self.contactTableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.navigationItem.title = "New Message"
        self.placeCustomBackImage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.resultSearchController.active = false
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
        SVProgressHUD.show()
            
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
            
            SVProgressHUD.dismiss()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if !Reachability.isConnectedToNetwork() {
                    UIAlertController.displayNoInternetConnectionError(self)
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                }
                self.contacts = Array<W_Contact>()
                self.contactTableView.reloadData()
                
                SVProgressHUD.dismiss()
        })
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
                cell.online_text.text = "Online"
                cell.online_view.backgroundColor = onlineColor
            } else {
                cell.online_text.text = "Offline"
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
                cell.online_text.text = "Online"
                cell.online_view.backgroundColor = onlineColor
            } else {
                cell.online_text.text = "Offline"
                cell.online_view.backgroundColor = offlineColor
            }
        }
        return cell
    }
    
}

extension ContactListVC : UISearchResultsUpdating{

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredContacts.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF.full_name CONTAINS[c] %@", searchController.searchBar.text)
        
        let array = (contacts as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredContacts = array as! [W_Contact]
        
        self.contactTableView.reloadData()
    }
}
