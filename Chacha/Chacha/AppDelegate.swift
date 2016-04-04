//
//  AppDelegate.swift
//  Chacha
//
//  Created by Daniel Jones on 2/24/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Initialize Parse.
        Parse.setApplicationId("QWzqldyCuWjTaRLRQBBSM3MmhMTgxjCcPnAfp4PV",
            clientKey: "CxPL3WXPg5pGoWBB6qVb03xSqi6GzcecRBApF0n4")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        //register Parse Subclasses
        User.registerSubclass()
        Question.registerSubclass()
        Answer.registerSubclass()
        Like.registerSubclass()
        UserConnection.registerSubclass()
        Notification.registerSubclass()
        
        if let _ = PFUser.currentUser() {
            //user is already logged in, so we should send them right into the app
            let exploreFeedStoryBoard : UIStoryboard = UIStoryboard(name: "QuestionFeed", bundle: nil)
            let exploreFeedVC : UIViewController = exploreFeedStoryBoard.instantiateViewControllerWithIdentifier("TabBar") as UIViewController
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window?.rootViewController = exploreFeedVC
            self.window?.makeKeyAndVisible()
        }
        
        registerForPushNotifications(application)
        
        Instabug.startWithToken("fac43cb39d976b322aff694926620999", invocationEvent: IBGInvocationEvent.Shake)
        
        return true
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }


}

