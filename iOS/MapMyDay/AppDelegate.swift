//
//  AppDelegate.swift
//  Map My Day
//
//  Created by Mollie on 3/2/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

let redColor = UIColor(red:0.7, green:0, blue:0.16, alpha:1)
let orangeColor = UIColor(red:0.92, green:0.55, blue:0.16, alpha:1)
let greenColor = UIColor(red:0.18, green:0.91, blue:0.55, alpha:1)
let blueColor = UIColor(red:0, green:0.56, blue:0.72, alpha:1)
let tanColor = UIColor(red:0.91, green:0.92, blue:0.84, alpha:1)
let whiteColor = UIColor.whiteColor()
let darkGrayColor = UIColor(red:0.23, green:0.23, blue:0.23, alpha:1)
let lightGrayColor = UIColor(red:0.56, green:0.56, blue:0.56, alpha:1)
let primaryFont = "HelveticaNeue-Light"
let thinFont = "HelveticaNeue-Thin"
let boldFont = "HelveticaNeue"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.setApplicationId("SC52Z3ssKElPhe1OwWnduX8kSxhUN6C9jOiQr0Er", clientKey: "SkJP6SSiiBUQyP7Xx2jo6CKKDqLGGmKlm9kSfzsx")
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
        var loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        var loginVC = loginStoryboard.instantiateInitialViewController() as LoginViewController
        
        window?.rootViewController = loginVC
        
        // MARK: Aesthetics
        UINavigationBar.appearance().translucent = false
        UITabBar.appearance().tintColor = lightGrayColor
        UITabBar.appearance().backgroundColor = tanColor
        UITabBarItem.appearance().setTitleTextAttributes(([NSForegroundColorAttributeName:lightGrayColor, NSFontAttributeName:UIFont(name: primaryFont, size: 12)!]), forState: UIControlState.Normal)
        UIButton.appearance().tintColor = whiteColor
        UIButton.appearance().setTitleColor(whiteColor, forState: UIControlState.Normal)
        // UIButton font seems impossible to set programmatically using appearance()
        UISwitch.appearance().onTintColor = greenColor
//        UITableViewCell.appearance().textLabel?.textColor = redColor
        // apparently impossible to set tableview textlabel color
        UITableViewCell.appearance().textLabel?.font = UIFont(name: primaryFont, size: 16)
        UITableViewCell.appearance().detailTextLabel?.font = UIFont(name: primaryFont, size: 16)
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: boldFont, size: 21)!]
        
//        UIBarButtonItem.appearance().tintColor = lightPrimary
//        UINavigationBar.appearance().tintColor = lightPrimary
//        UITableView.appearance().backgroundColor = lightPrimary
//        UITableView.appearance().separatorColor = darkPrimary
//        UITableViewCell.appearance().backgroundColor = lightPrimary
//        var bgColorView = UIView()
//        bgColorView.backgroundColor = mediumPrimary
//        UITableViewCell.appearance().selectedBackgroundView = bgColorView
//        UILabel.appearance().textColor = darkSecondary
//        UITextView.appearance().textColor = darkSecondary
//        UITextField.appearance().textColor = darkSecondary
//        UITableViewCell.appearance().textLabel?.textColor = darkSecondary
//        UINavigationBar.appearance().barTintColor = darkPrimary
//        View.appearance().backgroundColor = lightPrimary
//        UIBarButtonItem.appearance().setTitleTextAttributes(([NSFontAttributeName: UIFont(name: headerFont, size: 16)!]), forState: UIControlState.Normal)
//        UITextField.appearance().font = UIFont(name: primaryFont, size: 16)
//        UITextView.appearance().font = UIFont(name: primaryFont, size: 16)
//        UILabel.appearance().font = UIFont(name: primaryFont, size: 16)
        
        return true
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


}

