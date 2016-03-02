//
//  MyPointsTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-Seller. All rights reserved.
//

import UIKit

class MyPointsTableViewController: UITableViewController, PointsBreakdownTableViewCellDelegate {
    let cellPointsEarned: String = "PointsEarnedTableViewCell"
    let cellPointsDetails: String = "PointsDetailsTableViewCell"
    let cellPointsBreakDownHeader: String = "PointsBreakdownTableViewCell"
    let cellPoints: String = "PointsTableViewCell"
    
    var hud: MBProgressHUD?
    
    var totalPointsModel: TotalPointsModel = TotalPointsModel(isSuccessful: false, message: "", data: "0")
    var myPointsHistory: MyPointsHistoryModel = MyPointsHistoryModel(isSuccessful: false, message: "", data: [])
    
    var isMyPointsEnd: Bool = false
    var myPointsPage: Int = 1
    var getCtr: Int = 0
    
    var errorLocalizeString: String  = ""
    var somethingWrongLocalizeString: String = ""
    var connectionLocalizeString: String = ""
    var connectionMessageLocalizeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
        initializeLocalizedString()
        titleView()
        backButton()
        registerNibs()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        myPointsPage = 0
        getCtr = 0
        fireGetTotalPoints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        somethingWrongLocalizeString = StringHelper.localizedStringWithKey("SOMETHING_WENT_WRONG_LOCALIZE_KEY")
        connectionLocalizeString = StringHelper.localizedStringWithKey("CONNECTION_UNREACHABLE_LOCALIZE_KEY")
        connectionMessageLocalizeString = StringHelper.localizedStringWithKey("CONNECTION_ERROR_MESSAGE_LOCALIZE_KEY")
    }
    
    func initializeViews() {
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
    
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150.0

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        var headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 1))
        headerView.backgroundColor = UIColor(red: 70/255, green: 35/255, blue: 103/255, alpha: 1)
        
        self.tableView.tableHeaderView = headerView
    }
    
    func titleView() {
        self.title = StringHelper.localizedStringWithKey("MY_POINTS_TITLE_LOCALIZE_KEY")
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
    
    func registerNibs() {
        var nibEarned = UINib(nibName: cellPointsEarned, bundle: nil)
        self.tableView.registerNib(nibEarned, forCellReuseIdentifier: cellPointsEarned)
        
        var nibDetails = UINib(nibName: cellPointsDetails, bundle: nil)
        self.tableView.registerNib(nibDetails, forCellReuseIdentifier: cellPointsDetails)
        
        var nibHeader = UINib(nibName: cellPointsBreakDownHeader, bundle: nil)
        self.tableView.registerNib(nibHeader, forCellReuseIdentifier: cellPointsBreakDownHeader)
        
        var nibPoints = UINib(nibName: cellPoints, bundle: nil)
        self.tableView.registerNib(nibPoints, forCellReuseIdentifier: cellPoints)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if getCtr == 0 {
            return 0
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if myPointsHistory.data.count != 0 {
        
            return myPointsHistory.data.count + 3
//        } else {
//            return 0
//        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellPointsEarned, forIndexPath: indexPath) as! PointsEarnedTableViewCell
            if totalPointsModel.data.formatToTwoDecimalNoTrailling() == ".00" {
                cell.pointsLabel.text = "0\(totalPointsModel.data.formatToTwoDecimalNoTrailling())"
            } else {
                cell.pointsLabel.text = "\(totalPointsModel.data.formatToTwoDecimalNoTrailling())"
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellPointsDetails, forIndexPath: indexPath) as! PointsDetailsTableViewCell
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellPointsBreakDownHeader, forIndexPath: indexPath) as! PointsBreakdownTableViewCell
            cell.delegate = self
            
            if myPointsHistory.data.count == 0 {
//                cell.breakDownView.hidden = true
                cell.breakDownLabel.text = ""
            } else {
                cell.breakDownView.hidden = false
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellPoints, forIndexPath: indexPath) as! PointsTableViewCell
            
            println("Index \(indexPath.row)")
            println("Count \(myPointsHistory.data.count)")
            
            let tempModel: MyPointsModel = myPointsHistory.data[indexPath.row - 3]
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.s6"
            let date: NSDate = dateFormatter.dateFromString(tempModel.date)!
            
            let dateFormatter1 = NSDateFormatter()
            dateFormatter1.dateFormat = "MMM dd, yyyy"
            let dateAdded = dateFormatter1.stringFromDate(date)
            
            
            cell.dateLabel.text = dateAdded
            cell.detailsLabel.text = tempModel.userPointTypeName
        
            var points: String = tempModel.points
            
            if Array(tempModel.points)[0] != "-" {
                points = "+\(tempModel.points)"
            }
            
            if points.rangeOfString("+") != nil {
                cell.pointsLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1.0)
                cell.pointsTitleLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1.0)
            } else {
                cell.pointsLabel.textColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1.0)
                cell.pointsTitleLabel.textColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 0.75)
            }
            
            if points.toInt() < 1 {
                if Array(tempModel.points)[0] != "-" {
                    cell.pointsLabel.text = "+0" + points.formatToTwoDecimalNoTrailling()
                } else {
                    cell.pointsLabel.text = "-0" + points.formatToTwoDecimalNoTrailling()
                }
            } else {
                if Array(tempModel.points)[0] != "-" {
                    cell.pointsLabel.text = "+" + points.formatToTwoDecimalNoTrailling()
                } else {
                    cell.pointsLabel.text = "-" + points.formatToTwoDecimalNoTrailling()
                }
            }
            
            return cell
        }
    }
    
    override func scrollViewDidEndDragging(aScrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset: CGPoint = aScrollView.contentOffset
        var bounds: CGRect = aScrollView.bounds
        var size: CGSize = aScrollView.contentSize
        var inset: UIEdgeInsets = aScrollView.contentInset
        var y: CGFloat = offset.y + bounds.size.height - inset.bottom
        var h: CGFloat = size.height
        var reload_distance: CGFloat = 10
        var temp: CGFloat = h + reload_distance
        if y > temp {
            fireGetPointsHistory()
        }
    }
    
    // MARK: - PointsBreakdownTableViewCellDelegate
    // Callback when how to earned points button is clicked
    func howToEarnActionForIndex(sender: AnyObject) {
        
    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
    }

    
    func fireGetTotalPoints() {
        showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        manager.GET(APIAtlas.getPointsTotal, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.totalPointsModel = TotalPointsModel.parseDataWithDictionary(responseObject as! NSDictionary)
            
            if self.totalPointsModel.isSuccessful {
                self.fireGetPointsHistory()
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.totalPointsModel.message, title: self.errorLocalizeString)
            }
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken("totalPoints")
                } else {
                    if Reachability.isConnectedToNetwork() {
                        UIAlertController.displaySomethingWentWrongError(self)
                    } else {
                        UIAlertController.displayNoInternetConnectionError(self)
                    }
                    println(error)
                }
                
                
        })
    }
    
    func fireGetPointsHistory() {
        if !isMyPointsEnd {
            
            showHUD()
            let manager = APIManager.sharedInstance

            myPointsPage++
            
            let url: String = "\(APIAtlas.getPointsHistory)?access_token=\(SessionManager.accessToken())&perPage=15&page=\(myPointsPage)"
            
            manager.GET(url, parameters: nil, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
    
                self.getCtr++
                //self.myPointsHistory = MyPointsHistoryModel.parseDataWithDictionary(responseObject as! NSDictionary)
                
                let pointHistory: MyPointsHistoryModel = MyPointsHistoryModel.parseDataWithDictionary(responseObject as! NSDictionary)
                println("Count 1 \(self.myPointsHistory.data.count)")
                
                if pointHistory.data.count < 15 {
                    self.isMyPointsEnd = true
                }
                
                if self.totalPointsModel.isSuccessful {
                    self.myPointsHistory.data += pointHistory.data
                    self.tableView.reloadData()
                } else {
                    self.isMyPointsEnd = true
                    self.tableView.reloadData()
                }
                self.hud?.hide(true)
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                    self.hud?.hide(true)
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.fireRefreshToken("pointsHistory")
                    } else {
                        if Reachability.isConnectedToNetwork() {
                            UIAlertController.displaySomethingWentWrongError(self)
                        } else {
                            UIAlertController.displayNoInternetConnectionError(self)
                        }
                        println(error)
                    }
            })
        } else {
            self.hud?.hide(true)
            if self.myPointsHistory.data.count != 0 {
                let noMoreString = StringHelper.localizedStringWithKey("NO_MORE_DATA_LOCALIZE_KEY")
                let myPointsString = StringHelper.localizedStringWithKey("MY_POINTS_TITLE_LOCALIZE_KEY")
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: noMoreString, title: myPointsString)
            }
        }

    }
    
    func fireRefreshToken(type: String) {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            if successful {
                if type == "totalPoints" {
                    self.fireGetTotalPoints()
                } else if type == "pointsHistory" {
                    self.fireGetPointsHistory()
                }
            } else {
                //Show UIAlert and force the user to logout
                self.hud?.hide(true)
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logoutWithTarget(self)
                })
            }
        })
    }
}
