//
//  ResolutionFilterViewController.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ResolutionFilterViewController: UITableViewController {
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var buttonToday: CheckBox!
    @IBOutlet weak var buttonThisWeek: CheckBox!
    @IBOutlet weak var buttonThisMonth: CheckBox!
    @IBOutlet weak var buttonTotal: CheckBox!
    @IBOutlet weak var buttonOpen: CheckBox!
    @IBOutlet weak var buttonClosed: CheckBox!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // White title text
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black

        cancel.tintColor = UIColor.whiteColor()
        cancel.target = self
        cancel.action = "cancelViewController"
        
        save.tintColor = UIColor.whiteColor()
        save.target = self
        save.action = "cancelViewController"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    func cancelViewController() {
        //self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
