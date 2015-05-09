//
//  PositionalDataViewController.swift
//  30Trees
//
//  Created by Spruce Bondera on 10/27/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import UIKit

class PositionalDataViewController: UITableViewController {
    var farm: FarmData? {
        get {
            return FarmDataController.sharedInstance.selected_farm
        }
    }
    
    @IBOutlet var ABAliveTextField: UITextField!
    @IBOutlet var CDTextField: UITextField!
    @IBOutlet var ABDeadTextField: UITextField!
    
    @IBOutlet var ABAliveStepper: UIStepper!
    @IBOutlet var ABDeadStepper: UIStepper!
    @IBOutlet var CDStepper: UIStepper!
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.allowsSelection = false
        self.tableView.alwaysBounceVertical = false
        self.tableView.scrollEnabled = false
        if farm != nil {
            syncInteractablesToData()
            for ui_element in [ABAliveTextField, ABDeadTextField, CDTextField, ABAliveStepper, ABDeadStepper, CDStepper] {
                ui_element.enabled = true
            }
        } else {
            var alert = UIAlertView(title: "No Farm Selected", message: "You need to select a farm before you can edit positional data.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
            for ui_element in [ABAliveTextField, ABDeadTextField, CDTextField, ABAliveStepper, ABDeadStepper, CDStepper] {
                ui_element.enabled = false
                if ui_element is UITextField {
                    (ui_element as! UITextField).text = ""
                }
            }
            
        }
        
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: "closeKeyboards")
        gestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    func closeKeyboards() {
        self.tableView.endEditing(false)
    }
    
    func syncInteractablesToData() {
        ABAliveTextField.text = "\(farm!.ab_alive)"
        ABAliveStepper.value = Double(farm!.ab_alive)
        ABDeadTextField.text = "\(farm!.ab_dead)"
        ABDeadStepper.value = Double(farm!.ab_dead)
        CDTextField.text = "\(farm!.cd)"
        CDStepper.value = Double(farm!.cd)
    }
    
    func syncDataToTextFields() {
        farm?.ab_alive = ABAliveTextField.text.toInt()!
        farm?.ab_dead = ABDeadTextField.text.toInt()!
        farm?.cd = CDTextField.text.toInt()!
        syncInteractablesToData()
    }
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        farm?.ab_alive = Int(ABAliveStepper.value)
        farm?.ab_dead = Int(ABDeadStepper.value)
        farm?.cd = Int(CDStepper.value)
        syncInteractablesToData()
    }
    
    @IBAction func textFieldEditingDidEnd(sender: UITextField) {
        if let value = sender.text.toInt() {
            sender.text = "\(value)"
            syncDataToTextFields()
        } else {
            syncInteractablesToData()
        }
    }
}
