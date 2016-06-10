//
//  EditProfileTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

enum EditProfileRequestType {
    case GetUserInfo
    case UpdateProfile
}

struct EditProfileLocalizedStrings {
    static let editProfileLocalizeString = StringHelper.localizedStringWithKey("EDITPROFILE_LOCALIZE_KEY")
    static let editPhotoLocalizeString = StringHelper.localizedStringWithKey("EDITPHOTO_LOCALIZE_KEY")
    static let addPhotoLocalizeString = StringHelper.localizedStringWithKey("ADDPHOTO_LOCALIZE_KEY")
    static let selectPhotoLocalizeString = StringHelper.localizedStringWithKey("SELECTPHOTO_LOCALIZE_KEY")
    static let takePhotoLocalizeString = StringHelper.localizedStringWithKey("TAKEPHOTO_LOCALIZE_KEY")
    static let cancelLocalizeString = StringHelper.localizedStringWithKey("CANCEL_LOCALIZE_KEY")
    static let copiedToClipBoard = StringHelper.localizedStringWithKey("COPY_LOCALIZE_KEY")
    static let successfullyUpdateProfile = StringHelper.localizedStringWithKey("UPDATE_PROF_LOCALIZE_KEY")
}

class EditProfileTableViewController: UITableViewController, UINavigationControllerDelegate {
    
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
    var referrerPersonCode: String = ""
    var country: CountryModel = CountryModel()
    var originalCountry: CountryModel = CountryModel()
    var language: LanguageModel = LanguageModel()
    
    var profileImageData: NSData?
    var validIDImageData: NSData?
    
    var dimView: UIView?
    
    var hud: YiHUD?
    
    var profileImage: UIImage?
    var validIDImage: UIImage?
    var isForProfilePicture: Bool = false
    var isFromQRScanner: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViews()
        self.addBackButton()
        self.registerNibs()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        
        //Set title of the Navigation Bar
        self.title = EditProfileLocalizedStrings.editProfileLocalizeString

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Accepts 'ProfileUserDetailsModel' object from ProfileViewController and set it to the local variables
    func passModel(profileModel: ProfileUserDetailsModel) {
        profileUserDetailsModel = profileModel
        firstName = profileModel.firstName
        lastName = profileModel.lastName
        mobileNumber = profileModel.contactNumber
        emailAddress = profileModel.email
        referrerPersonCode = profileModel.referrerCode
        country = profileModel.country
        originalCountry = profileModel.country
        language = profileModel.language
    }
    
    //MARK: Initializations
    func initializeViews() {
        //Avoid overlapping of tab bar and navigation bar to the mainview
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        //Initializes 'tableView' attributes
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        var tapTableView = UITapGestureRecognizer(target:self, action:"hideKeyboard")
        tapTableView.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapTableView)
        
