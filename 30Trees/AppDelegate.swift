
//
//  AppDelegate.swift
//  Swift Calculator
//
//  Created by Spruce Bondera on 9/26/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CSVExporterDelegate {
                            
    var window: UIWindow?
    // Gets a reference to the FarmDataController singleton instance.
    var farms: FarmDataController = FarmDataController.sharedInstance
    var dirtyExporters: [CSVExporter] = []
    
    func exporterWasSetup(sender: CSVExporter) {
        var alreadyIn = false
        for ex in dirtyExporters {
            if ex === sender {
                alreadyIn = true
                break
            }
        }
        if !alreadyIn {
            dirtyExporters.append(sender)
        }
    }
    
    func exporterWasCleaned(sender: CSVExporter) {
        if let index = dirtyExporters.indexOf({$0 === sender}) {
            dirtyExporters.removeAtIndex(index)
        }
    }
    
    func cleanExporters() {
        for ex in dirtyExporters {
            do {
                try ex.cleanupFiles()
            } catch {} // Don't care, temp will be cleaned eventually
        }
    }
    
    func applicationWillTerminate(application: UIApplication) {
        cleanExporters()
    }
    func applicationDidEnterBackground(application: UIApplication) {
        cleanExporters()
    }
    
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

