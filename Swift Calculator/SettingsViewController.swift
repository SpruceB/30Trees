//
//  SettingsViewController.swift
//  Swift Calculator
//
//  Created by Spruce Bondera on 9/29/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var farmButton: UIButton!
    @IBAction func farmButtonPress(sender: AnyObject) {
        if farmButton.highlighted {
            self.navigationController.navigationBarHidden = false
        }
    }
    override func viewDidLoad() {
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController.navigationBarHidden = true
    }
    
}

