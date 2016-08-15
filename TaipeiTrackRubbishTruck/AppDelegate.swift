//
//  AppDelegate.swift
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/14.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
            GMSServices.provideAPIKey(Google_Api)
        
        
        let allNotificationTypes : UIUserNotificationType =
            [UIUserNotificationType.Badge ,
             UIUserNotificationType.Alert ,
            UIUserNotificationType.Sound]
        
        
        let settings = UIUserNotificationSettings(forTypes: allNotificationTypes, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        FIRApp.configure()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.tokenRefreshNotification(_:)), name: kFIRInstanceIDTokenRefreshNotification, object: nil)
        
        return true
    }
//    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
//        
//        var deviceTokenString: String = ( deviceToken.description as NSString )
//            .stringByTrimmingCharactersInSet( characterSet )
//            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
//        
//        print( deviceTokenString )
//        
//    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        FIRMessaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.connectToFcm()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    // Notification function
    func tokenRefreshNotification(notification:NSNotification) {
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("Instance ID IS" + refreshedToken!)
        self.connectToFcm()
    }
    func connectToFcm(){
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if  (error != nil) {
                
            }
            else{
                
            }
        }
    }

}

