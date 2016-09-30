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
import FirebaseInstanceID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey(Google_Api)
        
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        FIRApp.configure()
        if let notification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey]as? [NSString:AnyObject]{
            let aps = notification["aps"] as! [String:AnyObject]
            createRubbishNewsItem(aps)
            (window?.rootViewController as! UITabBarController).selectedIndex = 1
            
        }
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(self.tokenRefreshNotification),name: kFIRInstanceIDTokenRefreshNotification,
        object: nil)
        
        return true
    }
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
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }

}
// Apple Push Notification Service (APNS)
extension AppDelegate{
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .Sandbox)
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        print("Failed to register:",error)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(userInfo)
        if let notification = userInfo[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String:AnyObject]{
            let aps = notification["aps"] as! [String:AnyObject]
            createRubbishNewsItem(aps)
        }
        
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        // Print message ID.
        //        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        
        let aps = userInfo["aps"] as! [String: AnyObject]
        createRubbishNewsItem(aps)
        completionHandler(.NewData)
    }

    
    func createRubbishNewsItem(notification:[String:AnyObject]) -> NewsItem?{
        if let news =  notification["alert"] as? String{
            let date = NSDate()
            let newItem = NewsItem(title: news, date: date)
            let newStore = NewsStore.sharedInstance()
            newStore.addItems(newItem)
            
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationTableViewController.RefreshNewsFeedNotification, object: self)
            return  newItem
        }
        return nil
    }
}

