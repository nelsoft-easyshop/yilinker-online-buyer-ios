//
//  LoginViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/8/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
   
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    override func viewDidLoad() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            self.returnUserData()
        } else {
            self.facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
            self.facebookButton.delegate = self
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                // Do work
                self.returnUserData()
            }
        }
    
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                println("Error: \(error)")
            } else {
                if let val: AnyObject = result.valueForKey("name") {
                    let userName : NSString = result.valueForKey("name") as! NSString
                    println("fetched user: \(userName)")
                }
                
                if let val: AnyObject = result.valueForKey("id") {
                    let uid : NSString = result.valueForKey("id") as! NSString
                    println("fetched userID: \(uid)")
                }
               
                if let val: AnyObject = result.valueForKey("email") {
                    let email : NSString = result.valueForKey("email") as! NSString
                    println("fetched userID: \(email)")
                } else {
                    println("Email is not available!")
                }
            }
        })
    }
}
