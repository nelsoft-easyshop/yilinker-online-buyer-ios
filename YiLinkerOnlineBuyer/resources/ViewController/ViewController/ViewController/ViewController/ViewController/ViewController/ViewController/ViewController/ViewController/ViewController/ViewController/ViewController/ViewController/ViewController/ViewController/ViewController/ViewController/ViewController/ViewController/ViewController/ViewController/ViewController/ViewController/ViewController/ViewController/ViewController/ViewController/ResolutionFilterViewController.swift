//
//  ResolutionFilterViewController.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

enum ResolutionTimeFilter {
    case Today
    case ThisWeek
    case ThisMonth
    case Total
}

enum ResolutionStatusFilter {
    case Open
    case Closed
    case Both
}

class SelectedFilters {
    var time: ResolutionTimeFilter
    var status: ResolutionStatusFilter
    
    init(time: ResolutionTimeFilter, status: ResolutionStatusFilter) {
        self.time = time
        self.status = status
    }
}

class ResolutionFilterViewController: UITableViewController {
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var buttonToday: CheckBox!
    @IBOutlet weak var buttonThisWeek: CheckBox!
    @IBOutlet weak var buttonThisMonth: CheckBox!
    @IBOutlet weak var buttonTotal: CheckBox!
    @IBOutlet weak var buttonOpen: CheckBox!
    @IBOutlet weak var buttonClosed: CheckBox!
    
    private var timeFilter: ResolutionTimeFilter = .Total
    private var statusFilter: ResolutionStatusFilter = .Both
    weak var currentFilter: SelectedFilters?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // White title text
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black

        self.cancel.tintColor = UIColor.whiteColor()
        self.cancel.target = self
        self.cancel.action = "cancelPressed"
        
        self.save.tintColor = UIColor.whiteColor()
        self.save.target = self
        self.save.action = "savePressed"
        
        self.timeFilter = currentFilter!.time
        selectTimeFilter(self.timeFilter)
        self.statusFilter = currentFilter!.status
        selectStatusFilter(self.statusFilter)
        
        self.buttonToday.addTarget(self, action: "todayPressed"
            , forControlEvents:.TouchUpInside)
        self.buttonThisWeek.addTarget(self, action: "thisWeekPressed"
            , forControlEvents:.TouchUpInside)
        self.buttonThisMonth.addTarget(self, action: "thisMonthPressed"
            , forControlEvents:.TouchUpInside)
        self.buttonTotal.addTarget(self, action: "totalPressed"
            , forControlEvents:.TouchUpInside)
        self.buttonOpen.addTarget(self, action: "openPressed"
            , forControlEvents:.TouchUpInside)
        self.buttonClosed.addTarget(self, action: "closedPressed"
            , forControlEvents:.TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Time Filter Checkbox Selection
    private func selectTimeFilter(timeFilterSelection: ResolutionTimeFilter) {
        self.timeFilter = timeFilterSelection
        self.deselectAllTimeCheckBox()
        self.setSelectedTimeCheckBox()
    }
    private func deselectAllTimeCheckBox() {
        self.buttonToday.setUnchecked()
        self.buttonThisWeek.setUnchecked()
        self.buttonThisMonth.setUnchecked()
        self.buttonTotal.setUnchecked()
    }
    private func setSelectedTimeCheckBox() {
        switch(self.timeFilter) {
        case .Today:
            self.buttonToday.setChecked()
        case .ThisWeek:
            self.buttonThisWeek.setChecked()
        case .ThisMonth:
            self.buttonThisMonth.setChecked()
        case .Total:
            self.buttonTotal.setChecked()
        default:
            ()
        }
    }
    func todayPressed() {
        selectTimeFilter(.Today)
    }
    func thisWeekPressed() {
        selectTimeFilter(.ThisWeek)
    }
    func thisMonthPressed() {
        selectTimeFilter(.ThisMonth)
    }
    func totalPressed() {
        selectTimeFilter(.Total)
    }
    // MARK: - Status Filter Checkbox Selection
    private func selectStatusFilter(filterSelection: ResolutionStatusFilter) {
        if self.statusFilter == .Both {
            if filterSelection == .Open {
                self.statusFilter = .Closed
                self.buttonOpen.setUnchecked()
                self.buttonClosed.setChecked()
            } else if filterSelection == .Closed {
                self.statusFilter = .Open
                self.buttonOpen.setChecked()
                self.buttonClosed.setUnchecked()
            } else if filterSelection == .Both {
                self.buttonOpen.setChecked()
                self.buttonClosed.setChecked()
            }
        }
        else if self.statusFilter == .Open && filterSelection == .Closed {
            self.statusFilter = .Both
            self.buttonOpen.setChecked()
            self.buttonClosed.setChecked()
        }
        else if self.statusFilter == .Closed && filterSelection == .Open {
            self.statusFilter = .Both
            self.buttonOpen.setChecked()
            self.buttonClosed.setChecked()
        }
        else if self.statusFilter == .Open {
            self.buttonOpen.setChecked()
            self.buttonClosed.setUnchecked()
        }
        else if self.statusFilter == .Closed {
            self.buttonOpen.setUnchecked()
            self.buttonClosed.setChecked()
        }
    }
    func openPressed() {
        selectStatusFilter(.Open)
    }
    func closedPressed() {
        selectStatusFilter(.Closed)
    }
    func cancelPressed() {
        //self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func savePressed() {
        //self.navigationController?.popViewControllerAnimated(true)
        if currentFilter != nil {
            self.currentFilter!.time = self.timeFilter
            self.currentFilter!.status = self.statusFilter
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
