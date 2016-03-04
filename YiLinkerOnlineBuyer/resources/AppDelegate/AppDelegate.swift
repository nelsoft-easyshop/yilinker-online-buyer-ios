    //
//  AppDelegate.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GGLInstanceIDDelegate {

    var window: UIWindow?
    var gcmSenderID = "976304473940"
    var connectedToGCM = false 
    var registrationToken: String?
    var registrationOptions = [String: AnyObject]()
    
    var registrationKey = "onRegistration"
    
    struct responseType {
        static let Status = "USER_ONLINE_STATUS"
        static let New = "NEW_MESSAGE"
        static let Seen = "CONVERSATION_SEEN"
    }
    var messageKey = "onMessage"
    var seenMessageKey = "seenMessage"
    var statusKey = "userOnlineStatus"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        //self.toastStyle()
        if SessionManager.accessToken() == "" {
            self.startPage()
        } else {
            self.changeRootToHomeView()
        }
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        self.window?.makeKeyAndVisible()
        self.window!.backgroundColor = UIColor.whiteColor()

        //Google Sign In
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        println(gcmSenderID)
        GIDSignIn.sharedInstance().clientID = "613594712632-q9iak1vgc6ua44fkc9kg5tut0s5vuo5m.apps.googleusercontent.com"
        
        if let font = UIFont(name: "Panton-SEMIBOLD", size: 15) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        var types : UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
        var settings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        GCMService.sharedInstance().startWithConfig(GCMConfig.defaultConfig())
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        MagicalRecord.setupCoreDataStack()
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        // Rj
        
        let trimEnds: String = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        let cleanToken: String = trimEnds.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        SessionManager.setDeviceToken(cleanToken)
        println("Device Token > \(cleanToken)")
        println("Device Token w/o trim > \(deviceToken.description)")
        
        GGLInstanceID.sharedInstance().startWithConfig(GGLInstanceIDConfig.defaultConfig())
        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken,
            kGGLInstanceIDAPNSServerTypeSandboxOption:true]
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
            scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {

        println("Registration for remote notification failed with error: \(error.localizedDescription)")
        
        let userInfo = ["error": error.localizedDescription]
        if let registrationToken = userInfo["registrationToken"] {
            SessionManager.setGcmToken(registrationToken)
            println("REGISTERED WITH : \(registrationToken)")
        }
        //NSNotificationCenter.defaultCenter().postNotificationName(self.registrationKey, object: nil, userInfo: userInfo)
    }
    
    func registrationHandler(registrationToken: String!, error: NSError!) {
        if (registrationToken != nil) {
            self.registrationToken = registrationToken
            println("Registration Token: \(registrationToken)")
            let userInfo = ["registrationToken": registrationToken]
            if let registrationToken = userInfo["registrationToken"] {
                SessionManager.setGcmToken(registrationToken)
                println("REGISTERED WITH : \(registrationToken)")
            }
            if let error = userInfo["error"] {
                println("REGISTRATION WITH ERROR: \(error)")
            }
            //NSNotificationCenter.defaultCenter().postNotificationName(self.registrationKey, object: nil, userInfo: userInfo)
        } else {
            println("Registration to GCM failed with error: \(error.localizedDescription)")
            let userInfo = ["error": error.localizedDescription]
            //NSNotificationCenter.defaultCenter().postNotificationName(self.registrationKey, object: nil, userInfo: userInfo)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("Notification received \(userInfo)")
        
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        
        if let info = userInfo["responseType"] as? NSString {
            switch info {
                case responseType.Seen:                    NSNotificationCenter.defaultCenter().postNotificationName(seenMessageKey, object: nil, userInfo: userInfo)
                case responseType.Status:
                    NSNotificationCenter.defaultCenter().postNotificationName(statusKey, object: nil, userInfo: userInfo)
                case responseType.New:
                    NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil, userInfo: userInfo)
                default:
                    println("RESPONSE TYPE INVALID")
            }
            
        } else {
            println("userInfo not a string")
        }
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        println("Notification received \(userInfo)")
        
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        
        if let info = userInfo["responseType"] as? NSString {
            switch info {
            case responseType.Seen:
                NSNotificationCenter.defaultCenter().postNotificationName(seenMessageKey, object: nil, userInfo: userInfo)
            case responseType.Status:
                NSNotificationCenter.defaultCenter().postNotificationName(statusKey, object: nil, userInfo: userInfo)
            case responseType.New:
                NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil, userInfo: userInfo)
            default:
                println("RESPONSE TYPE INVALID")
            }
            
        } else {
            println("userInfo not a string")
        }
        
        completionHandler(UIBackgroundFetchResult.NoData);
        
        
        // Rj
        if application.applicationState == UIApplicationState.Active {
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            var body: NSDictionary = userInfo["aps"] as! NSDictionary
            let alertController = UIAlertController(title: "YiLinker", message: body["alert"] as? String, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil))
            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        } else {
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            var body: NSDictionary = userInfo["aps"] as! NSDictionary
            
            var targetType: String = ""
            var target: String = ""
            
            if let temp = body["targetType"] as? String {
                 targetType = temp
            }
            
            if let temp = body["target"] as? String {
                target = temp
            }
            
            for view in self.window!.subviews {
                view.removeFromSuperview()
            }
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
            let tabBarController: UITabBarController = storyBoard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            self.window?.rootViewController = tabBarController
            
            let nav = tabBarController.viewControllers!.first as! UINavigationController
            let homeController: HomeContainerViewController = nav.viewControllers.first as! HomeContainerViewController
            homeController.didClickItemWithTarget(target, targetType: targetType, sectionTitle: "Push Notif")
           /*if targetType == "seller" {
                self.window?.rootViewController = tabBarController
            } else if targetType == "productList" {
                self.window?.rootViewController = tabBarController
            } else if targetType == "sellerList" {
                
            } else if targetType == "product" {
                self.window?.rootViewController = tabBarController
            } else if targetType == "webView" {
                self.window?.rootViewController = tabBarController
            }*/
        }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        var body: NSDictionary = userInfo["aps"] as! NSDictionary
        println(body)
    }
    
    func onTokenRefresh(){
        // for messaging
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID, scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    func changeRootToHomeView() {
        for view in self.window!.subviews {
            view.removeFromSuperview()
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
        let tabBarController: UITabBarController = storyBoard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        self.window?.rootViewController = tabBarController
    }
    
    func startPage() {
        for view in self.window!.subviews {
            view.removeFromSuperview()
        }
        let startingPageStoryBoard: UIStoryboard = UIStoryboard(name: "StartPageStoryBoard", bundle: nil)
        let startingPageViewController: StartPageViewController = startingPageStoryBoard.instantiateViewControllerWithIdentifier("StartPageViewController") as! StartPageViewController
        self.window?.rootViewController = startingPageViewController
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            
            return FBSDKApplicationDelegate.sharedInstance().application(
                    application,
                    openURL: url,
                    sourceApplication: sourceApplication,
                    annotation: annotation)
           
    }

    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
        withError error: NSError!) {
            // Perform any operations when the user disconnects from app here.
            // ...
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        GCMService.sharedInstance().disconnect()
        self.connectedToGCM = false
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        GCMService.sharedInstance().connectWithHandler({
            (NSError error) -> Void in
            if error != nil {
                println("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                println("Connected to GCM")
            }
        })
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func toastStyle() {
        let style: CSToastStyle = CSToastStyle(defaultStyle:())
        style.messageColor = UIColor.whiteColor()
        style.backgroundColor = Constants.Colors.appTheme
        CSToastManager.setSharedStyle(style)
        CSToastManager.setTapToDismissEnabled(true)
    }
}

