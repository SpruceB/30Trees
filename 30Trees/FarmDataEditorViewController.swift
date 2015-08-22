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
    @IBOutlet var grower_name: UITextField!
    @IBOutlet var phone_number: UITextField!
    
    var fields: [UITextField] = []
    
    func all_filled() -> Bool {
        for f in fields {
            if f.text == "" {
                return false
            }
        }
        return true
    }
    
    func syncInteractablesToData() {
        if let name = farm?.name {
            farm_name.text = name
        }
        
        if let size = farm?.size {
            acre_field.text = String(size)
        }
        
        if let trees = farm?.num_trees {
            tree_field.text = String(trees)
        }
        
        if let location = farm?.location {
            location_field.text = String(location)
        }
        
        if let grower_name_ = farm?.grower_name {
            grower_name.text = grower_name_
        }
        
        if let number = farm?.phone_number {
            phone_number.text = number
        }
    }
    
    func syncDataToInteractables() {
        if let text = farm_name.text {
            farm?.name = text
        }
        
        if let text = acre_field.text {
            if let value = Double(text) {
                farm?.size = value
            } else if text != "" {
                acre_field.text = String(farm!.size)
            }
        }

        if let text = tree_field.text {
            if let value = Int(text) {
                farm?.num_trees = value
            } else if text != "" {
                tree_field.text = String(farm!.num_trees)
            }
        }
        
        if let text = location_field.text {
            farm?.location = text
        }
        
        if let text = grower_name.text {
            farm?.grower_name = text
        }

        if let text = phone_number.text {
            farm?.phone_number = text
        }
    }

    @IBAction func fieldEditingDidEnd(sender: UITextField) {
    }
    
    @IBAction func fieldEditingDidBegin(sender: UITextField) {
    }
    
    @IBAction func farmNameEditingDidEnd(sender: UITextField) {
    }

    @IBAction func acreEditingDidEnd(sender: UITextField) {
    }
    
    @IBAction func treeNumEditingDidEnd(sender: UITextField) {
    }
    
    @IBAction func locationEditingDidEnd(sender: UITextField) {
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let start = advance(textField.text!.startIndex, range.location)
        let end = advance(start, range.length)
        let swiftRange = Range<String.Index>(start: start, end: end)
        let result = textField.text!.stringByReplacingCharactersInRange(swiftRange, withString: string)
        if textField === acre_field {
            if Double(result) == nil && result != "" {
                return false
            }
        } else if textField == tree_field {
            if Int(result) == nil && result != ""{
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
            if is_new_farm && !all_filled() {
                UIAlertView(title: "Incomplete Farm", message: "The fields have not been completely filled", delegate: self, cancelButtonTitle: "OK").show()
            } else {
                syncDataToInteractables()
                if is_new_farm {
                    FarmDataController.sharedInstance.farms_list.append(farm!)
                }
                FarmDataController.sharedInstance.sync()
                self.navigationController?.popViewControllerAnimated(true)
                
            }
        }
        else {
            UIAlertView(title: "Something went wrong", message: "Please try again", delegate: self, cancelButtonTitle: "OK").show()
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    

    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
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
        fields = [farm_name, acre_field, tree_field, location_field, grower_name, phone_number]
        acre_field.delegate = self
        tree_field.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "closeKeyboards")
        gestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(gestureRecognizer)
        if farm != nil {
            is_new_farm = false
            syncInteractablesToData()
        } else {
            self.farm = FarmData(name: "")
        }
    }
    
    func closeKeyboards() {
        self.tableView.endEditing(false)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}
