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
    var farms: FarmDataController = FarmDataController.sharedInstance
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        return true
    }
    func applicationDidBecomeActive(application: UIApplication) {

    }
    func applicationWillResignActive(application: UIApplication) {
        farms.sync()
    }

}

