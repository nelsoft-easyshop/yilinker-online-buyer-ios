//
//  SearchBarView.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 3/3/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

enum SearchType {
    case Seller
    case Buyer
}


protocol SearchBarViewDelegate {
    func searchBarView(searchBarView: SearchBarView, didTapScanQRCode button: UIButton)
    func searchBarView(searchBarView: SearchBarView, didTapProfile button: UIButton)
    func searchBarView(searchBarView: SearchBarView, didTextChanged textField: UITextField)
    func searchBarView(searchBarView: SearchBarView, didSeacrhTypeChanged searchType: SearchType)
}

class SearchBarView: UIView {
    
    var delegate: SearchBarViewDelegate?
    
    var parentView: UIView?
    var topBarView: UIView?

    @IBOutlet weak var scanQRButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchTypeView: UIView!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var searchTypeImageView: UIImageView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var searchTypeTableView: UITableView?
    var isSearchTypeHidden: Bool = true
    var searchTypeImage: [String] = ["product-icon", "seller-icon"]
    var searchTypeText: [String] = ["Product", "Seller"]
    
    var searchAutoCompleteTableView: UITableView?
    var isAutoCompleteHidden: Bool = true
    
    var searchSuggestions: [SearchSuggestionModel] = [SearchSuggestionModel(suggestion: "Suggestion1", imageURL: "", searchUrl: ""), SearchSuggestionModel(suggestion: "Suggestion2", imageURL: "", searchUrl: ""), SearchSuggestionModel(suggestion: "Suggestion2", imageURL: "", searchUrl: "")]
    
    //MARK: -
    //MARK: - Awake Form Nib
    override func awakeFromNib() {
        
    }
    
    //MARK: -
    //MARK: - Init SearchBar
    class func initSearchBar() -> SearchBarView {
        let searchBar: SearchBarView = XibHelper.puffViewWithNibName("SearchBarView", index: 0) as! SearchBarView
        return searchBar
    }
    
    //MARK: -
    //MARK: - Show Hud To View
    func showSearchBarToView(view: UIView, mainView: UIView) {
        self.parentView = mainView
        self.topBarView = view
        
        self.searchView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        self.searchView.layer.cornerRadius = 15
        self.searchTypeView.layer.cornerRadius = 15
        self.searchTextField.layer.cornerRadius = 15
        
        self.dropDownView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        
        var tap = UITapGestureRecognizer(target:self, action:"searchTypeAction")
        self.searchTypeView.addGestureRecognizer(tap)
        
        var isAdded: Bool = false
        
        for subView in view.subviews {
            if subView.isKindOfClass(SearchBarView) {
                isAdded = true
                break
            }
        }
        
        self.layer.zPosition = 1000
        
        if !isAdded {
            view.addSubview(self)
        }
        
        view.layoutIfNeeded()
    }
    
    //MARK: -
    //MARK: - IBActions
    @IBAction func buttonAction(sender: UIButton) {
        if sender == self.scanQRButton {
            self.delegate?.searchBarView(self, didTapScanQRCode: sender)
            self.hideSearchTypePicker()
            self.hideAutoComplete()
        } else if sender == self.profileButton {
            self.delegate?.searchBarView(self, didTapProfile: sender)
            self.hideSearchTypePicker()
            self.hideAutoComplete()
            searchSuggestions.removeAtIndex(0)
        }
    }
    
    @IBAction func textFieldAction(sender: AnyObject) {
        self.delegate?.searchBarView(self, didTextChanged: self.searchTextField)
        if count(self.searchTextField.text) > 2 {
            self.showAutoComplete()
        } else {
            self.hideAutoComplete()
        }
        
    }
    
    //MARK: -
    //MARK: - Other Functions
    func searchTypeAction() {
        if self.isSearchTypeHidden {
            self.showSearchTypePicker()
        } else {
            self.hideSearchTypePicker()
        }
        
    }
    
    //MARK: - Aniamate Search Type Picker
    func animateView(view: UIView, show: Bool) {
        if show {
            UIView.animateWithDuration(0.3, animations: {
                view.alpha = 1
            })
        } else {
            UIView.animateWithDuration(0.3, animations: {
                view.alpha = 0
            })
        }
    }
    
    func applyPlainShadow(view: UIView) {
        view.layer.shadowColor = UIColor.darkGrayColor().CGColor
        view.layer.shadowOffset = CGSizeMake(0, 5)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 1.0
    }
    
    //MARK: - Show activity Indicator
    func showLoader() {
        self.activityIndicator.startAnimating()
    }
    
