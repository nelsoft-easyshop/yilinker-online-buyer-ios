//
//  MessagesVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/2/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class ConversationVC: UIViewController {

    @IBOutlet weak var conversationTableView: UITableView!
    var conversations = [W_Conversation]()
    var filteredConversations = [W_Conversation]()
    
    let profileImageSquareDimension = 40
    
    var searchActive : Bool = false

    let cellIdentifier = "MessageCell"
    
    var offlineColor = UIColor(red: 218/255, green: 32/255, blue: 43/255, alpha: 1.0)
    var onlineColor = UIColor(red: 84/255, green: 182/255, blue: 167/255, alpha: 1.0)
    
    override func viewDidLoad() {
        var test = W_Conversation()
        //conversations = test.testData()
        //self.fireLogin()
        self.getConversationsFromEndpoint("1", limit: "10")
        
        conversationTableView.tableFooterView = UIView(frame: CGRectZero)
        
        super.viewDidLoad()
        
        var locX = UIScreen.mainScreen().bounds.size.width * 0.75
        var locY = UIScreen.mainScreen().bounds.size.height * 0.85
        
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

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createMessage(sender: UIButton!){
        self.performSegueWithIdentifier("show_contacts", sender: self)
    }
    
    func fireLogin() {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = ["email": "buyer@easyshop.ph","password": "password", "client_id": Constants.Credentials.clientID, "client_secret": Constants.Credentials.clientSecret, "grant_type": Constants.Credentials.grantBuyer]
        
        manager.POST(APIAtlas.loginUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            SVProgressHUD.dismiss()
            //self.showSuccessMessage()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Mismatch username and password", title: "Login Failed")
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                }
                
                SVProgressHUD.dismiss()
        })
    }
    
    func getConversationsFromEndpoint(
        page : String,
        limit : String){
            SVProgressHUD.show()
            
            let manager: APIManager = APIManager.sharedInstance
            manager.requestSerializer = AFHTTPRequestSerializer()
            
            let parameters: NSDictionary = [
                "page"          : "\(page)",
                "limit"         : "\(limit)",
                "access_token"  : SessionManager.accessToken()
                ]   as Dictionary<String, String>
            
            let url = APIAtlas.baseUrl + APIAtlas.ACTION_GET_CONVERSATION_HEAD
            println(url)
            println(parameters)
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.conversations = W_Conversation.parseConversations(responseObject as! NSDictionary)
                self.conversationTableView.reloadData()
                
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
                    self.conversations = Array<W_Conversation>()
                    self.conversationTableView.reloadData()
                    
                    SVProgressHUD.dismiss()
            })
    }

}

extension ConversationVC : UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(conversations.count)
        return conversations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(searchActive){
            let convoCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath : indexPath) as! ConversationTVC
            
            convoCell.user_name.text = filteredConversations[indexPath.row].contact.fullName as String
            convoCell.user_message.text = filteredConversations[indexPath.row].lastMessage as String
            convoCell.user_dt.text = DateUtility.convertDateToString(filteredConversations[indexPath.row].lastMessageDt) as String
            //convoCell.user_thumbnail.image = filteredConversations[indexPath.row].contact.profileImageUrl
            convoCell.user_thumbnail.layer.cornerRadius = convoCell.user_thumbnail.frame.width/2
            convoCell.user_thumbnail.layer.masksToBounds = true

            
            return convoCell
        } else {
            let convoCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath : indexPath) as! ConversationTVC
            
            convoCell.user_name.text = conversations[indexPath.row].contact.fullName as String
            convoCell.user_message.text = conversations[indexPath.row].lastMessage as String
            convoCell.user_dt.text = DateUtility.convertDateToString(conversations[indexPath.row].lastMessageDt) as String
            //convoCell.user_thumbnail.image = conversations[indexPath.row].contact.profileImageUrl
            let url = NSURL(string: conversations[indexPath.row].contact.profileImageUrl)
            convoCell.user_thumbnail.sd_setImageWithURL(url)
            if (convoCell.user_thumbnail.image == nil){
                convoCell.user_thumbnail.image = UIImage(named: "Male-50.png")
            }
            convoCell.user_thumbnail.layer.cornerRadius = convoCell.user_thumbnail.frame.width/2
            convoCell.user_thumbnail.layer.masksToBounds = true
            
            convoCell.user_online.layer.borderWidth = 2.0
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
    
}