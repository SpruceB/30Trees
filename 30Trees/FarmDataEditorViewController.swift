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

    }

    @IBAction func fieldEditingDidEnd(sender: UITextField) {
//        if let name = farm_name.text {
//            farm?.name = name
//        }
//        if let size_string = acre_field.text {
//            if let size = Double(size_string) {
//                farm?.size = size
//                if size == round(size) {
//                    acre_field.text = String(Int(size))
//                }
//            }
//        }
//        
//        if let trees_string = tree_field.text {
//            if let tree_num = Int(trees_string) {
//                farm?.num_trees = tree_num
//                
//            } else {
//                tree_field.text = String(farm?.num_trees)
//            }
//        }
//        if let loc = location_field.text {
//            farm?.location = loc
//        }
    }
    
    @IBAction func fieldEditingDidBegin(sender: UITextField) {
//        let cell: UITableViewCell?
//        if floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1 {
//            cell = sender.superview?.superview as? UITableViewCell
//        } else {
//            print("7")
//            cell = sender.superview?.superview as? UITableViewCell
//        }
//        
//        if let index = tableView.indexPathForCell(cell!) {
//            print("yay")
//            tableView.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
//        } else {
//            print("fail")
//        }
    }
    
    @IBAction func farmNameEditingDidEnd(sender: UITextField) {
        if let text = sender.text {
            farm?.name = text
        }
    }

    @IBAction func acreEditingDidEnd(sender: UITextField) {
        if let text = sender.text {
            if let value = Double(text) {
                farm?.size = value
            } else if text != "" {
                sender.text = String(farm!.size)
            }
        }
    }
    
    @IBAction func treeNumEditingDidEnd(sender: UITextField) {
        if let text = sender.text {
            if let value = Int(text) {
                farm?.num_trees = value
            } else if text != "" {
                sender.text = String(farm!.num_trees)
            }
        }
    }
    
    @IBAction func locationEditingDidEnd(sender: UITextField) {
        if let text = sender.text {
            farm?.location = text
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField === acre_field {
            if string == "." && (textField.text!.componentsSeparatedByString(".").count - 1) >= 1 {
                return false
            }
        } else if textField == tree_field {
            if Int(string) == nil {
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
    
//    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = false
//    }
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
        fields = [farm_name, acre_field, tree_field, location_field]
        acre_field.delegate = self
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
