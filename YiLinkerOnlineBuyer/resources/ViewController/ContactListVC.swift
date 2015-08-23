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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ref = W_Contact()
        contacts = ref.testData()
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ContactListVC : UITableViewDataSource, UITableViewDelegate{
    
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
            cell.profile_image.image = UIImage(named: "Male-50.png")
            cell.profile_image.layer.cornerRadius = cell.profile_image.frame.width/2
            cell.profile_image.layer.masksToBounds = true
            cell.user_name.text = filteredContacts[indexPath.row].full_name
            cell.online_text.text = "Online"
            //let url = NSURL(string: contacts[indexPath.row].profile_image_url)
            //cell.profile_image.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Male-50.png"))
            cell.online_image.image = UIImage(named: "online.png")
            //cell.online_image.image = UIImage(named: "offline.png")
        } else {
            cell.profile_image.image = UIImage(named: "Male-50.png")
            cell.profile_image.layer.cornerRadius = cell.profile_image.frame.width/2
            cell.profile_image.layer.masksToBounds = true
            cell.user_name.text = contacts[indexPath.row].full_name
            cell.online_text.text = "Online"
            //let url = NSURL(string: contacts[indexPath.row].profile_image_url)
            //cell.profile_image.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Male-50.png"))
            cell.online_image.image = UIImage(named: "online.png")
            //cell.online_image.image = UIImage(named: "offline.png")
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
