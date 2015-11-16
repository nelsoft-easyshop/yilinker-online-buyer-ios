//
//  FilterViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func resetFilterViewControllerAction()
    func cancelFilterViewControllerAction()
    func applyFilterViewControllerAction(maxPrice: Double, minPrice: Double, filters: NSDictionary)
}


class FilterViewController: UIViewController, FilterTableViewCellDelegate {
    
    var delegate: FilterViewControllerDelegate?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var rangeBar: TTRangeSlider!
    @IBOutlet weak var applyFilterButton: SemiRoundedButton!
    @IBOutlet weak var filterTableView: UITableView!
    
    var tableData: [FilterAttributeModel] = []
    
    var selectedFilters: Dictionary <String, String> = Dictionary()
    
    var maxPrice: Double = 0
    var minPrice: Double = 0
    var selectedMaxPrice: Double = 0
    var selectedMinPrice: Double = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var nib = UINib(nibName: "FilterTableViewCell", bundle: nil)
        filterTableView.registerNib(nib, forCellReuseIdentifier: "FilterTableViewCell")
        
        rangeBar.minValue = Float(minPrice)
        rangeBar.maxValue = Float(maxPrice)
        
        rangeBar.selectedMinimum = Float(selectedMinPrice)
        rangeBar.selectedMaximum = Float(selectedMaxPrice)
        
        initializeLocalizedString()
    }
    
    func initializeLocalizedString() {
        let cancelLocalizeString: String = StringHelper.localizedStringWithKey("CANCEL_LOCALIZE_KEY")
        cancelButton.setTitle(cancelLocalizeString, forState: UIControlState.Normal)
        
        let doneLocalizeString: String = StringHelper.localizedStringWithKey("RESET_LOCALIZE_KEY")
        resetButton.setTitle(doneLocalizeString, forState: UIControlState.Normal)
        
        let applyLocalizeString: String = StringHelper.localizedStringWithKey("APPLYFILTER_LOCALIZE_KEY")
        applyFilterButton.setTitle(applyLocalizeString, forState: UIControlState.Normal)
    }
    
    func passFilter(filters: [FilterAttributeModel], maxPrice: Double, minPrice: Double) {
        tableData.removeAll(keepCapacity: false)
        tableData = filters
        
        for var i: Int = 0; i < tableData.count; i++ {
            selectedFilters[tableData[i].title] = "All"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        for var i: Int = 0; i < tableData.count; i++ {
            tableData[i].selectedIndex = 0
        }
        delegate?.cancelFilterViewControllerAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func resetAction(sender: AnyObject) {
        for var i: Int = 0; i < tableData.count; i++ {
            tableData[i].selectedIndex = 0
        }
        
        filterTableView.reloadData()
        rangeBar.selectedMaximum = Float(maxPrice)
        rangeBar.selectedMinimum = Float(minPrice)
        delegate?.resetFilterViewControllerAction()
    }
    
    @IBAction func applyFilterAction(sender: AnyObject) {
        delegate!.applyFilterViewControllerAction(Double(rangeBar.selectedMaximum), minPrice: Double(rangeBar.selectedMinimum), filters: selectedFilters as NSDictionary)
        self.dismissViewControllerAnimated(true, completion: nil)
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
        cell.passModel(tableData[indexPath.row], attributeNameIndex: indexPath.row)
        cell.delegate = self
    
    return cell
    }
    
    
    // MARK : FilterTableViewCellDelegate
    
    func clickedAttributeAtIndex(index: Int, attributeNameIndex: Int) {
        tableData[attributeNameIndex].selectedIndex = index
        selectedFilters[tableData[attributeNameIndex].title] = tableData[attributeNameIndex].attributes[index]
        
        println(selectedFilters)
    }

}