    //MARK: - Hide activity Indicator
    func hideLoader() {
        self.activityIndicator.stopAnimating()
    }
    
    //MARK: - Show Search Type Picker
    func showSearchTypePicker() {
        self.isSearchTypeHidden = false
        self.hideAutoComplete()
        if self.searchTypeTableView == nil {
            self.searchTypeTableView = UITableView(frame: CGRectMake(self.searchView.frame.origin.x, self.topBarView!.frame.origin.y + self.frame.size.height - 5, 90, 60))
            self.searchTypeTableView!.layer.cornerRadius = 10
            self.searchTypeTableView!.alpha = 0
            self.applyPlainShadow(self.searchTypeTableView!)
            
            var nib = UINib(nibName: "SearchTypeTableViewCell", bundle: nil)
            self.searchTypeTableView!.registerNib(nib, forCellReuseIdentifier: "SearchTypeTableViewCell")
            
            self.searchTypeTableView!.delegate = self
            self.searchTypeTableView!.dataSource = self
            
            
            self.parentView?.addSubview(self.searchTypeTableView!)
            self.parentView?.layoutIfNeeded()
            self.animateView(self.searchTypeTableView!, show: true)
        } else {
            self.animateView(self.searchTypeTableView!, show: true)
        }
    }
    
    //MARK: - Hide Search Type Picker
    func hideSearchTypePicker() {
        self.isSearchTypeHidden = true
        if self.searchTypeTableView != nil {
            self.animateView(self.searchTypeTableView!, show: false)
        }
    }
    
    //MARK: - Show Auto Complete
    func showAutoComplete() {
        self.hideSearchTypePicker()
        self.isAutoCompleteHidden = false
        if self.searchAutoCompleteTableView == nil {
            self.searchAutoCompleteTableView = UITableView(frame: CGRectMake(self.searchView.frame.origin.x + self.searchTypeView.frame.width + 10, self.topBarView!.frame.origin.y + self.frame.size.height - 5, self.searchTextField.frame.width + 20, CGFloat(self.searchSuggestions.count * 30)))
            self.searchAutoCompleteTableView!.layer.cornerRadius = 10
            self.searchAutoCompleteTableView!.alpha = 0
            self.applyPlainShadow(self.searchAutoCompleteTableView!)
            
            var nib = UINib(nibName: "SearchTypeTableViewCell", bundle: nil)
            self.searchAutoCompleteTableView!.registerNib(nib, forCellReuseIdentifier: "SearchTypeTableViewCell")
            
            self.searchAutoCompleteTableView!.delegate = self
            self.searchAutoCompleteTableView!.dataSource = self
            
            
            self.parentView?.addSubview(self.searchAutoCompleteTableView!)
            self.parentView?.layoutIfNeeded()
            self.animateView(self.searchAutoCompleteTableView!, show: true)
        } else {
            self.searchAutoCompleteTableView!.frame = CGRectMake(self.searchAutoCompleteTableView!.frame.origin.x, self.searchAutoCompleteTableView!.frame.origin.y, self.searchAutoCompleteTableView!.frame.width, CGFloat(self.searchSuggestions.count * 30))
             self.parentView?.layoutIfNeeded()
            self.animateView(self.searchAutoCompleteTableView!, show: true)
        }
    }
    
    //MARK: - Hide Search Type Picker
    func hideAutoComplete() {
        self.isAutoCompleteHidden = true
        if self.searchAutoCompleteTableView != nil {
            self.animateView(self.searchAutoCompleteTableView!, show: false)
        }
    }
}

//MARK: -
//MARK: - Tableview Delegate and Data Source
extension SearchBarView: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchTypeTableView {
            return self.searchTypeText.count
        } else {
            return self.searchSuggestions.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.searchTypeTableView {
            var cell: SearchTypeTableViewCell = self.searchTypeTableView!.dequeueReusableCellWithIdentifier("SearchTypeTableViewCell") as! SearchTypeTableViewCell
            cell.iconImageView.image = UIImage(named: self.searchTypeImage[indexPath.row])
            cell.typeLabel.text = self.searchTypeText[indexPath.row]
            
            return cell
        } else {
            var cell: SearchTypeTableViewCell = self.searchAutoCompleteTableView!.dequeueReusableCellWithIdentifier("SearchTypeTableViewCell") as! SearchTypeTableViewCell
            cell.hideIcon()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == self.searchTypeTableView {
            self.hideSearchTypePicker()
            self.searchTypeImageView.image = UIImage(named: self.searchTypeImage[indexPath.row])
        }
    }
}