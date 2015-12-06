//
//  EditProfileTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit
import CoreLocation

class EditProfileTableViewController: UITableViewController, UINavigationControllerDelegate, EditProfileAddPhotoTableViewCellDelegate, EditProfileAddressTableViewCellDelegate, EditProfileAccountInformationTableViewCellDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, EditProfilePersonalInformationTableViewCellDelegate, ChangePasswordViewControllerDelegate, ChangeAddressViewControllerDelegate, ChangeMobileNumberViewControllerDelegate, VerifyMobileNumberViewControllerDelegate, VerifyMobileNumberStatusViewControllerDelegate, ViewImageViewControllerDelegate, CLLocationManagerDelegate {
    
    let manager = APIManager.sharedInstance
    
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
    
    var profileUserDetailsModel: ProfileUserDetailsModel!
    
    var firstName: String = ""
    var lastName: String = ""
    var mobileNumber: String = ""
    var emailAddress: String = ""
    var password: String = ""
    var latitude: String = ""
    var longitude: String = ""
    
    var profileImageData: NSData?
    var validIDImageData: NSData?
    
    var dimView: UIView?
    
    var hud: MBProgressHUD?
    
    var profileImage: UIImage?
    var validIDImage: UIImage?
    var isForProfilePicture: Bool = false
    
    var errorLocalizeString: String  = ""
    var somethingWrongLocalizeString: String = ""
    var connectionLocalizeString: String = ""
    var connectionMessageLocalizeString: String = ""
    