        //Initializes 'dimView' (backround of the modals) attributes
        self.dimView = UIView(frame: UIScreen.mainScreen().bounds)
        self.dimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController?.view.addSubview(dimView!)
        self.dimView?.hidden = true
        self.dimView?.alpha = 0
    }
    
    //Add cutomize back button to the navigation bar
    func addBackButton() {
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
    
    //Register nibs for the tableView
    func registerNibs() {
        var nibPhoto = UINib(nibName: addPhotoCellIndetifier, bundle: nil)
        self.tableView.registerNib(nibPhoto, forCellReuseIdentifier: addPhotoCellIndetifier)
        
        var nibPersonal = UINib(nibName: personalInfoCellIdentifier, bundle: nil)
        self.tableView.registerNib(nibPersonal, forCellReuseIdentifier: personalInfoCellIdentifier)
        
        var nibAddress = UINib(nibName: addressCellIdentifier, bundle: nil)
        self.tableView.registerNib(nibAddress, forCellReuseIdentifier: addressCellIdentifier)
        
        var nibAccount = UINib(nibName: accountCellIdentifier, bundle: nil)
        self.tableView.registerNib(nibAccount, forCellReuseIdentifier: accountCellIdentifier)
        
        var nibReferralCode: UINib = UINib(nibName: ReferralCodeTableViewCell.nibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(nibReferralCode, forCellReuseIdentifier: ReferralCodeTableViewCell.nibNameAndIdentifier())
    }
    
    //MARK: -
    //MARK: - Table view Data Source and Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    /* Set cell for the tableView and it's contents
    *
    *   First cell  =   EditProfileAddPhotoTableViewCell (Editting of profile image)
    *   Second cell =   EditProfilePersonalInformationTableViewCell (Editting of Firstname, 
    *                   Lastname, Mobile Number, and Identification Photo)
    *   Third cell  =   EditProfileAddressTableViewCell (Editting of address)
    *   Fourt cell  =   EditProfileAccountInformationTableViewCell (Editting of email address and password. 
    *                   It also contains the save button)
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(addPhotoCellIndetifier, forIndexPath: indexPath) as! EditProfileAddPhotoTableViewCell
            cell.delegate = self
            
            cell.profileImageView.sd_setImageWithURL(NSURL(string: profileUserDetailsModel.profileImageUrl), placeholderImage: UIImage(named: "dummy-placeholder"))
            
            if profileUserDetailsModel.profileImageUrl.isNotEmpty() {
                cell.profileImageView.hidden = false
                cell.addPhotoLabel.text = EditProfileLocalizedStrings.editPhotoLocalizeString
            } else {
                cell.addPhotoLabel.text = EditProfileLocalizedStrings.addPhotoLocalizeString
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
            
            cell.languageValueLabel.text = "\(profileUserDetailsModel.language.name) (\(profileUserDetailsModel.language.code.uppercaseString))"
            
            cell.countryFlagImageView.sd_setImageWithURL(NSURL(string: profileUserDetailsModel.country.flag), placeholderImage: UIImage(named: "dummy-placeholder"))
            cell.countryValueLabel.text =  profileUserDetailsModel.country.name
            
            cell.delegate = self
            personalIndexPath = indexPath
            
            return cell
        } else if indexPath.row == 2 {
            return self.referralCodeTableViewCellWithIndexPath(indexPath)
        }  else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier(addressCellIdentifier, forIndexPath: indexPath) as! EditProfileAddressTableViewCell
            cell.delegate = self
            addressIndexPath = indexPath
            cell.addressLabel.text = profileUserDetailsModel.address.fullLocation
            
            if profileUserDetailsModel.address.fullLocation.isEmpty {
                cell.changeAddressButton.setTitle(StringHelper.localizedStringWithKey("ADD_NEW_ADDRESS_LOCALIZE_KEY"), forState: .Normal)
            }
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
            return 310
        } else if indexPath.row == 2 {
            return 180
        }  else if indexPath.row == 3 {
            return 145
        } else {
            return 270
        }
    }
    
    //MARK: - API Requests
    //MARK: - Fire Get User Info
    
    /* Function to request get user information data.
    *
    * If the API request is successful, it will call the 'fireGetUserInfo()' function
    * to update the values in the 'SessionManager'
    *
    * If the API request is unsuccessful, it will check 'requestErrorType'
    * and proceed/do some actions based on the error type
    */

    func fireUpdateProfile(hasImage: Bool, firstName: String, lastName: String, profilePhoto: NSData? = nil, userDocument: NSData? = nil, referrerPersonCode: String, countryId: Int, languageId: Int) {
        self.showLoader()
        let url: String = APIAtlas.editProfileUrl
        
        WebServiceManager.fireUpdateProfileWithUrl(url, hasImage: hasImage, accessToken: SessionManager.accessToken(), firstName: firstName, lastName: lastName, profilePhoto: profilePhoto, userDocument: userDocument, referrerPersonCode: self.referrerPersonCode, countryId: countryId, languageId: languageId, actionHandler:  { (successful, responseObject, requestErrorType) -> Void in
            
            self.dismissLoader()
            if successful {
                SessionManager.setReferrerCode(self.referrerPersonCode)
                SessionManager.setSelectedCountryCode(self.country.code)
                SessionManager.setSelectedLanguageCode(self.language.code)
                Toast.displayToastWithMessage(EditProfileLocalizedStrings.successfullyUpdateProfile, duration: 2.0, view: self.navigationController!.view)
                
                if self.originalCountry.code == self.country.code {
                    Delay.delayWithDuration(2.5, completionHandler: { (success) -> Void in
                        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.changeRootToHomeView()
                    })
                } else {
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
                
            } else {
                self.handleErrorWithType(requestErrorType, requestType: .UpdateProfile, responseObject: responseObject, hasImage: hasImage, firstName: firstName, lastName: lastName, profilePhoto: profilePhoto, userDocument: userDocument, referrerPersonCode: referrerPersonCode)
            }
        })
    }
    
    /* Function to request get user information data.
    *
    * If the API request is successful, it will convert the 'responseObject' to NSDictionary,
    * parse the 'data' object in the dictionary and set the values in the 'SessionManager'
    *
    * If the API request is unsuccessful, it will check 'requestErrorType'
    * and proceed/do some actions based on the error type
    */
    func fireGetUserInfo() {
        self.showLoader()
        
        WebServiceManager.fireGetUserInfoWithUrl(APIAtlas.getUserInfoUrl, accessToken: SessionManager.accessToken()) { (successful, responseObject, requestErrorType) -> Void in
            self.dismissLoader()
            if successful {
                if  let dictionary: NSDictionary = responseObject as? NSDictionary {
                    if let value: AnyObject = dictionary["data"] {

                        self.profileUserDetailsModel = ProfileUserDetailsModel.parseDataWithDictionary(value)
                        //Insert Data to Session Manager
                        SessionManager.setFullAddress(self.profileUserDetailsModel.address.fullLocation)
                        SessionManager.setUserFullName(self.profileUserDetailsModel.fullName)
                        SessionManager.setAddressId(self.profileUserDetailsModel.address.userAddressId)
                        SessionManager.setCartCount(self.profileUserDetailsModel.cartCount)
                        SessionManager.setWishlistCount(self.profileUserDetailsModel.wishlistCount)
                        SessionManager.setProfileImage(self.profileUserDetailsModel.profileImageUrl)
                        
                        SessionManager.setCity(self.profileUserDetailsModel.address.city)
                        SessionManager.setProvince(self.profileUserDetailsModel.address.province)
                        
                        SessionManager.setLang(self.profileUserDetailsModel.address.latitude)
                        SessionManager.setLong(self.profileUserDetailsModel.address.longitude)
                        
                        SessionManager.setReferrerCode(self.profileUserDetailsModel.referrerCode)
                
                        self.tableView.reloadData()
                        self.dismissLoader()
                    }
                }
            } else {
                self.dismissLoader()
                self.handleErrorWithType(requestErrorType, requestType: EditProfileRequestType.GetUserInfo, responseObject: responseObject, hasImage: false, firstName: "", lastName: "", profilePhoto: NSData(), userDocument: NSData(), referrerPersonCode: self.referrerPersonCode)
            }
        }
    }

    
    //MARK: - Handling of API Request Error
    /* Function to handle the error and proceed/do some actions based on the error type
    *
    * (Parameters) requestErrorType: RequestErrorType -- type of error being thrown by the web service. It is used to identify what specific action is needed to be execute based on the error type.
    *              responseObject: AnyObject -- response coming from the server. It is used to identify what specific error message is being thrown by the server
    *              params: TemporaryParameters -- collection of all params needed by all API request in the Wishlist.
    *
    * This function is for checking of 'requestErrorType' and proceed/do some actions based on the error type
    */
    func handleErrorWithType(requestErrorType: RequestErrorType, requestType: EditProfileRequestType, responseObject: AnyObject, hasImage: Bool, firstName: String, lastName: String, profilePhoto: NSData? = nil, userDocument: NSData? = nil, referrerPersonCode: String) {
        if requestErrorType == .ResponseError {
            //Error in api requirements
            let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message)
        } else if requestErrorType == .AccessTokenExpired {
            self.fireRefreshToken(requestType, hasImage: hasImage, firstName: firstName, lastName: lastName, profilePhoto: profilePhoto, userDocument: userDocument, referrerPersonCode: self.referrerPersonCode)
        } else if requestErrorType == .PageNotFound {
            //Page not found
            Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.navigationController!.view)
        } else if requestErrorType == .NoInternetConnection {
            //No internet connection
            Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.navigationController!.view)
        } else if requestErrorType == .RequestTimeOut {
            //Request timeout
            Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.navigationController!.view)
        } else if requestErrorType == .UnRecognizeError {
            //Unhandled error
            Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.navigationController!.view)
        }
    }

    
    //MARK: - Fire Refresh Token
    /* Function called when access_token is already expired.
    * (Parameter) params: TemporaryParameters -- collection of all params
    * needed by all API request in the Wishlist.
    *
    * This function is for requesting of access token and parse it to save in SessionManager.
    * If request is successful, it will check the requestType and redirect/call the API request
    * function based on the requestType.
    * If the request us unsuccessful, it will forcely logout the user
    */
    func fireRefreshToken(requestType: EditProfileRequestType, hasImage: Bool, firstName: String, lastName: String, profilePhoto: NSData? = nil, userDocument: NSData? = nil, referrerPersonCode: String) {
        self.showLoader()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.dismissLoader()
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                switch requestType {
                case .GetUserInfo:
                    self.fireGetUserInfo()
                case .UpdateProfile:
                    self.fireUpdateProfile(hasImage, firstName: firstName, lastName: lastName, profilePhoto: profilePhoto, userDocument: userDocument, referrerPersonCode: referrerPersonCode, countryId: self.country.countryID, languageId: self.language.languageId)
                }
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logoutWithTarget(self)
                })
            }
        })
    }
    
    //MARK: - Util Function
    //Loader function
    func showLoader() {
        self.hud = YiHUD.initHud()
        self.hud?.showHUDToView(self.navigationController!.view)
        self.view.userInteractionEnabled = false
    }
    
    //Hide loader
    func dismissLoader() {
        self.hud?.hide()
        self.view.userInteractionEnabled = true
    }
    
    // Hide Keyboard
    func hideKeyboard() {
//        self.view.endEditing(true)
    }
    
    func hideDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 0
            }, completion: { finished in
                self.dimView!.hidden = true
        })
    }
}

