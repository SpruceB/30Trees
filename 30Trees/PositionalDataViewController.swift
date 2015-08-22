//
//  PositionalDataViewController.swift
//  30Trees
//
//  Created by Spruce Bondera on 10/27/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import UIKit

let sprayDateIndex = NSIndexPath(forRow: 0, inSection: 4)

class PositionalDataViewController: UITableViewController {
    var farm: FarmData? {
        get {
            return FarmDataController.sharedInstance.selected_farm
        }
    }
    
    @IBOutlet var ABAliveTextField: UITextField!
    @IBOutlet var CDTextField: UITextField!
    @IBOutlet var ABDeadTextField: UITextField!
    @IBOutlet var ABAbsentTextField: UITextField!
    
    @IBOutlet var ABAliveStepper: UIStepper!
    @IBOutlet var ABDeadStepper: UIStepper!
    @IBOutlet var CDStepper: UIStepper!
    @IBOutlet var ABAbsentStepper: UIStepper!

    @IBOutlet var lastSprayDateLabel: UILabel!
    var editingDate = false
    
    @IBOutlet var lastSprayDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        self.tableView.allowsSelection = true
        self.tableView.alwaysBounceVertical = false
        self.tableView.scrollEnabled = true
        self.tableView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "localeChanged", name: NSCurrentLocaleDidChangeNotification, object: nil)
    }
    
    func localeChanged(notif: NSNotification) {
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        let cell = self.tableView.cellForRowAtIndexPath(sprayDateIndex)
        cell?.separatorInset = UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            self.tableView.layoutMargins = UIEdgeInsetsZero
            cell?.layoutMargins = UIEdgeInsetsZero
        }
        let dateCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sprayDateIndex.row + 1, inSection: sprayDateIndex.section))
        dateCell?.clipsToBounds = true
        
        syncLabelToFarm()
        if let lastDate = farm?.last_spray_date {
            lastSprayDatePicker.date = lastDate
        }
        
        self.automaticallyAdjustsScrollViewInsets = true
        let interactables = [ABAliveTextField, ABDeadTextField, ABAbsentTextField, CDTextField, ABAliveStepper, ABDeadStepper, ABAbsentStepper, CDStepper]
        if farm != nil {
            syncInteractablesToData()
            for ui_element in interactables {
                ui_element.enabled = true
            }
        } else {
            let alert = UIAlertView(title: "No Farm Selected", message: "You need to select a farm before you can edit positional data.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
            for ui_element in interactables {
                ui_element.enabled = false
                if ui_element is UITextField {
                    (ui_element as! UITextField).text = ""
                }
            }
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "closeKeyboards")
        gestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewDidDisappear(animated: Bool) {
        closeLastDatePicker(sprayDateIndex)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.tableView.cellForRowAtIndexPath(indexPath)?.tag == 1 && farm != nil{
            openLastDatePicker(indexPath)
        }
    }
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return tableView.cellForRowAtIndexPath(indexPath)?.tag == 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        print(indexPath)
        if indexPath.section == sprayDateIndex.section  && indexPath.row == sprayDateIndex.row + 1 {
            if editingDate {
                return 200
            } else {
                return 0
            }
        } else {
            return self.tableView.rowHeight
        }
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func syncLabelToFarm() {
        if let lastDate = farm?.last_spray_date {
            let formatter = NSDateFormatter()
            formatter.timeStyle = NSDateFormatterStyle.NoStyle
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.locale = NSLocale.currentLocale()
            lastSprayDateLabel.text = formatter.stringFromDate(lastDate)
        } else {
            lastSprayDateLabel.text = ""
        }
    }
    
    func openLastDatePicker(indexPath: NSIndexPath) {
        if !self.editingDate {
            self.editingDate = true
            let dateIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            UIView.animateWithDuration(0.2, animations: {self.tableView.reloadRowsAtIndexPaths([dateIndexPath], withRowAnimation: UITableViewRowAnimation.Fade); self.tableView.reloadData()})
            
            lastSprayDateLabel.textColor = ABAliveTextField.textColor
            self.tableView.scrollToRowAtIndexPath(dateIndexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        } else {
            closeLastDatePicker(indexPath)
        }
        
    }
    
    func closeLastDatePicker(indexPath: NSIndexPath) {
        self.editingDate = false
        lastSprayDateLabel.textColor = UIColor.blackColor()
        let dateIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
        UIView.animateWithDuration(0.2, animations: {self.tableView.reloadRowsAtIndexPaths([dateIndexPath], withRowAnimation: UITableViewRowAnimation.Fade); self.tableView.reloadData()})
        farm?.last_spray_date = lastSprayDatePicker.date
        syncLabelToFarm()
    }
    
    @IBAction func editingChanged(sender: UIDatePicker) {
        farm?.last_spray_date = sender.date
        syncLabelToFarm()
    }
    
    func closeKeyboards() {
        self.tableView.endEditing(false)
    }
    
    func syncInteractablesToData() {
        ABAliveTextField.text = "\(farm!.ab_alive)"
        ABAliveStepper.value = Double(farm!.ab_alive)
        ABDeadTextField.text = "\(farm!.ab_dead)"
        ABDeadStepper.value = Double(farm!.ab_dead)
        ABAbsentTextField.text = String(farm!.ab_absent)
        ABAbsentStepper.value = Double(farm!.ab_absent)
        CDTextField.text = "\(farm!.cd)"
        CDStepper.value = Double(farm!.cd)
        syncLabelToFarm()
        FarmDataController.sharedInstance.sync()
    }
    
    func syncDataToTextFields() {
        farm?.ab_alive = Int(ABAliveTextField.text!)!
        farm?.ab_dead = Int(ABDeadTextField.text!)!
        farm?.ab_absent = Int(ABAbsentTextField.text!)!
        farm?.cd = Int(CDTextField.text!)!
        syncInteractablesToData()
    }
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        farm?.ab_alive = Int(ABAliveStepper.value)
        farm?.ab_dead = Int(ABDeadStepper.value)
        farm?.ab_absent = Int(ABAbsentStepper.value)
        farm?.cd = Int(CDStepper.value)
        syncInteractablesToData()
    }
    
    @IBAction func textFieldEditingDidEnd(sender: UITextField) {
        if let value = Int(sender.text!) {
            sender.text = String(value)
            syncDataToTextFields()
        } else {
            syncInteractablesToData()
        }
    }
}
