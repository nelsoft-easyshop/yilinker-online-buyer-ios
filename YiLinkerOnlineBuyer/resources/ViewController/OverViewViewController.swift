//
//  OverViewViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/19/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class OverViewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        self.tableView.layoutIfNeeded()
        let successHeaderView: SuccessTableHeaderViewCell = XibHelper.puffViewWithNibName("SuccessTableHeaderViewCell", index: 0) as! SuccessTableHeaderViewCell
        self.tableView.tableHeaderView = successHeaderView
        
        let totalTableViewCell: TotalTableViewCell = XibHelper.puffViewWithNibName(Constants.Checkout.OverView.totalTableViewCellNibNameAndIdentifier, index: 0) as! TotalTableViewCell
        self.tableView.tableFooterView = totalTableViewCell
    }
    
    func registerNib() {
        let plainNib: UINib = UINib(nibName: Constants.Checkout.OverView.plainTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(plainNib, forCellReuseIdentifier: Constants.Checkout.OverView.plainTableViewCellNibNameAndIdentifier)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: PlainTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.OverView.plainTableViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! PlainTableViewCell
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