//MARK: -
//MARK: - Delegates and Data Source

//MARK: - UIImagePickerControllerDelegate, UIActionSheetDelegate
extension EditProfileTableViewController: UIImagePickerControllerDelegate, UIActionSheetDelegate {
    func openImageActionSheet(){
        if(checkIfUIAlertControllerIsAvailable()){
            handleIOS8()
        } else {
            var actionSheet:UIActionSheet
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
                actionSheet = UIActionSheet(title: EditProfileLocalizedStrings.addPhotoLocalizeString, delegate: self, cancelButtonTitle: EditProfileLocalizedStrings.cancelLocalizeString, destructiveButtonTitle: nil,otherButtonTitles: EditProfileLocalizedStrings.selectPhotoLocalizeString, EditProfileLocalizedStrings.takePhotoLocalizeString)
            } else {
                actionSheet = UIActionSheet(title: EditProfileLocalizedStrings.addPhotoLocalizeString, delegate: self, cancelButtonTitle: EditProfileLocalizedStrings.cancelLocalizeString, destructiveButtonTitle: nil,otherButtonTitles: EditProfileLocalizedStrings.selectPhotoLocalizeString)
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
        let alert = UIAlertController(title: EditProfileLocalizedStrings.addPhotoLocalizeString, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let libButton = UIAlertAction(title: EditProfileLocalizedStrings.selectPhotoLocalizeString, style: UIAlertActionStyle.Default) { (alert) -> Void in
            imageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imageController, animated: true, completion: nil)
        }
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: EditProfileLocalizedStrings.takePhotoLocalizeString, style: UIAlertActionStyle.Default) { (alert) -> Void in
                imageController.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(imageController, animated: true, completion: nil)
                
            }
            alert.addAction(cameraButton)
        } else {
            
        }
        let cancelButton = UIAlertAction(title: EditProfileLocalizedStrings.cancelLocalizeString, style: UIAlertActionStyle.Cancel) { (alert) -> Void in
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
            addPhotoCell!.addPhotoLabel.text = EditProfileLocalizedStrings.editPhotoLocalizeString
            
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
    
    //Function that resize the image to mi
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
    
    func checkIfUIAlertControllerIsAvailable() -> Bool {
        if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
            return true;
        }
        else {
            return false;
        }
    }
}

