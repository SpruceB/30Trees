//
//  FarmDataEditorViewController.swift
//  30Trees
//
//  Created by Spruce Bondera on 10/2/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import UIKit

class FarmDataEditorViewController: UITableViewController, UITextFieldDelegate {
    var farm: FarmData?
    var is_new_farm = true
    var done_button: UIButton?
    
    @IBOutlet var farm_name: UITextField!
    @IBOutlet var acre_field: UITextField!
    @IBOutlet var tree_field: UITextField!
    @IBOutlet var location_field: UITextField!
    
    @IBAction func fieldEditingDidEnd(sender: UITextField) {
        farm!.name = farm_name.text!
        
        let value = (acre_field.text! as NSString).doubleValue
        if value == round(value) {
            sender.text = "\(Int(value))"
        }
        farm!.size = value
        
        if let num = Int(tree_field.text!) {
            sender.text = "\(num)"
            farm!.num_trees = num
        } else {
            sender.text = "\(farm!.num_trees)"
        }
        
        farm!.location = location_field.text!

    }
    
    @IBAction func farmNameEditingDidEnd(sender: UITextField) {
        farm!.name = sender.text!
    }

    @IBAction func acreEditingDidEnd(sender: UITextField) {
        let value = Double(sender.text!)!
        if value == round(value) {
            sender.text = "\(Int(value))"
        }
        farm!.size = value
    }
    
    @IBAction func treeNumEditingDidEnd(sender: UITextField) {
        if let value = Int(sender.text!) {
            sender.text = "\(value)"
            farm!.num_trees = value
        } else {
            sender.text = "\(farm!.num_trees)"
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField === acre_field {
            if string == "." && (textField.text!.componentsSeparatedByString(".").count - 1) >= 1 {
                return false
            }
        }
        return true
    }
    
    func pop() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        if self.farm != nil {
            if is_new_farm && farm == FarmData(name: "") {
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                if is_new_farm {
                    FarmDataController.sharedInstance.farms_list.append((farm!))
                }
                FarmDataController.sharedInstance.sync()
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    override func viewDidAppear(animated: Bool) {
        let back_button = UIBarButtonItem()
        back_button.title = "Cancel"
        self.navigationController?.navigationItem.backBarButtonItem = back_button
    }
    override func viewWillDisappear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidLoad() {
        self.tableView.allowsSelection = false
        self.tableView.alwaysBounceVertical = true
        self.tableView.scrollEnabled = true
        
        acre_field.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "closeKeyboards")
        gestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(gestureRecognizer)
        if let farm_data = farm {
            is_new_farm = false
            farm_name.text = farm_data.name
            acre_field.text = farm_data.size == round(farm_data.size) ? "\(Int(farm_data.size))" : "\(farm_data.size)"
            tree_field.text = "\(farm_data.num_trees)"
        } else {
            farm = FarmData(name: "")
        }
    }
    
    func closeKeyboards() {
        self.tableView.endEditing(false)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}