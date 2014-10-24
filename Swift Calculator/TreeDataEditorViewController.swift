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
            return FarmDataController.sharedInstance.selected_farm!.trees_data
        }
        set {
            FarmDataController.sharedInstance.selected_farm!.trees_data = newValue!
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
        navigationController?.setViewControllers([(navigationController?.viewControllers.first as UIViewController), self], animated: true)
        
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
            println("No tree variable. Should really be throwing an error here.")
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as TreeDataEditorViewController).tree_index = tree_index! + 1
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        // For some reason, just implementing this method stops keyboard from scrolling view up.
    }
    
    override func viewWillDisappear(animated: Bool) {
        println(tree_data!)
        FarmDataController.sharedInstance.sync()
    }

}