//
//  DeliveryLogVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/21/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class DeliveryLogVC: UIViewController {
    
    struct DeliveryStatus{
        static let PICK_UP = "Pickup Product"
        static let TRANSIT = "In Transit"
        static let CHECK_IN = "Warehouse Check-in"
        static let COMPLETE = "Delivery Complete"
    }
    
    @IBOutlet weak var deliveryTable: UITableView!
    @IBOutlet weak var transactionIDLabel: UILabel!

    var cellIdentifier = "cellStatus"
    var cellFinalIdentifier = "cellFinalStatus"
    
    var dictionaryLogs = Dictionary<String, [W_Delivery_Logs]>()
    var deliveryLogs = [W_Delivery_Logs()]
    
    var sectionCount = 0
    var sectionHeader = [String()]
    
    let lineColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
    let bgColor = UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1.0)
    let fontColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)

    
    let headerHeight : CGFloat = 41.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deliveryLogs = W_Delivery_Logs().testData()
        transactionIDLabel.text = "TID-203-553-918"
        
        
        var counts : [String:Int] = [:]

        for log in deliveryLogs{
            
            if self.dictionaryLogs.indexForKey(log.status_date) == nil{
                self.dictionaryLogs[log.status_date] = [log]
            } else {
                self.dictionaryLogs[log.status_date]?.append(log)
            }
            counts[log.status_date] = (counts[log.status_date] ?? 0) + 1
        }
        sectionCount = counts.count
        sectionHeader = counts.keys.array
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DeliveryLogVC : UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //place number of dates available
        return dictionaryLogs.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionaryLogs[sectionHeader[section]]!.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, headerHeight))
        
        headerView.backgroundColor = bgColor
        
        var lineView = UIView(frame: CGRectMake(0, headerHeight/2, tableView.frame.width, 1))
        lineView.backgroundColor = lineColor
        
        var sectionLabel = UILabel(frame: CGRectMake(tableView.frame.width/2 - 150/2, headerHeight/2 - headerHeight/4, 150, headerHeight/2))
        sectionLabel.text = sectionHeader[section]
        sectionLabel.backgroundColor = bgColor
        sectionLabel.textColor = fontColor
        sectionLabel.font = UIFont(name: sectionLabel.font.familyName, size: 13.0)
        sectionLabel.textAlignment = NSTextAlignment.Center
        
        headerView.addSubview(lineView)
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tableSection = dictionaryLogs[sectionHeader[indexPath.section]]
        let tableItem = tableSection![indexPath.row]
        
        if(tableItem.status == DeliveryStatus.COMPLETE){
            return 350
        } else {
            return 225
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var statusImage : UIImage = UIImage()
        var finalFlag : Bool = false
        
        let tableSection = dictionaryLogs[sectionHeader[indexPath.section]]
        let tableItem = tableSection![indexPath.row]
        
        switch tableItem.status {
        case DeliveryStatus.PICK_UP:
            statusImage = UIImage(named: "product.png")!
            break
        case DeliveryStatus.TRANSIT:
            statusImage = UIImage(named: "transit.png")!
            break
        case DeliveryStatus.CHECK_IN:
            statusImage = UIImage(named: "warehouse.png")!
            break
        case DeliveryStatus.COMPLETE:
            statusImage = UIImage(named: "complete.png")!
            finalFlag = true
            break
        default:
            println("do nothing")
        }
        
        if (!finalFlag){
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! DeliveryLogTVC
            
            cell.deliveryStatusImage.image = statusImage
            cell.deliveryStatusLabel.text = tableItem.status
            cell.deliveryStatusTime.text = tableItem.status_time
            cell.statusDateLabel.text = tableItem.status_date
            cell.statusLocationLabel.text = tableItem.status_location
            cell.statusRiderLabel.text = tableItem.status_rider
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellFinalIdentifier) as! DeliveryLogTVC
            
            cell.deliveryStatusImage.image = statusImage
            cell.deliveryStatusLabel.text = tableItem.status
            cell.deliveryStatusTime.text = tableItem.status_time
            cell.statusDateLabel.text = tableItem.status_date
            cell.statusLocationLabel.text = tableItem.status_location
            cell.statusRiderLabel.text = tableItem.status_rider
            
            //var url = NSURL(string: deliveryLogs[indexPath.row].status_signature)
            //cell.clientSignatureImage.sd_setImageWithURL(url)
            
            //if (cell.clientSignatureImage.image == nil){
            //place replacement image
            //}
            
            return cell
        }
        
    }
    
}
