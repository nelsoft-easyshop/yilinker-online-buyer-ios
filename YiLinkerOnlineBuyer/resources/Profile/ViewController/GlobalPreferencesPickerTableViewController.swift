//
//  GlobalPreferencesPickerTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 4/14/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

enum GlobalPreferencesPickerType {
    case Country
    case Language
}

class GlobalPreferencesPickerTableViewController: UITableViewController {
    
    var tableData: [String] = ["Sample01", "Sample02", "Sample03", "Sample04"]
    var type = GlobalPreferencesPickerType.Country
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViews()
        self.registerNibs()
        self.addBackButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Initializations
    func initializeViews() {
        //Set title of the Navigation Bar
        switch type {
            case .Country :
                self.title = StringHelper.localizedStringWithKey("PROFILE_COUNTRY_PREFERENCE_KEY")
            case .Language:
                self.title =  StringHelper.localizedStringWithKey("PROFILE_LANGUAGE_PREFERENCE_KEY_KEY")
        }
        
        //Avoid overlapping of tab bar and navigation bar to the mainview
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        //Initializes 'tableView' attributes
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    //Add cutomize back button to the navigation bar
    func addBackButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    //Register nibs for the tableView
    func registerNibs() {
        var nibPhoto = UINib(nibName: GlobalPreferencesTableViewCell.reuseIdentifier, bundle: nil)
        self.tableView.registerNib(nibPhoto, forCellReuseIdentifier: GlobalPreferencesTableViewCell.reuseIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(GlobalPreferencesTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! GlobalPreferencesTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        
        cell.setIsChecked(false)
        cell.setValueText(self.tableData[indexPath.row])
        cell.setValueImage("http://grandtuhonsupremo.com/wp-content/uploads/2011/01/Philippines-Flag-icon.png")
        
//        indexPath.row % 2 == 0 ? cell.setType(.Country) : cell.setType(.Language)
        cell.setType(self.type)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
