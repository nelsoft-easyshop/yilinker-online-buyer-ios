//
//  SellerCategoryViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/10/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SellerCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var categoryTableView: UITableView!
    
    var sellerCategory: SellerCategoryModel?
    var tableData: [SellerCategoryModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleView()
        self.backButton()
        self.registerNib()
        self.categoryTableView.delegate = self
        self.categoryTableView.dataSource = self
        self.categoryTableView.separatorInset = UIEdgeInsetsZero
        self.categoryTableView.layoutMargins = UIEdgeInsetsZero
        self.categoryTableView.backgroundColor = UIColor.clearColor()
        self.categoryTableView.estimatedRowHeight = 112.0
        self.categoryTableView.rowHeight = UITableViewAutomaticDimension
        let footerView: UIView = UIView(frame: CGRectZero)
        self.categoryTableView.tableFooterView = footerView
        self.fireSellerCategory()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Customize navigation bar look
    func titleView() {
        let label: UILabel = UILabel(frame: CGRectMake(0, 0, 100, 50))
        label.text = "Choose Category"
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
        let categoryNib: UINib = UINib(nibName: "SellerCategoryTableViewCell", bundle: nil)
        self.categoryTableView.registerNib(categoryNib, forCellReuseIdentifier: "SellerCategoryTableViewCell")
        
    }
    
    //MARK: Tableview delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.tableData.isEmpty {
            return self.tableData.count
        } else {
           return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let categoryTableViewCell: SellerCategoryTableViewCell = self.categoryTableView.dequeueReusableCellWithIdentifier("SellerCategoryTableViewCell") as! SellerCategoryTableViewCell
            if !self.tableData.isEmpty {
                categoryTableViewCell.categoryLabel.text = self.tableData[indexPath.row].categoryName
                categoryTableViewCell.categoryDescriptionLabel.text = self.tableData[indexPath.row].categorySubs
            }
            return categoryTableViewCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sellerSubCategoryViewController: SellerSubCategoryViewController = SellerSubCategoryViewController(nibName: "SellerSubCategoryViewController", bundle: nil)
        self.navigationController!.pushViewController(sellerSubCategoryViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
        return 93
        
    }
    
    func fireSellerCategory() {
        let manager = APIManager.sharedInstance
        //let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        println(APIAtlas.sellerCategory+"1")
        manager.GET(APIAtlas.sellerCategory+"\(1)", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.sellerCategory = SellerCategoryModel.parseDataFromDictionary(responseObject as! NSDictionary)
            
            for var i: Int = 0; i < self.sellerCategory!.name.count; i++ {
                self.tableData.append(SellerCategoryModel(name: self.sellerCategory!.name[i], subCategories: self.sellerCategory!.subCategories2[i]))
            }
            self.categoryTableView.reloadData()
            
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
        })

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
