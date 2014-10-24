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
    @IBAction func farmNameEditingDidEnd(sender: UITextField) {
        farm!.name = sender.text
    }

    @IBAction func acreEditingDidEnd(sender: UITextField) {
        var value = (sender.text as NSString).doubleValue
        if value == round(value) {
            sender.text = "\(Int(value))"
        }
        farm!.size = value
    }
    
    @IBAction func treeNumEditingDidEnd(sender: UITextField) {
        if let value = sender.text.toInt() {
            sender.text = "\(value)"
            farm!.num_trees = value
        } else {
            sender.text = "\(farm!.num_trees)"
        }
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        if textField === acre_field {
            println(textField.text)
            if string == "." && textField.text.componentsSeparatedByString(".").count-1 >= 1 {
                return false
            }
        }
        return true
    }
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        if self.farm != nil {
            if is_new_farm && farm == FarmData(name: "") {
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                print("yuppers "); println(is_new_farm)
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

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidLoad() {
        self.tableView.allowsSelection = false
        self.tableView.alwaysBounceVertical = false
        self.tableView.scrollEnabled = false
        
        acre_field.delegate = self
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: "closeKeyboards")
        gestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(gestureRecognizer)
        if let farm_data = farm {
            is_new_farm = false
            farm_name.text = farm_data.name
            acre_field.text = farm_data.size == round(farm_data.size) ? "\(Int(farm_data.size))" : "\(farm_data.size)"
            tree_field.text = "\(farm_data.num_trees)"
        } else {
            println("whooo")
            farm = FarmData(name: "")
        }
    }
    
    func closeKeyboards() {
        self.tableView.endEditing(false)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
