//
//  SearchFilterTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 4/6/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SearchFilterTableViewController: UITableViewController {
    
    let HEADER_HEIGHT: Int = 151
    let FOOTER_HEIGHT: Int = 65
    let CELL_HEIGHT  : Int = 95
    
    var tableData: [FilterAttributeModel] = []
    
    var selectedFilters: Dictionary <String, String> = Dictionary()
    
    var maxPrice: Double = 0
    var minPrice: Double = 0
    var selectedMaxPrice: Double = 0
    var selectedMinPrice: Double = 0
    
    
    var tableHeight: Int = 0
    var tableTopInset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeTableView() {
        
        self.view.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
        var nibCell = UINib(nibName: FilterTableViewCell.reuseIdentifier, bundle: nil)
        self.tableView.registerNib(nibCell, forCellReuseIdentifier: FilterTableViewCell.reuseIdentifier)
        
        var nibHeader = UINib(nibName: FilterHeaderTableViewCell.reuseIdentifier, bundle: nil)
        self.tableView.registerNib(nibHeader, forCellReuseIdentifier: FilterHeaderTableViewCell.reuseIdentifier)
        
        var nibFooter = UINib(nibName: FilterFooterTableViewCell.reuseIdentifier, bundle: nil)
        self.tableView.registerNib(nibFooter, forCellReuseIdentifier: FilterFooterTableViewCell.reuseIdentifier)
        
        var bounds = UIScreen.mainScreen().bounds
        var height = bounds.size.height
        
        self.tableHeight = HEADER_HEIGHT + FOOTER_HEIGHT + (CELL_HEIGHT * 2)
        self.tableTopInset = height - CGFloat(tableHeight)
        
        self.tableView.contentInset = UIEdgeInsets(top: tableTopInset, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -tableTopInset)
    }

    
    func passFilter(filters: [FilterAttributeModel], maxPrice: Double, minPrice: Double) {
        self.tableData.removeAll(keepCapacity: false)
        self.tableData = filters
        self.tableData += filters
        
        for var i: Int = 0; i < self.tableData.count; i++ {
            self.selectedFilters[self.tableData[i].title] = "All"
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FilterTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! FilterTableViewCell
        cell.passModel(tableData[indexPath.row], attributeNameIndex: indexPath.row)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.tableView.dequeueReusableCellWithIdentifier(FilterHeaderTableViewCell.reuseIdentifier) as! FilterHeaderTableViewCell
        return headerCell
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell = self.tableView.dequeueReusableCellWithIdentifier(FilterFooterTableViewCell.reuseIdentifier) as! FilterFooterTableViewCell
        return footerCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(HEADER_HEIGHT)
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(FOOTER_HEIGHT)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(CELL_HEIGHT)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if -self.tableTopInset != scrollView.contentOffset.y && scrollView.contentOffset.y < 0 {
            self.tableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
            self.tableView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }
}
