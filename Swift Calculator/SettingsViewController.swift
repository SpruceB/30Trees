//
//  SettingsViewController.swift
//  Swift Calculator
//
//  Created by Spruce Bondera on 9/29/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import UIKit
let FARM_DATA_EDITOR_DIRECT_SEGUE = "FarmDataEditorDirectSegue"
let FARM_EDITOR_SEGUE = "FarmEditorPushSegue"
class SettingsViewController: UIViewController {
    @IBOutlet var farmButton: UIButton!
    @IBAction func farmButtonPress(sender: AnyObject) {
        if FarmDataController.sharedInstance.farms_list.count == 0{
            performSegueWithIdentifier(FARM_DATA_EDITOR_DIRECT_SEGUE, sender: self)
        } else {
            performSegueWithIdentifier(FARM_EDITOR_SEGUE, sender: self)
        }
        
        if farmButton.highlighted {
            self.navigationController!.navigationBarHidden = false
            
        }
    }
    override func viewDidLoad() {
        
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBarHidden = true
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBarHidden = true
    }
    
}

