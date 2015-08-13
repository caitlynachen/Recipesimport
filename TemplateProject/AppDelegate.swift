//
//  AppDelegate.swift
//  Template Project
//
//  Created by Benjamin Encz on 5/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseUI
import Mixpanel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

    var pushNotificationController:PushNotificationController?

    

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    
    Mixpanel.sharedInstanceWithToken("6b0ae6b1fde98b8c8a2035c11bd70dc9")
    let mixpanel: Mixpanel = Mixpanel.sharedInstance()
    mixpanel.track("App launched")
    
    // Override point for customization after application launch.
    Post.registerSubclass()

    Parse.setApplicationId("M5sFAPlVPwU1VB46sqv8mjAGnPhGH0FgPKQVVH7Z", clientKey: "661QfJdLp0Oi8mwTltKEePEMokJTYncGbPA3rBzj")
    
    PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
    
    // check if we have logged in user
       
    // check if we have logged in user
    // 2
    let user = PFUser.currentUser()
    
    let startViewController: UIViewController;
    
    self.pushNotificationController = PushNotificationController()
    
        // 3
        // if we have a user, set the TabBarController to be the initial View Controller
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    startViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! UIViewController
    

    
        // 4
        // Otherwise set the LoginViewController to be the first
    
    
    // 5
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    self.window?.rootViewController = startViewController;
    self.window?.makeKeyAndVisible()

    return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    
    
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
        FBSDKAppEvents.activateApp()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

