//
//  ImageVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/9/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit
import MobileCoreServices

class ImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraRollButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    var newMedia : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takePhoto()
        // Do any additional setup after loading the view.
        
        cameraRollButton.layer.cornerRadius = 5.0
        cameraButton.layer.cornerRadius = 5.0
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraClicked(sender: UIButton) {
        takePhoto()
    }
    
    @IBAction func sendImage(sender: UIButton) {
        self.sendImageByFile()
    }
    
    func sendImageByFile(){
        let manager: APIManager = APIManager.sharedInstance
        manager.requestSerializer = AFHTTPRequestSerializer()
        
        let parameters: NSDictionary = [
            "access_token"  : SessionManager.accessToken()
            ]   as Dictionary<String, String>
        
        let url = APIAtlas.baseUrl + APIAtlas.ACTION_SEND_MESSAGE
        
        var imageData : NSData = UIImageJPEGRepresentation(imageView.image, 0.5)
        
        manager.POST(url, parameters: parameters, constructingBodyWithBlock: { (data: AFMultipartFormData) -> Void in
                data.appendPartWithFormData(imageData, name: "image")
            }, success: { (task : NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
            //do something
            }) { (task : NSURLSessionDataTask!, error: NSError!) -> Void in
            //do something
        }
        
        manager.POST(url, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                SVProgressHUD.dismiss()
        })
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
