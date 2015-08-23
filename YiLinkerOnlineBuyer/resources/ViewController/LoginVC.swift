//
//  LoginVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/19/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var forgetPassword: UIButton!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.layer.cornerRadius = profileView.frame.size.width/2
        signInButton.layer.cornerRadius = 5.0
        self.tagEmailAsValid(true)
        var user = W_User(full_name: "Test User", user_id: "123", profile_image_url: "www.google.com")
        self.setProfilePicture(user)
    }
    
    func setProfilePicture(user : W_User){
        
        var newFrame = CGRectMake(0, 0, profileView.frame.width, profileView.frame.height)
        
        var profileImageView = UIImageView(frame: newFrame)

        var url = NSURL(string: "google.com")
        profileImageView.sd_setImageWithURL(url)
        if (profileImageView.image == nil){
            profileImageView.image = UIImage(named : "person1.jpg")
        }
        profileImageView.layer.cornerRadius = newFrame.width/2
        profileImageView.layer.masksToBounds = true
        profileView.addSubview(profileImageView)
    }
    
    func tagEmailAsValid(flag : Bool){
        if(flag){
            var validImage = UIImage(named: "valid.png")
            emailAddress.rightViewMode = UITextFieldViewMode.Always
            var imageView = UIImageView(image: validImage)
            emailAddress.rightView = imageView
        } else {
            emailAddress.rightView = nil
        }
        
    }
    
    func tagPasswordAsValid(flag: Bool){
        if(flag){
            var validImage = UIImage(named: "valid.png")
            password.rightViewMode = UITextFieldViewMode.Always
            var imageView = UIImageView(image: validImage)
            password.rightView = imageView
        } else {
            password.rightView = nil
        }
    }

    func changeButtonTitle(){
        signInButton.titleLabel?.text = "SIGNING IN....."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onSignIn(sender: UIButton) {
        self.changeButtonTitle()
    }
    
    @IBAction func forgetPassword(sender: UIButton) {
        
    }
    
}