    var editPhotoLocalizeString: String  = ""
    var addPhotoLocalizeString: String  = ""
    var selectPhotoLocalizeString: String  = ""
    var takePhotoLocalizeString: String  = ""
    var cancelLocalizeString: String  = ""
    //var locationManager: CLLocationManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
        initializeLocalizedString()
        backButton()
        titleView()
        registerNibs()
    }
    
    override func viewDidAppear(animated: Bool) {
//        let locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
        self.tableView.reloadData()
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
        
        dimView = UIView(frame: self.view.bounds)
        dimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController?.view.addSubview(dimView!)
        //self.view.addSubview(dimView!)
        dimView?.hidden = true
        dimView?.alpha = 0
    
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        somethingWrongLocalizeString = StringHelper.localizedStringWithKey("SOMETHINGWENTWRONG_LOCALIZE_KEY")
        connectionLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONUNREACHABLE_LOCALIZE_KEY")
        connectionMessageLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONERRORMESSAGE_LOCALIZE_KEY")
        
        editPhotoLocalizeString = StringHelper.localizedStringWithKey("EDITPHOTO_LOCALIZE_KEY")
        addPhotoLocalizeString = StringHelper.localizedStringWithKey("ADDPHOTO_LOCALIZE_KEY")
        selectPhotoLocalizeString = StringHelper.localizedStringWithKey("SELECTPHOTO_LOCALIZE_KEY")
        takePhotoLocalizeString = StringHelper.localizedStringWithKey("TAKEPHOTO_LOCALIZE_KEY")
        
        cancelLocalizeString = StringHelper.localizedStringWithKey("CANCEL_LOCALIZE_KEY")
    }
    
    func passModel(profileModel: ProfileUserDetailsModel){
        profileUserDetailsModel = profileModel
        firstName = profileModel.firstName
        lastName = profileModel.lastName
        mobileNumber = profileModel.contactNumber
        emailAddress = profileModel.email
    }
    
    func titleView() {
        var editProfileLocalizeString = StringHelper.localizedStringWithKey("EDITPROFILE_LOCALIZE_KEY")
        self.title = editProfileLocalizeString
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
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let var location: CLLocation = locations.last as? CLLocation {
            latitude = "\(location.coordinate.latitude)"
            longitude = "\(location.coordinate.longitude)"
        }
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
            
            cell.profileImageView.sd_setImageWithURL(NSURL(string: profileUserDetailsModel.profileImageUrl), placeholderImage: UIImage(named: "dummy-placeholder"))
            
            if profileUserDetailsModel.profileImageUrl.isNotEmpty() {
                cell.profileImageView.hidden = false
                cell.addPhotoLabel.text = editPhotoLocalizeString
            } else {
                cell.addPhotoLabel.text = addPhotoLocalizeString
            }
            
            if profileImage != nil {
                cell.profileImageView.image = profileImage
            }
            
            photoIndexPath = indexPath
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(personalInfoCellIdentifier, forIndexPath: indexPath) as! EditProfilePersonalInformationTableViewCell
            cell.firstNameTextField.text = profileUserDetailsModel.firstName
            cell.lastNameTextField.text = profileUserDetailsModel.lastName
            cell.mobilePhoneTextField.text = profileUserDetailsModel.contactNumber
        
            if profileUserDetailsModel.userDocuments.isEmpty  {
                cell.addIDButton.setTitle(cell.addLocalizeString, forState: UIControlState.Normal)
                cell.viewImageConstraint.constant = 0
            } else {
                cell.addIDButton.setTitle(cell.changeLocalizeString, forState: UIControlState.Normal)
                cell.viewImageConstraint.constant = 75
            }
            
            cell.delegate = self
            personalIndexPath = indexPath
            
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(addressCellIdentifier, forIndexPath: indexPath) as! EditProfileAddressTableViewCell
            cell.delegate = self
            addressIndexPath = indexPath
            cell.addressLabel.text = profileUserDetailsModel.address.fullLocation
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(accountCellIdentifier, forIndexPath: indexPath) as! EditProfileAccountInformationTableViewCell
            cell.delegate = self
            accountIndexPath = indexPath
            cell.emailAddressTextField.text = profileUserDetailsModel.email
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else if indexPath.row == 1 {
            return 200
        }  else if indexPath.row == 2 {
            return 145
        } else {
            return 270
        }
    }
    
    // MARK: - EditProfileAddPhotoTableViewCellDelegate
    func addPhotoAction(sender: AnyObject) {
        isForProfilePicture = true
        openImageActionSheet()
    }
    
    
    // MARK: - ViewImageViewControllerDelegate
    func dismissViewImageViewController() {
        hideDimView()
    }
    
    func openImageActionSheet(){
        if( controllerAvailable()){
            handleIOS8()
        } else {
            var actionSheet:UIActionSheet
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
                actionSheet = UIActionSheet(title: addPhotoLocalizeString, delegate: self, cancelButtonTitle: cancelLocalizeString, destructiveButtonTitle: nil,otherButtonTitles: selectPhotoLocalizeString, takePhotoLocalizeString)
            } else {
                actionSheet = UIActionSheet(title: addPhotoLocalizeString, delegate: self, cancelButtonTitle: cancelLocalizeString, destructiveButtonTitle: nil,otherButtonTitles: selectPhotoLocalizeString)
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
        let alert = UIAlertController(title: addPhotoLocalizeString, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let libButton = UIAlertAction(title: selectPhotoLocalizeString, style: UIAlertActionStyle.Default) { (alert) -> Void in
            imageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imageController, animated: true, completion: nil)
        }
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title:takePhotoLocalizeString, style: UIAlertActionStyle.Default) { (alert) -> Void in
                imageController.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(imageController, animated: true, completion: nil)
                
            }
            alert.addAction(cameraButton)
        } else {
            
        }
        let cancelButton = UIAlertAction(title: cancelLocalizeString, style: UIAlertActionStyle.Cancel) { (alert) -> Void in
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if isForProfilePicture {
            addPhotoCell = self.tableView.cellForRowAtIndexPath(photoIndexPath!) as? EditProfileAddPhotoTableViewCell
            
            addPhotoCell!.profileImageView.hidden = false
            addPhotoCell!.profileImageView.image = image
            addPhotoCell!.addPhotoLabel.text = editPhotoLocalizeString
            
            profileImage = image
            profileImageData = self.resizeIfNeeded(image, imageData: UIImageJPEGRepresentation(image, 0.25))
        } else {
            validIDImage = image
            if image.imageOrientation == UIImageOrientation.Right {
                validIDImageData = self.resizeIfNeeded(image.normalizedImage(), imageData: UIImageJPEGRepresentation(image.normalizedImage(), 0.25))
            } else {
                validIDImageData = self.resizeIfNeeded(image, imageData: UIImageJPEGRepresentation(image, 0.25))
            }
            
            profileUserDetailsModel.userDocuments = " "
            personalInfoCell = self.tableView.cellForRowAtIndexPath(personalIndexPath!) as? EditProfilePersonalInformationTableViewCell
            personalInfoCell?.addIDButton.setTitle(personalInfoCell?.changeLocalizeString, forState: UIControlState.Normal)
            personalInfoCell?.viewImageConstraint.constant = 75
        }
    }
    
    func resizeIfNeeded(image: UIImage, imageData:NSData) -> NSData {
        if (Double)(imageData.length / 1024) > 100 {
            return UIImageJPEGRepresentation(image.normalizedImage().resize(0.25), 0.25)
        } else {
            return imageData
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
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
        let changeAddressViewController: ChangeAddressViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        changeAddressViewController.delegate = self
        self.navigationController!.pushViewController(changeAddressViewController, animated: true)
    }
    
    // MARK: ChangeAddressViewControllerDelegate
    func changeAddressViewController(didSelectAddress address: String) {
        profileUserDetailsModel.address.fullLocation = address

        var indexPath = NSIndexPath(forRow: 2, inSection: 0)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }
    
    
    // Hide Keyboard
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - EditProfilePersonalInformationTableViewCellDelegate
    func passPersonalInformation(firstName: String, lastName: String, mobileNumber: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.mobileNumber = mobileNumber
        
        profileUserDetailsModel.firstName = firstName
        profileUserDetailsModel.lastName = lastName
        profileUserDetailsModel.contactNumber = mobileNumber
    }
    
    func changeMobileNumberAction(){
        var changeNumberModal = ChangeMobileNumberViewController(nibName: "ChangeMobileNumberViewController", bundle: nil)
        changeNumberModal.mobileNumber = profileUserDetailsModel.contactNumber
        changeNumberModal.delegate = self
        if SessionManager.mobileNumber().isEmpty {
            changeNumberModal.isFromCheckout = true
        }
        
        changeNumberModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        changeNumberModal.providesPresentationContextTransitionStyle = true
        changeNumberModal.definesPresentationContext = true
        changeNumberModal.view.backgroundColor = UIColor.clearColor()
        changeNumberModal.view.frame.origin.y = 0
        self.tabBarController?.presentViewController(changeNumberModal, animated: true, completion: nil)
        
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }
    
    func addValidIDAction() {
        isForProfilePicture = false
        openImageActionSheet()
    }
    
    func viewImageAction() {
        if validIDImageData != nil || !profileUserDetailsModel.userDocuments.isEmpty {
            var viewImageModal = ViewImageViewController(nibName: "ViewImageViewController", bundle: nil)
            viewImageModal.delegate = self
            if validIDImage != nil {
                viewImageModal.image = validIDImage
            } else {
                viewImageModal.url = profileUserDetailsModel.userDocuments
            }
            viewImageModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            viewImageModal.providesPresentationContextTransitionStyle = true
            viewImageModal.definesPresentationContext = true
            viewImageModal.view.backgroundColor = UIColor.clearColor()
            viewImageModal.view.frame.origin.y = 0
            self.tabBarController?.presentViewController(viewImageModal, animated: true, completion: nil)
            
            self.dimView!.hidden = false
            UIView.animateWithDuration(0.3, animations: {
                self.dimView!.alpha = 1
                }, completion: { finished in
            })
        }
    }
    
    // MARK: - ChangeMobileNumberViewControllerDelegate
    func closeChangeNumbderViewController(){
        hideDimView()
    }
    
    func submitChangeNumberViewController(){
        var verifyNumberModal = VerifyMobileNumberViewController(nibName: "VerifyMobileNumberViewController", bundle: nil)
        verifyNumberModal.delegate = self
        verifyNumberModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        verifyNumberModal.providesPresentationContextTransitionStyle = true
        verifyNumberModal.definesPresentationContext = true
        verifyNumberModal.view.backgroundColor = UIColor.clearColor()
        verifyNumberModal.view.frame.origin.y = 0
        self.tabBarController?.presentViewController(verifyNumberModal, animated: true, completion: nil)
        
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }
    
    // MARK: - VerifyMobileNumberViewControllerDelegate
    func closeVerifyMobileNumberViewController() {
        hideDimView()
    }
    
    func verifyMobileNumberAction(isSuccessful: Bool) {
        var verifyStatusModal = VerifyMobileNumberStatusViewController(nibName: "VerifyMobileNumberStatusViewController", bundle: nil)
        verifyStatusModal.delegate = self
        verifyStatusModal.isSuccessful = isSuccessful
        verifyStatusModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        verifyStatusModal.providesPresentationContextTransitionStyle = true
        verifyStatusModal.definesPresentationContext = true
        verifyStatusModal.view.backgroundColor = UIColor.clearColor()
        verifyStatusModal.view.frame.origin.y = 0
        self.tabBarController?.presentViewController(verifyStatusModal, animated: true, completion: nil)
        
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }
    
    func requestNewCodeAction() {
        submitChangeNumberViewController()
    }
    
    // MARK: - VerifyMobileNumberStatusViewControllerDelegate
    func closeVerifyMobileNumberStatusViewController() {
        hideDimView()
    }
    
    func continueVerifyMobileNumberAction(isSuccessful: Bool) {
        hideDimView()
    }
    
    func requestNewVerificationCodeAction() {
        submitChangeNumberViewController()
    }
    
    func getNewMobileNumber() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newMobileNumber") as? String {
            result = val as! String
        }
        return result
    }
    
    
    // MARK: - ChangePasswordViewControllerDelegate
    func closeChangePasswordViewController(){
        hideDimView()
    }
    
    func submitChangePasswordViewController(){
        hideDimView()
        var changeLocalizeString = StringHelper.localizedStringWithKey("CHANGEPASSWORD_LOCALIZE_KEY")
        var successLocalizeString = StringHelper.localizedStringWithKey("SUCCESSCHANGEPASSWORD_LOCALIZE_KEY")
        self.showAlert(changeLocalizeString, message: successLocalizeString)
    }
    
    func hideDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 0
            }, completion: { finished in
                self.dimView!.hidden = true
        })
    }
    
    // MARK: - EditProfileAccountInformationTableViewCellDelegate
    func saveAction(sender: AnyObject) {
        println("saveAction")
        
        var errorMessage: String = ""
        
    
        if firstName.isEmpty {
            errorMessage = "First name is required."
        } else if !firstName.isValidName() {
            errorMessage = "First name contains illegal characters. It can only contain letters, numbers and underscores."
        } else if lastName.isEmpty {
            errorMessage = "Last name is required."
        } else if !lastName.isValidName() {
            errorMessage = "Last name contains illegal characters. It can only contain letters, numbers and underscores."
        } //        } else if emailAddress.isNotEmpty() {
//            errorMessage = "Email is required."
//        } else if emailAddress.isValidEmail() {
//            errorMessage = "The email address you enter is not a valid email address."
//        } else if password.isNotEmpty() {
//            errorMessage = "Password is required."
//        } else if password.isAlphaNumeric() {
//            errorMessage = "Password contains illegal characters. It can only contain letters, numbers and underscores."
//        }
        
        if errorMessage != "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorMessage)
        } else {
            if Reachability.isConnectedToNetwork(){
                if profileImageData != nil || validIDImageData != nil{
                    var params: NSDictionary = [
                        "firstName": firstName as String,
                        "lastName": lastName as String,
                        "latitude": latitude,
                        "longitude": longitude]
                    
                    fireUpdateProfile(APIAtlas.editProfileUrl + "?access_token=" + SessionManager.accessToken(), params: params, withImage: true)
                } else {
                    var params: NSDictionary = [
                        "firstName": firstName as String,
                        "lastName": lastName as String,
                        "latitude": latitude,
                        "longitude": longitude,
                        "profilePhoto": profileUserDetailsModel.profileImageUrl as String,
                        "userDocument": profileUserDetailsModel.profileImageUrl as String]
                    
                    fireUpdateProfile(APIAtlas.editProfileUrl + "?access_token=" + SessionManager.accessToken(), params: params, withImage: false)
                }
            }
            else {
                showAlert(self.connectionLocalizeString, message: self.connectionMessageLocalizeString)
            }
        }
            
    }
    
    func editPasswordAction() {
        var editPasswordModal = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
        editPasswordModal.delegate = self
        editPasswordModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        editPasswordModal.providesPresentationContextTransitionStyle = true
        editPasswordModal.definesPresentationContext = true
        editPasswordModal.view.backgroundColor = UIColor.clearColor()
        editPasswordModal.view.frame.origin.y = 0
        self.tabBarController?.presentViewController(editPasswordModal, animated: true, completion: nil)
        
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }
    
    
    func fireUpdateProfile(url: String, params: NSDictionary!, withImage: Bool) {
        showLoader()
        if withImage {
            manager.POST(url, parameters: params, constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                if self.profileImageData != nil {
                    data.appendPartWithFileData(self.profileImageData!, name: "profilePhoto", fileName: "photo", mimeType: "image/jpeg")
                }
                
                if self.validIDImageData != nil {
                    data.appendPartWithFileData(self.validIDImageData!, name: "userDocument", fileName: "photo", mimeType: "image/jpeg")
                }
                //println(self.validIDImageData.length / 1024.0 / 1024.0)
                }, success: {
                    (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
                    
                    if responseObject.objectForKey("error") != nil {
                        self.requestRefreshToken("updateProfile", url: url, params: params, withImage: withImage)
                    }
                    
                    self.fireGetUserInfo()
                    
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    self.dismissLoader()
                    self.showAlert(self.errorLocalizeString, message: self.somethingWrongLocalizeString)
                    println(error)
            })
        } else {
            manager.POST(url, parameters: params, success: {
                    (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
                    if responseObject.objectForKey("error") != nil {
                        self.requestRefreshToken("updateProfile", url: url, params: params, withImage: withImage)
                    }
                    self.dismissLoader()
                    var changeLocalizeString = StringHelper.localizedStringWithKey("SUCCESS_LOCALIZE_KEY")
                    var successLocalizeString = StringHelper.localizedStringWithKey("SUCCESSUPDATEPROFILE_LOCALIZE_KEY")
                    self.showAlert(changeLocalizeString, message: successLocalizeString)
                
                    println(responseObject)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    self.showAlert(self.errorLocalizeString, message: self.somethingWrongLocalizeString)
                    self.dismissLoader()
                    println(error)
            })
        }
        
    }
    
    //Loader function
    func showLoader() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    func dismissLoader() {
        self.hud?.hide(true)
    }
    
    func requestRefreshToken(type: String, url: String, params: NSDictionary!, withImage: Bool) {
        let url: String = APIAtlas.refreshTokenUrl
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
            manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SVProgressHUD.dismiss()
            
            if (responseObject["isSuccessful"] as! Bool) {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                if type == "updateProfile" {
                    self.fireUpdateProfile(url, params: params, withImage: withImage)
                } else {
                    self.fireGetUserInfo()
                }
            } else {
                self.showAlert(self.errorLocalizeString, message: responseObject["message"] as! String)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                self.showAlert(self.errorLocalizeString, message: self.somethingWrongLocalizeString)
        })
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        var okLocalizeString = StringHelper.localizedStringWithKey("OKBUTTON_LOCALIZE_KEY")
        let OKAction = UIAlertAction(title: okLocalizeString, style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    //MARK: - Getting User Info
    func fireGetUserInfo() {
        let manager: APIManager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken()]
        manager.POST(APIAtlas.getUserInfoUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            let dictionary: NSDictionary = responseObject as! NSDictionary
            let profileModel: ProfileUserDetailsModel = ProfileUserDetailsModel.parseDataWithDictionary(dictionary["data"]!)
            //Insert Data to Session Manager
            SessionManager.setFullAddress(profileModel.address.fullLocation)
            SessionManager.setUserFullName(profileModel.fullName)
            SessionManager.setAddressId(profileModel.address.userAddressId)
            SessionManager.setCartCount(profileModel.cartCount)
            SessionManager.setWishlistCount(profileModel.wishlistCount)
            SessionManager.setProfileImage(profileModel.profileImageUrl)
            self.dismissLoader()
            
            var changeLocalizeString = StringHelper.localizedStringWithKey("SUCCESS_LOCALIZE_KEY")
            var successLocalizeString = StringHelper.localizedStringWithKey("SUCCESSUPDATEPROFILE_LOCALIZE_KEY")
            self.showAlert(changeLocalizeString, message: successLocalizeString)
            self.profileImageData = nil
            self.profileImage = nil
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.requestRefreshToken("userInfo", url: APIAtlas.getUserInfoUrl, params: nil, withImage: false)
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: HomeStrings.somethingWentWrong, title: HomeStrings.error)
                }
                
                self.hud?.hide(true)
        })
    }
}
