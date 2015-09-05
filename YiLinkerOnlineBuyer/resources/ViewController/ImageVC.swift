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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takePhoto()
        // Do any additional setup after loading the view.
        
        cameraRollButton.layer.cornerRadius = 5.0
        cameraButton.layer.cornerRadius = 5.0
        self.placeCustomBackImage()
        self.placeSendButton()
        
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func placeSendButton(){
        var sendItem = UIBarButtonItem(title : "Send", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("sendImageByFile"))
        
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
            SVProgressHUD.show()
            
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
                    SVProgressHUD.dismiss()
                    self.goBack()
                }) { (task : NSURLSessionDataTask!, error: NSError!) -> Void in
                    if !Reachability.isConnectedToNetwork() {
                        UIAlertController.displayNoInternetConnectionError(self)
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                    }
                    println(error.description)
                    SVProgressHUD.dismiss()
            }

        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Please pick or upload an image first.", title: "Error")
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
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
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