//MARK: - EditProfileAddPhotoTableViewCellDelegate
extension EditProfileTableViewController: EditProfileAddPhotoTableViewCellDelegate {
    func addPhotoAction(sender: AnyObject) {
        self.isForProfilePicture = true
        self.openImageActionSheet()
    }
}

//MARK: - EditProfilePersonalInformationTableViewCellDelegate
extension EditProfileTableViewController: EditProfilePersonalInformationTableViewCellDelegate {
    func passPersonalInformation(firstName: String, lastName: String, mobileNumber: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.mobileNumber = mobileNumber
        
        self.profileUserDetailsModel.firstName = firstName
        self.profileUserDetailsModel.lastName = lastName
        self.profileUserDetailsModel.contactNumber = mobileNumber
    }
    
    func changeMobileNumberAction(){
        var changeNumberModal = ChangeMobileNumberViewController(nibName: "ChangeMobileNumberViewController", bundle: nil)
        changeNumberModal.mobileNumber = profileUserDetailsModel.contactNumber
        changeNumberModal.delegate = self
        if SessionManager.mobileNumber().isEmpty  || !SessionManager.isMobileVerified(){
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
        self.isForProfilePicture = false
        self.openImageActionSheet()
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
            UIView.animateWithDuration(0.3, animations: {0
                self.dimView!.alpha = 1
                }, completion: { finished in
            })
        }
    }
    
