//
//  FarmEditorViewController.swift
//  30Trees
//
//  Created by Spruce Bondera on 9/30/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import UIKit

let FARM_DATA_EDITOR_NEW_FARM_SEGUE = "FarmDataEditorNewFarmSegue"
let FARM_DATA_EDITOR_SEGUE = "FarmDataEditorSegue"

class FarmEditorViewController: UITableViewController, UITableViewDelegate {
    
    var farms: FarmDataController {
        get {
            return FarmDataController.sharedInstance
        }
    }
    var edit_row: Int?
    
    @IBAction func addFarmButtonPressed(sender: UIBarButtonItem) {
        
    }
    override func viewDidLoad() {
        tableView.delegate = self
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBarHidden = false
        self.tableView.reloadData()
        selectSelectedRow()
    }
    
    override func viewWillDisappear(animated: Bool) {
        farms.sync()
    }
    
    @IBAction func editButtonTouchDown(sender: UIButton) {
        var edit_button_path = tableView.indexPathForCell(sender.superview!.superview! as UITableViewCell)
        edit_row = edit_button_path!.row
        if self.tableView.indexPathForSelectedRow() != edit_button_path {
            tableView.deselectRowAtIndexPath(edit_button_path!, animated: false)
        }
    }
    
    override func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        (cell?.viewWithTag(2) as UIButton).setTitleColor(cell?.tintColor, forState: UIControlState.Normal)
        return indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        (cell?.viewWithTag(2) as UIButton).setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cell?.setHighlighted(true, animated: false)
        farms.selected_farm = farms.farms_list[indexPath.row]
        farms.selected_farm_index = indexPath.row
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("farm") as UITableViewCell
        var label = cell.contentView.viewWithTag(1) as UILabel
        label.text = "\(farms.farms_list[indexPath.row].name)"
        label.highlightedTextColor = UIColor.whiteColor()
        var edit_button = cell.contentView.viewWithTag(2) as UIButton
        edit_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView.backgroundColor = UIColor(red:0.322, green:0.843, blue:0.404, alpha:1)
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return farms.farms_list.count
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            farms.farms_list.removeAtIndex(indexPath.row)
            if farms.selected_farm_index == indexPath.row {
                farms.selected_farm_index = nil
                farms.selected_farm = nil
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        selectSelectedRow()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        selectSelectedRow()
    }
    
    func selectSelectedRow() {
        if let row = farms.selected_farm_index {
            var path = NSIndexPath(forRow: row, inSection: 0)
            tableView.selectRowAtIndexPath(path, animated: false, scrollPosition: UITableViewScrollPosition.None)
            self.tableView(tableView, didSelectRowAtIndexPath: path!)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == FARM_DATA_EDITOR_SEGUE {
            let editor_controller = segue.destinationViewController as FarmDataEditorViewController
            editor_controller.farm = farms.farms_list[edit_row!]
            
        }
        else if segue.identifier == FARM_DATA_EDITOR_NEW_FARM_SEGUE {
            
        }
    }
}

class FarmEditorUITableViewCell: UITableViewCell {
    override func setHighlighted(highlighted: Bool, animated: Bool) {
//        super.setHighlighted(highlighted, animated: animated)
        // Overiding this means the cells do nothing when highlighted.
    }
}
    
