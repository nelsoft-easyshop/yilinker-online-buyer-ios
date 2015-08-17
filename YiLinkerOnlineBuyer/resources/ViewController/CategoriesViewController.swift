//
//  CategoriesViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var parentLabel: UILabel!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var parentArrowView: UIImageView!
    
    var categoryModel: CategoryModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentLabel.text = "     " + self.parentLabel.text!

        let nib = UINib(nibName: "CategoriesTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "CategoryIdentifier")
        
        requestCategories(parentId: "")
    }

    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.categoryModel != nil {
            return self.categoryModel.name.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CategoriesTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CategoryIdentifier") as! CategoriesTableViewCell
        
        cell.selectionStyle = .None
        
        cell.categoryLabel.text = self.categoryModel!.name[indexPath.row]  
        cell.setPicture(self.categoryModel!.image[indexPath.row])
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if categoryModel.isParent[indexPath.row] {
            let categories = CategoriesViewController(nibName: "CategoriesViewController", bundle: nil)
            categories.requestCategories(parentId: categoryModel.id[indexPath.row])
            self.navigationController?.pushViewController(categories, animated: true)
        } else {
            println("Load List Here")
        }
    }
    
    // MARK: - Request
    
    func requestCategories(#parentId: String) {
        SVProgressHUD.show()
        let manager = APIManager.sharedInstance
        let categoryUrl = "https://demo3526363.mockable.io/getCategories?parentId=1"
        
        manager.GET(categoryUrl, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SVProgressHUD.dismiss()
            self.categoryModel = CategoryModel.parseCategories(responseObject)
            self.tableView.reloadData()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("failed")
                SVProgressHUD.dismiss()
        })
    }

}
