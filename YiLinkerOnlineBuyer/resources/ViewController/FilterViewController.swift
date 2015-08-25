//
//  FilterViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var rangeBar: TTRangeSlider!
    @IBOutlet weak var applyFilterButton: SemiRoundedButton!
    @IBOutlet weak var filterTableView: UITableView!
    
    var tableData: [FilterAttributeModel] = [
        FilterAttributeModel(title: "Brands", attributes: ["All", "Samsung", "Apple", "Sony", "HTC", "LG", "Huawei"]),
        FilterAttributeModel(title: "Memory", attributes: ["All", "1GB", "2GB", "4GB", "8GB", "16GB", "32GB", "64GB", "128GB"]),
        FilterAttributeModel(title: "Color", attributes: ["All", "White", "Black", "Gold"])]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var nib = UINib(nibName: "FilterTableViewCell", bundle: nil)
        filterTableView.registerNib(nib, forCellReuseIdentifier: "FilterTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func resetAction(sender: AnyObject) {
    }
    
    @IBAction func applyFilterAction(sender: AnyObject) {
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData.count
    }
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterTableViewCell", forIndexPath: indexPath) as! FilterTableViewCell
        cell.passModel(tableData[indexPath.row])
    // Configure the cell...
    
    return cell
    }
    
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
