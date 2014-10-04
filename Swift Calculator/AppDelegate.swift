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
        if let data_array = defaults.objectForKey("farms") as? [AnyObject] {
            farms.data_array = data_array
        } else {
            defaults.setObject(farms.data_array, forKey: "farms")
        }
        farms.data_array = [FarmData(name: "Yo bitch")]
        return true
    }
    func applicationDidBecomeActive(application: UIApplication) {
//        println("became active")
    }
    func applicationWillResignActive(application: UIApplication) {
        defaults.setObject(farms.data_array, forKey: "farms")
        defaults.synchronize()
    }
}

