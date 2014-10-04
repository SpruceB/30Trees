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
    var is_new_tree = true
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

    
    @IBAction func cancelFarmEditing(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func createDoneButton() -> UIView {
        var footer_view = UIView(frame: CGRectMake(0, self.tableView.frame.height, self.tableView.frame.width, 327))
        footer_view.backgroundColor = self.tableView.backgroundColor
        var done_button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        done_button.frame = CGRectMake(0, 327-100, self.tableView.frame.width, 100)
        done_button.setAttributedTitle(NSAttributedString(string: "title"), forState: UIControlState.Normal)
        done_button.backgroundColor = UIColor.redColor()
        footer_view.addSubview(done_button)
        return footer_view
    }
    
    override func viewDidLoad() {
        self.tableView.allowsSelection = false
        self.tableView.alwaysBounceVertical = false
        self.tableView.scrollEnabled = false
    
        println(self.tableView)

        self.tableView.tableFooterView = createDoneButton()
        
        
        acre_field.delegate = self
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: "closeKeyboards")
        gestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(gestureRecognizer)
        if let farm_data = farm {
            is_new_tree = false
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
        return true
    }
}
