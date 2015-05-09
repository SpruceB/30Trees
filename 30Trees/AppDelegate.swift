//
//  AppDelegate.swift
//  Swift Calculator
//
//  Created by Spruce Bondera on 9/26/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    // Gets a reference to the FarmDataController singleton instance.
    var farms: FarmDataController = FarmDataController.sharedInstance
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        return true
    }
    func applicationDidBecomeActive(application: UIApplication) {

    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Makes sure the data for the farms is saved before the application closes.
        farms.sync()
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

