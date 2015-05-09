//
//  TreeDataEditorViewController.swift
//  30Trees
//
//  Created by Spruce Bondera on 10/15/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import UIKit

let NEXT_TREE_SEGUE = "Next Tree Push Segue"

class TreeDataEditorViewController: UITableViewController, UITextFieldDelegate {
    var tree_data: [TreeData]? {
        get {
            return FarmDataController.sharedInstance.selected_farm?.trees_data
        }
        set {
            FarmDataController.sharedInstance.selected_farm?.trees_data = newValue!
        }
    }
    var tree_index: Int?
    var tree: TreeData?
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var cbbTextField: UITextField!
    @IBOutlet var fungusTextField: UITextField!
    
    @IBOutlet var greenStepper: UIStepper!
    @IBOutlet var cbbStepper: UIStepper!
    @IBOutlet var fungusStepper: UIStepper!
    
    
    
    override func viewDidLoad() {
        // The following line changes the navigationController's view stack so pressing the back button goes to the root view
//        navigationController?.setViewControllers([(navigationController?.viewControllers.first as! UIViewController), (navigationController?.viewControllers.last as! UIViewController)], animated: true)
//        self.navigationItem.setHidesBackButton(true, animated: false)
        let back_button = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: "popToRoot")
        self.navigationItem.leftBarButtonItem = back_button

        self.tableView.allowsSelection = false
        self.tableView.alwaysBounceVertical = false
        self.tableView.scrollEnabled = false
        if tree_data != nil && tree_index != nil {
            if tree_index >= tree_data!.count {
                tree_data!.append(TreeData())
                tree = tree_data![tree_data!.count - 1]
            } else if tree_index >= 0 {
                tree = tree_data![tree_index!]
            }
        }
        if tree != nil {
            syncInteractablesToData()
        } else {
            NSException(name: "NilTreeError", reason: "Somehow a TreeDataEditor was entered without an actual tree to edit.", userInfo: nil).raise()
        }
        
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: "closeKeyboards")
        gestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    func closeKeyboards() {
        self.tableView.endEditing(false)
    }
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        tree?.green = Int(greenStepper.value)
        tree?.cbb = Int(cbbStepper.value)
        tree?.fungus = Int(fungusStepper.value)
        syncInteractablesToData()
    }
    
    func syncInteractablesToData() {
        greenTextField.text = "\(tree!.green)"
        greenStepper.value = Double(tree!.green)
        cbbTextField.text = "\(tree!.cbb)"
        cbbStepper.value = Double(tree!.cbb)
        fungusTextField.text = "\(tree!.fungus)"
        fungusStepper.value = Double(tree!.fungus)
    }
    func syncDataToTextFields() {
        tree?.green = greenTextField.text.toInt()!
        tree?.cbb = cbbTextField.text.toInt()!
        tree?.fungus = fungusTextField.text.toInt()!
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
    func popToRoot() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! TreeDataEditorViewController
        dest.tree_index = tree_index! + 1
//        dest.navigationItem.setHidesBackButton(true, animated: false)
//        let back_button = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: dest, action: "popToRoot")
//        dest.navigationItem.setLeftBarButtonItem(back_button, animated: false)
    }
    
    // For some reason, just implementing this method (even with nothing in it) stops opening keyboard from scrolling view up.
    override func viewWillAppear(animated: Bool) {
        if tree_data == nil {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        FarmDataController.sharedInstance.sync()
    }

}