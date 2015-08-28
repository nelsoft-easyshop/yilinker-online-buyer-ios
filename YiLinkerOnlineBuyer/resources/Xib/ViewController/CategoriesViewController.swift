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

    var categoryModel: CategoryModel!
    
    var parentText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "CategoriesTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "CategoryIdentifier")
        
        requestCategories(parentId: "")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return sectionHeaderView()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if categoryModel.isParent[indexPath.row] {
            let categories = CategoriesViewController(nibName: "CategoriesViewController", bundle: nil)
            categories.parentText = categoryModel.name[indexPath.row]
            categories.requestCategories(parentId: categoryModel.id[indexPath.row])
            self.navigationController?.pushViewController(categories, animated: true)
        } else {
            gotoList(UIGestureRecognizer())
        }
    }
    
    // Methods
    
    func sectionHeaderView() -> UIView {
        var containerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        containerView.backgroundColor = .whiteColor()
        
        var categoryLabel = UILabel(frame: CGRectZero)
        categoryLabel.font = UIFont.boldSystemFontOfSize(15.0)
        categoryLabel.textColor = .darkGrayColor()
        categoryLabel.text = "    "
     
        if parentText == "" {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)
            categoryLabel.text! += "Select Category"
            categoryLabel.sizeToFit()
            categoryLabel.frame.size.height = containerView.frame.size.height
        } else {
            var tap = UITapGestureRecognizer()
            tap.numberOfTapsRequired = 1
            tap.addTarget(self, action: "gotoList:")
            containerView.addGestureRecognizer(tap)
            
            categoryLabel.text! += parentText
            categoryLabel.sizeToFit()
            categoryLabel.frame.size.height = containerView.frame.size.height
            var arrowImageView = UIImageView(frame: CGRectMake(categoryLabel.frame.size.width + 5, (categoryLabel.frame.size.height / 2) - (20 / 2), 12, 20))
            arrowImageView.image = UIImage(named: "right-gray")
            containerView.addSubview(arrowImageView)
        }
        
        var separatorView = UIView(frame: CGRectMake(0, containerView.frame.size.height - 1, containerView.frame.size.width, 1))
        separatorView.backgroundColor = .lightGrayColor()
        
        containerView.addSubview(categoryLabel)
        containerView.addSubview(separatorView)
        
        return containerView
    }
    
    func gotoList(gesture: UIGestureRecognizer) {
        let resultList = ResultViewController(nibName: "ResultViewController", bundle: nil)
        self.navigationController?.pushViewController(resultList, animated: true)
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
            
            if self.tableView != nil {
                self.tableView.reloadData()
            }
        
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("failed")
                SVProgressHUD.dismiss()
        })
    }

}
