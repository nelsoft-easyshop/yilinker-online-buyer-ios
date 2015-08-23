//
//  MessagesVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/2/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class ConversationVC: UIViewController {

    var conversations = [W_Conversation]()
    var filteredConversations = [W_Conversation]()
    
    let profileImageSquareDimension = 40
    
    var searchActive : Bool = false
    
    @IBOutlet weak var convoTable: UITableView!
    
    override func viewDidLoad() {
        var test = W_Conversation()
        conversations = test.testData()
        convoTable.tableFooterView = UIView(frame: CGRectZero)
        
        super.viewDidLoad()
        
        var locX = UIScreen.mainScreen().bounds.size.width * 0.75
        var locY = UIScreen.mainScreen().bounds.size.height * 0.85
        
        let createMessageButton = UIButton()
        createMessageButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        createMessageButton.frame = CGRectMake(locX, locY, 55, 55)
        createMessageButton.addTarget(self, action: "createMessage:", forControlEvents: .TouchUpInside)
        createMessageButton.setImage(UIImage(named: "Create New-64.png"), forState: UIControlState.Normal)
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
            let convoCell = tableView.dequeueReusableCellWithIdentifier(filteredConversations[indexPath.row].title, forIndexPath : indexPath) as! ConversationTVC
            
            convoCell.user_name.text = filteredConversations[indexPath.row].user.full_name as String
            convoCell.user_message.text = filteredConversations[indexPath.row].message as String
            convoCell.user_dt.text = DateUtility.convertDateToString(filteredConversations[indexPath.row].message_dt) as String
            convoCell.user_thumbnail.image = filteredConversations[indexPath.row].thumbnail
            convoCell.user_thumbnail.layer.cornerRadius = convoCell.user_thumbnail.frame.width/2
            convoCell.user_thumbnail.layer.masksToBounds = true

            
            return convoCell
        } else {
            let convoCell = tableView.dequeueReusableCellWithIdentifier(conversations[indexPath.row].title, forIndexPath : indexPath) as! ConversationTVC
            
            convoCell.user_name.text = conversations[indexPath.row].user.full_name as String
            convoCell.user_message.text = conversations[indexPath.row].message as String
            convoCell.user_dt.text = DateUtility.convertDateToString(conversations[indexPath.row].message_dt) as String
            convoCell.user_thumbnail.image = conversations[indexPath.row].thumbnail
            convoCell.user_thumbnail.layer.cornerRadius = convoCell.user_thumbnail.frame.width/2
            convoCell.user_thumbnail.layer.masksToBounds = true
            
            return convoCell
        }
    }
    
}