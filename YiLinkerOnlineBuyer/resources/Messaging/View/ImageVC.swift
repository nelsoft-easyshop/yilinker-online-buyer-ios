//
//  ImageVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/9/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol ImageVCDelegate{
    func sendMessage(url : String)
}

class ImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cameraRollButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    var newMedia : Bool?
    
    var sender : W_Contact?
    var recipient : W_Contact?
    
    var imageVCDelegate : ImageVCDelegate?
    
    var hud : MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        takePhoto()
        */
        // Do any additional setup after loading the view.
        
        cameraButton.titleLabel?.text = LocalizedStrings.camera
        cameraRollButton.titleLabel?.text = LocalizedStrings.cameraRoll
        cameraRollButton.layer.cornerRadius = 5.0
        cameraButton.layer.cornerRadius = 5.0
        self.placeCustomBackImage()
        self.placeSendButton()
        
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func placeSendButton(){
        var sendItem = UIBarButtonItem(title : LocalizedStrings.send, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("sendImageByFile"))
        
        sendItem.tintColor = UIColor.whiteColor()
        
        self.navigationItem.setRightBarButtonItem(sendItem, animated: true)
    }
    
    func placeCustomBackImage(){
        var backImage = UIImage(named: "left.png")
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 12.0, height: 24.0), false, 0.0)
        backImage?.drawInRect(CGRectMake(0, 0, 12, 24))
        
        var tempImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var backItem = UIBarButtonItem(image: tempImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goBack"))
        
        self.navigationItem.setLeftBarButtonItem(backItem, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraClicked(sender: UIButton) {
        takePhoto()
    }
    
    func sendImageByFile(){
        if (imageView.image != nil){
            
            if (Reachability.isConnectedToNetwork()) {
                //SVProgressHUD.show()
                self.showHUD()
                
                let manager: APIManager = APIManager.sharedInstance
                manager.requestSerializer = AFHTTPRequestSerializer()
                
                let parameters: NSDictionary = [
                    "access_token"  : SessionManager.accessToken()
                    ]   as Dictionary<String, String>
                
                let url = APIAtlas.baseUrl + APIAtlas.ACTION_IMAGE_ATTACH + "?access_token=\(SessionManager.accessToken())"
                
                var imageData : NSData = UIImageJPEGRepresentation(imageView.image, 1)
                var sequence = DateUtility.convertDateToString(NSDate())
                //println(parameters)
                manager.POST(url, parameters: parameters, constructingBodyWithBlock: { (data: AFMultipartFormData) -> Void in
                    data.appendPartWithFileData(imageData, name: "image", fileName: "image_\(self.recipient?.userId)_\(self.sender?.userId)_\(sequence)", mimeType: "image/JPEG")
                    }, success: { (task : NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                        self.imageVCDelegate?.sendMessage(W_Messages.parseUploadImageResponse(responseObject))
                        self.hud?.hide(true)
                        //SVProgressHUD.dismiss()
                        self.goBack()
                    }) { (task : NSURLSessionDataTask!, error: NSError!) -> Void in
                        let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                        
                        if task.statusCode == 401 {
                            if (SessionManager.isLoggedIn()){
                                self.fireRefreshToken()
                            }
                        } else {
                            
                            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "\(LocalizedStrings.errorMessage) (\(error.description))", title: LocalizedStrings.errorTitle)
                        }
                        
                        println(error.description)
                        self.hud?.hide(true)
                        //SVProgressHUD.dismiss()
                }
            } else {
                self.showAlert(LocalizedStrings.connectionUnreachableTitle, message: LocalizedStrings.connectionUnreachableMessage)
            }
            
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: LocalizedStrings.pickImageFirst, title: LocalizedStrings.errorTitle)
        }
        
    }
    
    func fireRefreshToken() {
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        self.showHUD()
        let parameters: NSDictionary = ["client_id": Constants.Credentials.clientID(), "client_secret": Constants.Credentials.clientSecret(), "grant_type": Constants.Credentials.grantRefreshToken, "refresh_token":  SessionManager.refreshToken()]
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: LocalizedStrings.errorMessage, title: LocalizedStrings.errorTitle)
        })
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: LocalizedStrings.ok, style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    func takePhoto(){
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = true
        }
    }
    
    @IBAction func cameraRollClicked(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = false
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        if (mediaType == (kUTTypeImage as! String)) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            imageView.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: LocalizedStrings.saveFailed,
                message: LocalizedStrings.saveFailedMessage,
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: LocalizedStrings.ok,
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
}
