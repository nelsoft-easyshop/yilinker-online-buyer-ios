//
//  MyPointsTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class MyPointsTableViewController: UITableViewController, PointsBreakdownTableViewCellDelegate {
    let cellPointsEarned: String = "PointsEarnedTableViewCell"
    let cellPointsDetails: String = "PointsDetailsTableViewCell"
    let cellPointsBreakDownHeader: String = "PointsBreakdownTableViewCell"
    let cellPoints: String = "PointsTableViewCell"
    
    var tableData: [PointModel] = [PointModel(date: "Jan 20, 2016", details: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", points: "-10"), PointModel(date: "Jan 21, 2016", details: "Maecenas eu ipsum feugiat, sodales elit gravida, convallis tortor.", points: "+20"), PointModel(date: "Jan 22, 2016", details: "Pellentesque iaculis interdum dui non auctor.", points: "+50"), PointModel(date: "Jan 23, 2016", details: "Maecenas vel tincidunt ligula. ", points: "-20")]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
        registerNibs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeViews() {
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
    
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150.0

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func registerNibs() {
        var nibEarned = UINib(nibName: cellPointsEarned, bundle: nil)
        self.tableView.registerNib(nibEarned, forCellReuseIdentifier: cellPointsEarned)
        
        var nibDetails = UINib(nibName: cellPointsDetails, bundle: nil)
        self.tableView.registerNib(nibDetails, forCellReuseIdentifier: cellPointsDetails)
        
        var nibHeader = UINib(nibName: cellPointsBreakDownHeader, bundle: nil)
        self.tableView.registerNib(nibHeader, forCellReuseIdentifier: cellPointsBreakDownHeader)
        
        var nibPoints = UINib(nibName: cellPoints, bundle: nil)
        self.tableView.registerNib(nibPoints, forCellReuseIdentifier: cellPoints)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData.count + 3
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellPointsEarned, forIndexPath: indexPath) as! PointsEarnedTableViewCell
            cell.pointsLabel.text = "6,399"
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellPointsDetails, forIndexPath: indexPath) as! PointsDetailsTableViewCell
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellPointsBreakDownHeader, forIndexPath: indexPath) as! PointsBreakdownTableViewCell
            cell.delegate = self
            
            if tableData.count == 0 {
                cell.breakDownView.hidden = true
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellPoints, forIndexPath: indexPath) as! PointsTableViewCell
            
            cell.dateLabel.text = tableData[indexPath.row - 3].date
            cell.detailsLabel.text = tableData[indexPath.row - 3].details
            
            var points: String = tableData[indexPath.row - 3].points
            
            if points.rangeOfString("+") != nil {
                cell.pointsLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1.0)
                cell.pointsTitleLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1.0)
            } else {
                cell.pointsLabel.textColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1.0)
                cell.pointsTitleLabel.textColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 0.75)
            }
            
            cell.pointsLabel.text = points
            
            return cell
        }
    }
    
    /*
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 65
        } else if indexPath.row == 1 {
            return 175
        } else if indexPath.row == 2 {
            return 40
        }else {
            return 65
        }
    }*/

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - PointsBreakdownTableViewCellDelegate
    // Callback when how to earned points button is clicked
    func howToEarnActionForIndex(sender: AnyObject) {
        
    }
    
}
