//
//  SuccessModalViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 2/3/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol SuccessModalViewControllerDelegate {
    func successModalViewController(successModalViewController: SuccessModalViewController, didTapButton doneButton: UIButton)
}

class SuccessModalViewController: UIViewController {

    @IBOutlet weak var circleContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var checkImageView: UIImageView!
    
    var delegate: SuccessModalViewControllerDelegate?
    
    //MARK: -
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.circleContainerView.layer.cornerRadius = self.circleContainerView.frame.size.width / 2
        self.doneButton.layer.cornerRadius = 5
        self.containerView.layer.cornerRadius = 5
        self.checkImageView.layer.zPosition = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 
    //MARK: - Done
    @IBAction func done(sender: UIButton) {
        self.delegate?.successModalViewController(self, didTapButton: sender)
    }
}
