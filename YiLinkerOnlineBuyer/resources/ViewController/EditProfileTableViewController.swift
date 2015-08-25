//
//  EditProfileTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController, UINavigationControllerDelegate, EditProfileAddPhotoTableViewCellDelegate, EditProfileAddressTableViewCellDelegate, EditProfileAccountInformationTableViewCellDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate  {
    
    let addPhotoCellIndetifier: String = "EditProfileAddPhotoTableViewCell"
    let personalInfoCellIdentifier: String = "EditProfilePersonalInformationTableViewCell"
    let addressCellIdentifier: String = "EditProfileAddressTableViewCell"
    let accountCellIdentifier: String = "EditProfileAccountInformationTableViewCell"
    
    var addPhotoCell: EditProfileAddPhotoTableViewCell?
    var personalInfoCell: EditProfilePersonalInformationTableViewCell?
    var addressCell: EditProfileAddressTableViewCell?
    var accountCell: EditProfileAccountInformationTableViewCell?
    
    var photoIndexPath: NSIndexPath?
    var personalIndexPath: NSIndexPath?
    var addressIndexPath: NSIndexPath?
    var accountIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
        backButton()
        titleView()
        registerNibs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeViews() {
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        var tapTableView = UITapGestureRecognizer(target:self, action:"hideKeyboard")
        self.tableView.addGestureRecognizer(tapTableView)
    }
    
    func titleView() {
        self.title = "Edit Profile"
    }
    
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }

    
    func registerNibs() {
        var nibPhoto = UINib(nibName: addPhotoCellIndetifier, bundle: nil)
        self.tableView.registerNib(nibPhoto, forCellReuseIdentifier: addPhotoCellIndetifier)
        
        var nibPersonal = UINib(nibName: personalInfoCellIdentifier, bundle: nil)
        self.tableView.registerNib(nibPersonal, forCellReuseIdentifier: personalInfoCellIdentifier)
        
        var nibAddress = UINib(nibName: addressCellIdentifier, bundle: nil)
        self.tableView.registerNib(nibAddress, forCellReuseIdentifier: addressCellIdentifier)
        
        var nibAccount = UINib(nibName: accountCellIdentifier, bundle: nil)
        self.tableView.registerNib(nibAccount, forCellReuseIdentifier: accountCellIdentifier)
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 4
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(addPhotoCellIndetifier, forIndexPath: indexPath) as! EditProfileAddPhotoTableViewCell
            cell.delegate = self
            
            photoIndexPath = indexPath
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(personalInfoCellIdentifier, forIndexPath: indexPath) as! EditProfilePersonalInformationTableViewCell
            
            personalIndexPath = indexPath
            
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(addressCellIdentifier, forIndexPath: indexPath) as! EditProfileAddressTableViewCell
            cell.delegate = self
            
            addressIndexPath = indexPath
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(accountCellIdentifier, forIndexPath: indexPath) as! EditProfileAccountInformationTableViewCell
            cell.delegate = self
            accountIndexPath = indexPath
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else if indexPath.row == 1 {
            return 175
        }  else if indexPath.row == 2 {
            return 145
        } else {
            return 270
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - EditProfileAddPhotoTableViewCellDelegate
    func addPhotoAction(sender: AnyObject) {
        println("addPhotoAction")
        /* Supports UIAlert Controller */
        if( controllerAvailable()){
            handleIOS8()
        } else {
            var actionSheet:UIActionSheet
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
                actionSheet = UIActionSheet(title: "Add photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil,otherButtonTitles:"Select photo from library", "Take a picture")
            } else {
                actionSheet = UIActionSheet(title: "Add photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil,otherButtonTitles:"Select photo from library")
            }
            actionSheet.delegate = self
            actionSheet.showInView(self.view)
            /* Implement the delegate for actionSheet */
        }
    }
    
    //Method for
    func handleIOS8(){
        let imageController = UIImagePickerController()
        imageController.editing = false
        imageController.delegate = self
        let alert = UIAlertController(title: "Add photo", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let libButton = UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.Default) { (alert) -> Void in
            imageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imageController, animated: true, completion: nil)
        }
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default) { (alert) -> Void in
                println("Take Photo")
                imageController.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(imageController, animated: true, completion: nil)
                
            }
            alert.addAction(cameraButton)
        } else {
            println("Camera not available")
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
            println("Cancel Pressed")
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        addPhotoCell = self.tableView.cellForRowAtIndexPath(photoIndexPath!) as? EditProfileAddPhotoTableViewCell
        
        addPhotoCell!.profileImageView.hidden = false
        addPhotoCell!.profileImageView.image = image
        addPhotoCell!.addPhotoLabel.text = "Edit Photo"
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        println("Title : \(actionSheet.buttonTitleAtIndex(buttonIndex))")
        println("Button Index : \(buttonIndex)")
        let imageController = UIImagePickerController()
        imageController.editing = false
        imageController.delegate = self;
        if buttonIndex == 1 {
            imageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        } else if buttonIndex == 2 {
            imageController.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            
        }
        self.presentViewController(imageController, animated: true, completion: nil)
    }
    
    func controllerAvailable() -> Bool {
        if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
            return true;
        }
        else {
            return false;
        }
    }
    
    // MARK: - EditProfileAddressTableViewCellDelegate
    func changeAddressAction(sender: AnyObject){
        println("changeAddressAction")
        let changeAddressViewController: ChangeAddressViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        self.navigationController!.pushViewController(changeAddressViewController, animated: true)
    }
    
    // Hide Keyboard
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - EditProfileAccountInformationTableViewCellDelegate
    func saveAction(sender: AnyObject) {
        println("saveAction")
        
        var errorMessage: String = ""
        
        addPhotoCell = self.tableView.cellForRowAtIndexPath(photoIndexPath!) as? EditProfileAddPhotoTableViewCell
        personalInfoCell = self.tableView.cellForRowAtIndexPath(personalIndexPath!) as? EditProfilePersonalInformationTableViewCell
        addressCell = self.tableView.cellForRowAtIndexPath(addressIndexPath!) as? EditProfileAddressTableViewCell
        accountCell = self.tableView.cellForRowAtIndexPath(accountIndexPath!) as? EditProfileAccountInformationTableViewCell
        
        let firstName = personalInfoCell?.firstNameTextField.text
        let lastName = personalInfoCell?.lastNameTextField.text
        let mobileNumber = personalInfoCell?.mobilePhoneTextField.text
        let emailAddress = accountCell?.emailAddressTextField.text
        let password = accountCell?.passwordTextField.text
        
        if !firstName!.isNotEmpty() {
            errorMessage = "First name is required."
        } else if !firstName!.isValidName() {
            errorMessage = "First name contains illegal characters. It can only contain letters, numbers and underscores."
        } else if !lastName!.isNotEmpty() {
            errorMessage = "Last name is required."
        } else if !lastName!.isValidName() {
            errorMessage = "Last name contains illegal characters. It can only contain letters, numbers and underscores."
        } else if !emailAddress!.isNotEmpty() {
            errorMessage = "Email is required."
        } else if !emailAddress!.isValidEmail() {
            errorMessage = "The email address you enter is not a valid email address."
        } else if !password!.isNotEmpty() {
            errorMessage = "Password is required."
        } else if !password!.isAlphaNumeric() {
            errorMessage = "Password contains illegal characters. It can only contain letters, numbers and underscores."
        }
        
        if errorMessage != "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorMessage)
        }
    }
}
