//
//  GlobalPreferencesPickerTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 4/14/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol GlobalPreferencesPickerTableViewControllerDelegate {
    func globalPreferencesPickerTableViewController(globalPreferencesPickerTableViewController: GlobalPreferencesPickerTableViewController, country: CountryModel)
    
    func globalPreferencesPickerTableViewController(globalPreferencesPickerTableViewController: GlobalPreferencesPickerTableViewController, language: LanguageModel)
}

enum GlobalPreferencesPickerType {
    case Country
    case Language
}

class GlobalPreferencesPickerTableViewController: UITableViewController {
    
    var delegate: GlobalPreferencesPickerTableViewControllerDelegate?
    
    typealias GlobalPreference = (isSelected: Bool, data: AnyObject)
    
    var tableData: [GlobalPreference] = []
    var type = GlobalPreferencesPickerType.Country
    
    var emptyView: EmptyView?
    var hud: YiHUD?
    
    var selectedCountry = CountryModel()
    var selectedLanguage = LanguageModel()
        
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
            if let temp = self.tableData[indexPath.row].data as? CountryModel {
                cell.setValueText("\(temp.name)")
                cell.setValueImage(temp.flag)
            }
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
        
        if self.type == .Country {
            self.delegate?.globalPreferencesPickerTableViewController(self, country: self.tableData[indexPath.row].data as! CountryModel)
        } else if self.type == .Language{
            self.delegate?.globalPreferencesPickerTableViewController(self, language: self.tableData[indexPath.row].data as! LanguageModel)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - API CALLS
    func fireGetData() {
        self.showLoader()
        
        if self.type == .Country {
            var countryEntities: [CountryEntity] = CountryEntity.findAll() as! [CountryEntity]
            let countryEntity: CountryEntity = countryEntities.first!
            if NSDate().subractDate(countryEntity.dateUpdated) > 1 {
                self.fireGetLanguageData()
            } else {
                let basicModel: BasicModel = BasicModel.parseDataFromResponseObjec(StringHelper.convertStringToDictionary(countryEntity.json))
                
                if basicModel.dataAnyObject.isKindOfClass(NSArray) {
                    var dictionaries: [NSDictionary] = basicModel.dataAnyObject as! [NSDictionary]
                    
                    for dictionary in dictionaries {
                        let model: CountryModel = CountryModel.parseDataFromDictionary(dictionary)
                        if model.isActive {
                            if self.selectedCountry.countryID == model.countryID {
                                self.tableData.append(GlobalPreference(isSelected: true, data: model))
                            } else {
                                self.tableData.append(GlobalPreference(isSelected: false, data: model))
                            }
                        }
                    }
                }
                self.tableView.reloadData()
                self.dismissLoader()
            }
        } else if self.type == .Language {
            var languageEntities: [LanguageEntity] = LanguageEntity.findAll() as! [LanguageEntity]
            
            if languageEntities.count == 0 {
                self.fireGetLanguageData()
            } else{
                let languageEntity: LanguageEntity = languageEntities.first!
                if NSDate().subractDate(languageEntity.dateUpdated) > 1 {
                    self.fireGetLanguageData()
                } else {
                    let basicModel: BasicModel = BasicModel.parseDataFromResponseObjec(StringHelper.convertStringToDictionary(languageEntity.json))
                    
                    if basicModel.dataAnyObject.isKindOfClass(NSArray) {
                        var dictionaries: [NSDictionary] = basicModel.dataAnyObject as! [NSDictionary]
                        
                        for dictionary in dictionaries {
                            let model: LanguageModel = LanguageModel.pareseDataFromResponseObject(dictionary)
                            if self.selectedLanguage.languageId == model.languageId {
                                self.tableData.append(GlobalPreference(isSelected: true, data: model))
                            } else {
                                self.tableData.append(GlobalPreference(isSelected: false, data: model))
                            }
                        }
                    }
                    self.tableView.reloadData()
                    self.dismissLoader()
                }
            }
        }
    }
    
    func fireGetLanguageData() {
        WebServiceManager.fireGetLanguagesWithUrl(APIAtlas.getLanguages, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            self.dismissLoader()
            
            if successful {
                self.saveLanguagesToCoreData(responseObject)
                if let response = responseObject as? NSDictionary {
                    if let data = response["data"] as? NSArray {
                        self.tableData.removeAll(keepCapacity: false)
                        
                        for obj in data {
                            if let temp = obj as? NSDictionary {
                                if self.selectedLanguage.languageId == LanguageModel.pareseDataFromResponseObject(temp).languageId {
                                    self.tableData.append(GlobalPreference(isSelected: true, data: LanguageModel.pareseDataFromResponseObject(temp)))
                                } else {
                                    self.tableData.append(GlobalPreference(isSelected: false, data: LanguageModel.pareseDataFromResponseObject(temp)))
                                }
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
    
    //MARK: -
    //MARK: - Save Countries to Core Data
    func saveLanguagesToCoreData(responseObject: AnyObject) {
        var languageEntities: [LanguageEntity] = LanguageEntity.findAll() as! [LanguageEntity]
        
        if languageEntities.count == 0 {
            let languageEntity: LanguageEntity = LanguageEntity.createEntity() as! LanguageEntity
            languageEntity.json = StringHelper.convertDictionaryToJsonString(responseObject as! NSDictionary) as String
            languageEntity.dateUpdated = NSDate()
            languageEntities.append(languageEntity)
            NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
        } else{
            let languageEntity: LanguageEntity = languageEntities.first!
            if NSDate().subractDate(languageEntity.dateUpdated) > 1 {
                languageEntity.json = StringHelper.convertDictionaryToJsonString(responseObject as! NSDictionary) as String
                languageEntities.append(languageEntity)
                languageEntity.dateUpdated = NSDate()
                NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
            }
        }
    }

    
    func fireGetCountriesAPICall() {
        WebServiceManager.fireGetCountries(APIAtlas.getCountriesUrl, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                //save json data to core data
                self.saveCountriesToCoreData(responseObject)
                
                let basicModel: BasicModel = BasicModel.parseDataFromResponseObjec(responseObject)
                
                if basicModel.dataAnyObject.isKindOfClass(NSArray) {
                    var dictionaries: [NSDictionary] = basicModel.dataAnyObject as! [NSDictionary]
                    
                    for dictionary in dictionaries {
                        let model: CountryModel = CountryModel.parseDataFromDictionary(dictionary)
                        if model.isActive {
                            if self.selectedCountry.countryID == model.countryID {
                                self.tableData.append(GlobalPreference(isSelected: true, data: model))
                            } else {
                                self.tableData.append(GlobalPreference(isSelected: false, data: model))
                            }
                        }
                    }
                }
                self.tableView.reloadData()
                self.dismissLoader()
            }
        })
    }
    
    //MARK: -
    //MARK: - Save Countries to Core Data
    func saveCountriesToCoreData(responseObject: AnyObject) {
        var countryEntities: [CountryEntity] = CountryEntity.findAll() as! [CountryEntity]
        
        if countryEntities.count == 0 {
            let countryEntity: CountryEntity = CountryEntity.createEntity() as! CountryEntity
            countryEntity.json = StringHelper.convertDictionaryToJsonString(responseObject as! NSDictionary) as String
            countryEntity.dateUpdated = NSDate()
            countryEntities.append(countryEntity)
            NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
        } else{
            let countryEntity: CountryEntity = countryEntities.first!
            if NSDate().subractDate(countryEntity.dateUpdated) > 1 {
                countryEntity.json = StringHelper.convertDictionaryToJsonString(responseObject as! NSDictionary) as String
                countryEntities.append(countryEntity)
                countryEntity.dateUpdated = NSDate()
                NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
            }
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
