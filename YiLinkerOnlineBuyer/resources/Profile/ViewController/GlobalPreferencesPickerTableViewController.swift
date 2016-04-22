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
    
    typealias GlobalPreference = (isSelected: Bool, data: AnyObject)
    
    var tableData: [GlobalPreference] = []
    var type = GlobalPreferencesPickerType.Country
    
    var emptyView: EmptyView?
    var hud: YiHUD?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViews()
        self.registerNibs()
        self.addBackButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.emptyView != nil {
            self.emptyView?.hidden = true
        }
        
        self.fireGetData()
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
        
        if self.type == .Country {
            
        } else if self.type == .Language {
            if let temp = self.tableData[indexPath.row].data as? LanguageModel {
                cell.setValueText("\(temp.name) (\(temp.code.uppercaseString))")
            }
        }
        
        cell.setIsChecked(self.tableData[indexPath.row].isSelected)
        cell.setType(self.type)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        for var i = 0; i < self.tableData.count; i++ {
            self.tableData[i].isSelected = false
        }
        
        self.tableData[indexPath.row].isSelected = true
        self.tableView.reloadData()
    }
    
    // MARK: - API CALLS
    func fireGetData() {
        self.showLoader()
        
        if self.type == .Country {
            
        } else if self.type == .Language {
            WebServiceManager.fireGetLanguagesWithUrl(APIAtlas.getLanguages, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                
                self.dismissLoader()
                
                if successful {
                    if let response = responseObject as? NSDictionary {
                        if let data = response["data"] as? NSArray {
                            self.tableData.removeAll(keepCapacity: false)
                            
                            for obj in data {
                                if let temp = obj as? NSDictionary {
                                    self.tableData.append(GlobalPreference(isSelected: false, data: LanguageModel.pareseDataFromResponseObject(temp)))
                                }
                            }
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    self.addEmptyView()
                }
            })
        }
    }
    
    
    // MARK: - Functions
    func addEmptyView() {
        if self.emptyView == nil {
            self.tableData.removeAll(keepCapacity: false)
            self.tableView.reloadData()
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView?.frame = self.view.frame
            self.emptyView!.delegate = self
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
        }
    }
    
    // MARK: - Loader function
    func showLoader() {
        self.hud = YiHUD.initHud()
        self.hud?.showHUDToView(self.view)
        self.view.userInteractionEnabled = false
    }
    
    func dismissLoader() {
        self.hud?.hide()
        self.view.userInteractionEnabled = true
    }
}

// MARK: - EmptyView Delegate
extension GlobalPreferencesPickerTableViewController: EmptyViewDelegate {
    func didTapReload() {
        self.emptyView?.hidden = true
        self.fireGetData()
    }
}
