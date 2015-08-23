//
//  AddAddressVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/22/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class AddStoreDetailVC: UIViewController {

    struct StoreDetail {
        static let BANK = "Bank"
        static let ADDRESS = "Address"
    }
    
    var mode : String = ""

    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeSubLabel: UILabel!
    
    @IBOutlet weak var detail1Label: UILabel!
    @IBOutlet weak var detail2Label: UILabel!
    @IBOutlet weak var detail3Label: UILabel!
    @IBOutlet weak var detail4Label: UILabel!
    
    @IBOutlet weak var detail1TF: UITextField!
    @IBOutlet weak var detail2TF: UITextField!
    @IBOutlet weak var detail3TF: UITextField!
    @IBOutlet weak var detail4TF: UITextField!
    
    var detail = Dictionary<String, String>()
    
    @IBAction func onClose(sender: UIButton) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCreate(sender: RoundedButtonLight) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (mode == StoreDetail.BANK) {
            typeImage.image = UIImage(named: "bankAccount.png")
            typeLabel.text = "Create a New Bank Account"
            typeSubLabel.text = "Enter your new bank details below"
            detail1Label.text = "Account Title:"
            detail2Label.text = "Account No:"
            detail3Label.text = "Account Name:"
            detail4Label.text = "Bank Name:"
            detail1TF.placeholder = "I.E. Savings Account, Shop Account"
        } else if (mode == StoreDetail.ADDRESS){
            typeImage.image = UIImage(named: "address.png")
            typeLabel.text = "Create a New Bank Account"
            typeSubLabel.text = "Enter your new address details below"
            detail1Label.text = "Address Title:"
            detail2Label.text = "Address Line 1:"
            detail3Label.text = "Address Line 2:"
            detail4Label.text = "Additional Info:"
            detail4TF.placeholder = "I.E. infront of tall building"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
