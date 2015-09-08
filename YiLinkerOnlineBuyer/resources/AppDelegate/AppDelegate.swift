    //
//  AppDelegate.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var gcmSenderID = "AIzaSyDAlP85iUepL1LEhvB4tVrkyTnINCZTv7Q"
    var connectedToGCM = false
    var registrationToken: String?
    var registrationOptions = [String: AnyObject]()
    
    var registrationKey = "onRegistration"
    var messageKey = "onMessage"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        if SessionManager.accessToken() == "" {
            let startingPageStoryBoard: UIStoryboard = UIStoryboard(name: "StartPageStoryBoard", bundle: nil)
            let startingPageViewController: StartPageViewController = startingPageStoryBoard.instantiateViewControllerWithIdentifier("StartPageViewController") as! StartPageViewController
            self.window?.rootViewController = startingPageViewController
        } else {
            self.changeRootToHomeView()
        }
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        self.window?.makeKeyAndVisible()
        
        //Google Sign In
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        //assert(configureError == nil, "Error configuring Google services: \(configureError)")
        //gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        GIDSignIn.sharedInstance().clientID = "613594712632-q9iak1vgc6ua44fkc9kg5tut0s5vuo5m.apps.googleusercontent.com"
        
        if let font = UIFont(name: "Panton-Regular", size: 20) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        var types : UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
        var settings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        GCMService.sharedInstance().startWithConfig(GCMConfig.defaultConfig())
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        GGLInstanceID.sharedInstance().startWithConfig(GGLInstanceIDConfig.defaultConfig())
        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken,
            kGGLInstanceIDAPNSServerTypeSandboxOption:true]
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
            scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {

        println("Registration for remote notification failed with error: \(error.localizedDescription)")
        
        let userInfo = ["error": error.localizedDescription]
        NSNotificationCenter.defaultCenter().postNotificationName(
            self.registrationKey, object: nil, userInfo: userInfo)
    }
    
    func registrationHandler(registrationToken: String!, error: NSError!) {
        if (registrationToken != nil) {
            self.registrationToken = registrationToken
            println("Registration Token: \(registrationToken)")
            let userInfo = ["registrationToken": registrationToken]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
        } else {
            println("Registration to GCM failed with error: \(error.localizedDescription)")
            let userInfo = ["error": error.localizedDescription]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("Notification received \(userInfo)")
        
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        
        NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
            userInfo: userInfo)

    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        println("Notification received \(userInfo)")
        
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        
        NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
            userInfo: userInfo)
        completionHandler(UIBackgroundFetchResult.NoData);
    }
    
    func onTokenRefresh(){
        // for messaging
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID, scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    func changeRootToHomeView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
        let tabBarController: UITabBarController = storyBoard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        self.window?.rootViewController = tabBarController
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
    
}