    func didTapCountryAction() {
        let globalPref: GlobalPreferencesPickerTableViewController = GlobalPreferencesPickerTableViewController(nibName: "GlobalPreferencesPickerTableViewController", bundle: nil)
        globalPref.type = .Country
        globalPref.delegate = self
        globalPref.selectedCountry = self.country
        self.navigationController!.pushViewController(globalPref, animated: true)
    }
    
    func didTapLanguageAction() {
        let globalPref: GlobalPreferencesPickerTableViewController = GlobalPreferencesPickerTableViewController(nibName: "GlobalPreferencesPickerTableViewController", bundle: nil)
        globalPref.type = .Language
        globalPref.delegate = self
        globalPref.selectedLanguage = self.language
        self.navigationController!.pushViewController(globalPref, animated: true)
    }
    
    //MARK: - 
    //MARK: - Referral Code Table View Cell With Index Path
    func referralCodeTableViewCellWithIndexPath(indexPath: NSIndexPath) -> ReferralCodeTableViewCell {
        let cell: ReferralCodeTableViewCell = tableView.dequeueReusableCellWithIdentifier(ReferralCodeTableViewCell.nibNameAndIdentifier(), forIndexPath: indexPath) as! ReferralCodeTableViewCell
        
        cell.isFromQRScanner = self.isFromQRScanner
        
        if self.profileUserDetailsModel.referralCode != "" {
            cell.setYourReferralCodeWithCode(self.profileUserDetailsModel.referralCode)
        }
        
        if self.profileUserDetailsModel.referrerCode != "" {
            if self.isFromQRScanner {
                cell.setReferrerCodeWithCode("\(self.profileUserDetailsModel.referrerCode)")
            } else {
                cell.setReferrerCodeWithCode("\(self.profileUserDetailsModel.referrerCode) - \(self.profileUserDetailsModel.referrerName)")
            }
        }
        
        cell.delegate = self
        
        return cell
    }
}

// MARK: - ViewImageViewControllerDelegate
extension EditProfileTableViewController: ViewImageViewControllerDelegate {
    func dismissViewImageViewController() {
        hideDimView()
    }
}


//MARK: - EditProfileAddressTableViewCellDelegate
extension EditProfileTableViewController: EditProfileAddressTableViewCellDelegate {
    func changeAddressAction(sender: AnyObject){
        let changeAddressViewController: ChangeAddressViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        changeAddressViewController.delegate = self
        self.navigationController!.pushViewController(changeAddressViewController, animated: true)
    }
}

