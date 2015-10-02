//
//  TransactionProductDetailsDescriptionViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 10/1/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol TransactionProductDetailsDescriptionViewControllerDelegate {
    func closeAction()
    func okAction()
}

class TransactionProductDetailsDescriptionViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var longDesctiptionLabel: UILabel!
    @IBOutlet weak var longDescriptionTextView: UITextView!
    
    var delegate: TransactionProductDetailsDescriptionViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.longDesctiptionLabel.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        self.delegate?.closeAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func okAction(sender: AnyObject) {
        self.delegate?.okAction()
        self.dismissViewControllerAnimated(true, completion: nil)
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
