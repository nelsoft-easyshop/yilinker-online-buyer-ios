//
//  TransactionLeaveSellerFeedbackViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionLeaveSellerFeedbackViewController: UIViewController {

    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    
    @IBOutlet weak var starComm1Button: UIButton!
    @IBOutlet weak var starComm2Button: UIButton!
    @IBOutlet weak var starComm3Button: UIButton!
    @IBOutlet weak var starComm4Button: UIButton!
    @IBOutlet weak var starComm5Button: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var rateThisLabel: UILabel!
    @IBOutlet weak var typingAreaView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    
    var rateButtons: [UIButton] = []
    var rateCommButtons: [UIButton] = []
    var rate: Int = 0
    var rateComm: Int = 0
    var sellerId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel:9809088798")!) {
            println("can call")
        } else {
            println("cant make a call")
        }
        
        rateButtons = [star1Button, star2Button, star3Button, star4Button, star5Button]
        rateCommButtons = [starComm1Button, starComm2Button, starComm3Button, starComm4Button, starComm5Button]
        self.title = "Feedback"
        println("\(self.sellerId)")
        
        self.typingAreaView.layer.borderWidth = 1.0
        self.typingAreaView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.inputTextField.becomeFirstResponder()
        var jsonObject = self.rating(5, message: "Message 1", ratingComm: 4, messageComm: "Message 2")
        println("rating sample format \(jsonObject)")
        
        //{"sellerId":"", "orderId":"", "title":"", "feedback":"", "ratings":[{"rateType":"1", "rating":"2.50"},{"rateType":"2", "rating":"4.50"}]}
        let jsonObject2: [String: AnyObject] = [
            "sellerId": 2,
            "orderId": 176,
            "title": "Sample title",
            "feedback": "Sample feedback",
            "ratings": [[
                "ratingType": 1,
                "rating": 5
                ], [
                    "ratingType": 2,
                    "rating": 4
                ]]
        ]
        
        println(jsonObject2)
        
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.transactionLeaveSellerFeedback+"\(SessionManager.accessToken())", parameters: jsonObject2 as NSDictionary, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject.description)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
             println(error.description)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    @IBAction func rateComm1Action(sender: AnyObject) {
        updateCommRate(1)
    }
    
    @IBAction func rateComm2Action(sender: AnyObject) {
        updateCommRate(2)
    }
    
    @IBAction func rateComm3Action(sender: AnyObject) {
        updateCommRate(3)
    }
    
    @IBAction func rateComm4Action(sender: AnyObject) {
        updateCommRate(4)
    }
    
    @IBAction func rateComm5Action(sender: AnyObject) {
        updateCommRate(5)
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
    
    func updateCommRate(index: Int) {
        self.rateComm = index
        
        for i in 0..<5 {
            
            if i < index {
                self.rateCommButtons[i].setImage(UIImage(named: "rating2"), forState: .Normal)
            } else {
                self.rateCommButtons[i].setImage(UIImage(named: "rating"), forState: .Normal)
            }
            
            
            self.rateCommButtons[i].frame.size = CGSize(width: 35, height: 30)
        }
    }
    
    func fireSellerFeedback() {
        
        
    }
    
    //MARK: Format rating to json
    func rating(rating: Int, message: String, ratingComm: Int, messageComm: String) -> [AnyObject]{
        
       // {"sellerId":"", "orderId":"", "title":"", "feedback":"", "ratings":[{"rateType":"1", "rating":"2.50"},{"rateType":"2", "rating":"4.50"}]}
        let jsonObject: [AnyObject]  = [
            [
                "rateType": "1",
                "rating": rating,
                "message": message
            ], [
                "rateType": "2",
                "rating": ratingComm,
                "message": messageComm
            ], ["message" : message]
        ]
        
        return jsonObject
    }

    
}