//MARK: - EditProfileAccountInformationTableViewCellDelegate
extension EditProfileTableViewController: EditProfileAccountInformationTableViewCellDelegate {
    func saveAction(sender: AnyObject) {
        
        var errorMessage: String = ""
        
        if firstName.isEmpty {
            errorMessage = "First name is required."
        } else if !firstName.isValidName() {
            errorMessage = "First name contains illegal characters. It can only contain letters, numbers and underscores."
        } else if lastName.isEmpty {
            errorMessage = "Last name is required."
        } else if !lastName.isValidName() {
            errorMessage = "Last name contains illegal characters. It can only contain letters, numbers and underscores."
        }
        
        if errorMessage != "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorMessage)
        } else {
            var hasImage: Bool = false
            if profileImageData != nil || validIDImageData != nil {
                hasImage = true
            } else {
                hasImage = false
            }
            
            self.fireUpdateProfile(hasImage, firstName: self.firstName, lastName: self.lastName, profilePhoto: self.profileImageData, userDocument: self.validIDImageData, referrerPersonCode: self.referrerPersonCode, countryId: self.country.countryID, languageId: self.language.languageId)
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
}

// MARK: - ChangePasswordViewControllerDelegate
extension EditProfileTableViewController: ChangePasswordViewControllerDelegate {
    func closeChangePasswordViewController(){
        hideDimView()
    }
    
    func submitChangePasswordViewController(){
        hideDimView()
        var changeLocalizeString = StringHelper.localizedStringWithKey("CHANGEPASSWORD_LOCALIZE_KEY")
        var successLocalizeString = StringHelper.localizedStringWithKey("SUCCESSCHANGEPASSWORD_LOCALIZE_KEY")
        Toast.displayToastWithMessage(successLocalizeString, duration: 2.0, view: self.navigationController!.view)
        
        SessionManager.logoutUserWithLoginRedirection(self)
    }
}

// MARK: ChangeAddressViewControllerDelegate
extension EditProfileTableViewController: ChangeAddressViewControllerDelegate {
    func changeAddressViewController(didSelectAddress address: String) {
        profileUserDetailsModel.address.fullLocation = address
        
        var indexPath = NSIndexPath(forRow: 2, inSection: 0)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }
}

// MARK: - ChangeMobileNumberViewControllerDelegate
extension EditProfileTableViewController: ChangeMobileNumberViewControllerDelegate {
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
    
}

// MARK: - VerifyMobileNumberViewControllerDelegate
extension EditProfileTableViewController: VerifyMobileNumberViewControllerDelegate {
    
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
}

extension EditProfileTableViewController: VerifyMobileNumberStatusViewControllerDelegate {
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
}

//MARK: - 
//MARK: - Referral Code Table View Cell Delegate
extension EditProfileTableViewController: ReferralCodeTableViewCellDelegate {
    
    func referralCodeTableViewCell(referralCodeTableViewCell: ReferralCodeTableViewCell, didClickCopyButtonWithString yourReferralCodeTextFieldText: String) {
        UIPasteboard.generalPasteboard().string = yourReferralCodeTextFieldText
        Toast.displayToastWithMessage(EditProfileLocalizedStrings.copiedToClipBoard, duration: 2.0, view: self.navigationController!.view)
    }
    
    func referralCodeTableViewCell(referralCodeTableViewCell: ReferralCodeTableViewCell, didTappedReturn textField: UITextField) {
        self.view.endEditing(true)
    }
    
    func referralCodeTableViewCell(referralCodeTableViewCell: ReferralCodeTableViewCell, didChangeValueAtTextField textField: UITextField, textValue: String) {
        self.referrerPersonCode = textValue
        println("textValue: \(textValue)")
    }
}

//MARK: -
//MARK: - Global Preferences Picker TableViewController Delegate
extension EditProfileTableViewController: GlobalPreferencesPickerTableViewControllerDelegate {
    func globalPreferencesPickerTableViewController(globalPreferencesPickerTableViewController: GlobalPreferencesPickerTableViewController, country: CountryModel) {
        self.country = country
        self.profileUserDetailsModel.country = country
        self.profileUserDetailsModel.country.defaultLanguage = self.language
        self.tableView.reloadData()
    }
    
    func globalPreferencesPickerTableViewController(globalPreferencesPickerTableViewController: GlobalPreferencesPickerTableViewController, language: LanguageModel) {
        self.language = language
        self.profileUserDetailsModel.language = language
        self.tableView.reloadData()
    }
}
