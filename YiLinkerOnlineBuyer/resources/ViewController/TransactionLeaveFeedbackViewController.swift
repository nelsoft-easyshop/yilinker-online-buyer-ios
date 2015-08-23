//
//  TransactionLeaveFeedbackViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionLeaveFeedbackViewController: UIViewController {

    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    
    @IBOutlet weak var typingAreaView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    
    var rateButtons: [UIButton] = []
    var rate: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rateButtons = [star1Button, star2Button, star3Button, star4Button, star5Button]
        self.title = "Feedback"
        
        self.typingAreaView.layer.borderWidth = 1.0
        self.typingAreaView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.inputTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func rate1Action(sender: AnyObject) {
        updateRate(1)
    }
    
    @IBAction func rate2Action(sender: AnyObject) {
        updateRate(2)
    }
    
    @IBAction func rate3Action(sender: AnyObject) {
        updateRate(3)
    }
    
    @IBAction func rate4Action(sender: AnyObject) {
        updateRate(4)
    }

    @IBAction func rate5Action(sender: AnyObject) {
        updateRate(5)
    }

    @IBAction func sendAction(sender: AnyObject) {
        if rate == 0 {
            showAlert("Rate", message: "Please select a rating.")
        } else if self.inputTextField.text == "" {
            showAlert("Feedback", message: "Please send a feedback.")
        } else {
            navigationController?.popViewControllerAnimated(true)
//            showAlert(String(rate), message: self.inputTextField.text)
        }
        
    }
    
    // MARK: - Methods
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func updateRate(index: Int) {
        self.rate = index
        
        for i in 0..<5 {
            
            if i < index {
                self.rateButtons[i].setImage(UIImage(named: "rating2"), forState: .Normal)
            } else {
                self.rateButtons[i].setImage(UIImage(named: "rating"), forState: .Normal)
            }
            
            
            self.rateButtons[i].frame.size = CGSize(width: 35, height: 30)
        }
    }
}
