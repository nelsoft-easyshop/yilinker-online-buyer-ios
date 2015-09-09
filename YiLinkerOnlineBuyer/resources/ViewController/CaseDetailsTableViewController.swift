//
//  CaseDetailsTableViewController.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 9/2/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class CaseDetailsTableViewController: UITableViewController {
    @IBOutlet weak var caseID: UILabel!
    @IBOutlet weak var statusCase: UILabel!
    @IBOutlet weak var dateOpen: UILabel!
    @IBOutlet weak var otherParty: UILabel!
    @IBOutlet weak var complainantRemarks: UILabel!
    @IBOutlet weak var complainRemarksView: UIView!
    @IBOutlet weak var complainRemarksCell: UITableViewCell!
    @IBOutlet weak var csrRemarks: UILabel!
    
    var data = ResolutionCenterData("","","","","","")

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Title text in Navigation Bar will now turn WHITE
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        let backButton = UIBarButtonItem(title: "Back", style:.Plain, target: self, action:"goBackButton")
        backButton.image = UIImage(named: "back-white")
        backButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = backButton
        
        // rounded label highlight
        statusCase.clipsToBounds = true
        statusCase.layer.cornerRadius = 13
        
        // make it bigger
        //complainantRemarks.sizeToFit()
        complainRemarksView.sizeToFit()
        //complainRemarksCell.sizeToFit()
        //remarksCell.sizeToFit()
        complainRemarksCell.bounds.size.height = 160//complainantRemarks.bounds.height + 16
        
        displayData()
    }
    
    private func displayData() {
        self.caseID.text = self.data.resolutionId
        self.statusCase.text = self.data.status
        self.dateOpen.text = self.data.date
        self.otherParty.text = self.data.type
        self.complainantRemarks.text = self.data.complainantRemarks
        self.csrRemarks.text = self.data.csrRemarks
    }

    // MARK: Navigation Bar buttons
    func goBackButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func passData(data: ResolutionCenterData) {
        self.data = data
    }
    
}
