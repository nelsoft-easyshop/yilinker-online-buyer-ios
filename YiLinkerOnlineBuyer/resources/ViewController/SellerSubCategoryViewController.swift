//
//  SellerSubCategoryViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/10/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SellerSubCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var subCategoryTableView: UITableView!
    var subCategories: NSArray!
    var subCategories2: NSArray!
    var category: String!
    var subCategoryName: NSArray!
    var sellerSubCategoryModel: SellerSubCategoryModel?
    var sellerCategory: SellerCategoryModel?
    var tableData: [SellerCategoryModel] = []
    var arr: [String] = []
    var arrCategoryId: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var dictCategory:NSDictionary = ["subcategories" : self.subCategoryName]
        if let val: AnyObject = dictCategory["subcategories"] {
            let cat: NSArray = dictCategory["subcategories"] as! NSArray
            println(cat.count)
            for categoryDictionary in cat as! [NSDictionary] {
                self.sellerSubCategoryModel = SellerSubCategoryModel.parseDataFromDictionary(categoryDictionary)
                self.arr.append(self.sellerSubCategoryModel!.name[0])
                self.arrCategoryId.append(self.sellerSubCategoryModel!.categoryId[0])
            }
        }
        
        // Do any additional setup after loading the view.
        self.titleView()
        self.backButton()
        self.registerNib()
        self.subCategoryTableView.delegate = self
        self.subCategoryTableView.dataSource = self
        self.subCategoryTableView.separatorInset = UIEdgeInsetsZero
        self.subCategoryTableView.layoutMargins = UIEdgeInsetsZero
        self.subCategoryTableView.backgroundColor = UIColor.clearColor()
        self.subCategoryTableView.estimatedRowHeight = 112.0
        self.subCategoryTableView.rowHeight = UITableViewAutomaticDimension
        let footerView: UIView = UIView(frame: CGRectZero)
        self.subCategoryTableView.tableFooterView = footerView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Customize navigation bar look
    func titleView() {
        let label: UILabel = UILabel(frame: CGRectMake(0, 0, 100, 50))
        label.text = "Choose Sub-Category"
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = label
    }
    
    func backButton() {
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
    
    //MARK: Register nib
    func registerNib() {
        let categoryNib: UINib = UINib(nibName: "SellerSubCategoryTableViewCell", bundle: nil)
        self.subCategoryTableView.registerNib(categoryNib, forCellReuseIdentifier: "SellerSubCategoryTableViewCell")
        
    }
    
    //MARK: Tableview delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let subCategoryTableViewCell: SellerSubCategoryTableViewCell = self.subCategoryTableView.dequeueReusableCellWithIdentifier("SellerSubCategoryTableViewCell") as! SellerSubCategoryTableViewCell
       
        subCategoryTableViewCell.subCategoryLabel.text = self.arr[indexPath.row]
        return subCategoryTableViewCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let resultViewController: ResultViewController = ResultViewController(nibName: "ResultViewController", bundle: nil)
        resultViewController.categoryName = self.arr[indexPath.row]
        resultViewController.passCategoryID(self.arrCategoryId[indexPath.row])
        self.navigationController!.pushViewController(resultViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
