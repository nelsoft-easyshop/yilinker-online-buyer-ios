//
//  StoreDetailListVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/23/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class StoreDetailListVC: UIViewController {

    struct StoreDetail {
        var detail1 : String
        var detail2 : String
        var detail3 : String
        var detail4 : String
        var isDefault : Bool
    }
    
    var storeDetails = Array<StoreDetail>()
    let storeDetailCell = "storeDetailCell"
    @IBOutlet weak var storeDetailTable: UITableView!
    @IBOutlet weak var storeDetailTableHeightConstraint: NSLayoutConstraint!
    
    var defaultSet : Bool = false
    let popTransitioningDelegate = PopTransitioningDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeDetails.append(StoreDetail(detail1: "1", detail2: "2", detail3: "3", detail4: "4", isDefault: false))
        storeDetails.append(StoreDetail(detail1: "a", detail2: "b", detail3: "c", detail4: "d", isDefault: true))
        
        
        self.storeDetailTable.scrollEnabled = false
        
        var newHeight = 130 * CGFloat(storeDetails.count)
        self.storeDetailTable.frame.size.height = newHeight
        storeDetailTableHeightConstraint.constant = newHeight
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onNew(sender: RoundedButtonLight) {
        transitioningDelegate = popTransitioningDelegate
        let vc = storyboard?.instantiateViewControllerWithIdentifier("AddStoreDetailViewController") as! AddStoreDetailVC
        vc.transitioningDelegate = popTransitioningDelegate
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        vc.mode = "Address"
        
        presentViewController(vc, animated: true, completion: nil)
    }

}

extension StoreDetailListVC : UITableViewDataSource, UITableViewDelegate{

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeDetails.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(storeDetailCell) as! StoreDetailTVC
        
        cell.detail1Label.text = storeDetails[indexPath.row].detail1
        cell.detail2Label.text = storeDetails[indexPath.row].detail2
        cell.detail3Label.text = storeDetails[indexPath.row].detail3
        cell.detail4Label.text = storeDetails[indexPath.row].detail4
        
        if(storeDetails[indexPath.row].isDefault){
            cell.setDefault(true)
        }
        
        return cell
    }
    
}
