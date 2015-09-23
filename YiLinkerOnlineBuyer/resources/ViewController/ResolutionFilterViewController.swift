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
    
    func getStatusFilter() -> String {
        switch status {
        case .Open:
            return "1"
        case .Closed:
            return "2"
        default:
            return "0"
        }
    }
    
    func isDefault() -> Bool {
        return self.time == .Total && self.status == .Both
    }
    
    func getTimeFilter() -> String {
        let formatter = NSDateFormatter()
        let now = NSDate()
        formatter.dateFormat = "MM/dd/YYYY"
        switch time {
        case .Today:
            return formatter.stringFromDate(now)
        case .ThisWeek:
            return formatter.stringFromDate(NSDate())
        case .ThisMonth:
            let oneMonth: NSTimeInterval = 60*60*24*30
            let lastMonth = now.dateByAddingTimeInterval(-oneMonth)
            return formatter.stringFromDate(lastMonth)
        case .Total:
            return ""
        default:
            return ""
        }
    }
    
    func getTimeNow() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        let now = NSDate()
        return formatter.stringFromDate(now)
    }
    
    func getSundayDate() -> String {
        let day: Int = self.dayOfWeek(self.getTimeNow())
        return self.getFromDateWeek(day)
    }
    
    func dayOfWeek(today:String) -> Int {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        let todayDate = formatter.dateFromString(today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: todayDate)
        let weekDay = myComponents.weekday
        return weekDay
    }
    
    func getFromDateWeek(numberOfDays: Int) -> String {
        let userCalendar = NSCalendar.currentCalendar()
        let sundayDate = userCalendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: -numberOfDays, toDate: NSDate(), options: nil)!
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        return formatter.stringFromDate(sundayDate)
    }
}

struct FilterStrings {
    static let title = StringHelper.localizedStringWithKey("FILTER_TITLE_LOCALIZE_KEY")
    static let dates = StringHelper.localizedStringWithKey("FILTER_DATES_LOCALIZE_KEY")
    static let today = StringHelper.localizedStringWithKey("FILTER_TODAY_LOCALIZE_KEY")
    static let week = StringHelper.localizedStringWithKey("FILTER_WEEK_LOCALIZE_KEY")
    static let month = StringHelper.localizedStringWithKey("FILTER_MONTH_LOCALIZE_KEY")
    static let total = StringHelper.localizedStringWithKey("FILTER_TOTAL_LOCALIZE_KEY")
    static let status = StringHelper.localizedStringWithKey("FILTER_STATUS_LOCALIZE_KEY")
    static let open = StringHelper.localizedStringWithKey("FILTER_OPEN_LOCALIZE_KEY")
    static let closed = StringHelper.localizedStringWithKey("FILTER_CLOSE_LOCALIZE_KEY")
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
    
//    @IBOutlet weak var dateSection: UITableViewSection!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
//    @IBOutlet weak var statusSection: UITableViewSection!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closedLabel: UILabel!
    
    
    private var timeFilter: ResolutionTimeFilter = .Total
    private var statusFilter: ResolutionStatusFilter = .Both
    //weak var currentFilter: SelectedFilters?
    var delegate: ResolutionCenterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // White title text
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        
        cancel.tintColor = UIColor.whiteColor()
        cancel.target = self
        cancel.action = "cancelPressed"
        
        save.tintColor = UIColor.whiteColor()
        save.target = self
        save.action = "savePressed"
        
        self.timeFilter = self.delegate!.currentSelectedFilter.time
        selectTimeFilter(self.timeFilter)
        self.statusFilter = self.delegate!.currentSelectedFilter.status
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
        
        setStrings()
    }
    
    func setStrings() {
        self.title = FilterStrings.title
        
        todayLabel.text = FilterStrings.today
        weekLabel.text = FilterStrings.week
        monthLabel.text = FilterStrings.month
        totalLabel.text = FilterStrings.total
        
        openLabel.text = FilterStrings.open
        closedLabel.text = FilterStrings.closed
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
    
    // MARK - Cancel & Save
    func cancelPressed() {
        //self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func savePressed() {
        self.delegate!.currentSelectedFilter.time = self.timeFilter
        self.delegate!.currentSelectedFilter.status = self.statusFilter
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate!.applyFilter()
    }
    
}
