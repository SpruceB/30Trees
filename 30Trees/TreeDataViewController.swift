//
//  TreeDataViewController.swift
//  30Trees
//
//  Created by Spruce Bondera on 10/14/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import UIKit

let NEW_TREE_PUSH_SEGUE = "New Tree Push"
let SELECT_TREE_PUSH_SEGUE = "Tree Select Push"
let TREE_DATA_VIEW_CELL_IDENTIFIER = "tree"

class TreeDataViewController: UITableViewController, UIAlertViewDelegate {
    @IBOutlet var new_farm_button: UIBarButtonItem!
    @IBOutlet var clear_button: UIBarButtonItem!
    @IBAction func clearButtonPressed(sender: UIBarButtonItem) {
        let clear_alert = UIAlertView(title: "Are you sure?", message: "This will delete all tree data and cannot be undone.", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Clear")
        clear_alert.show()
    }
    
    var farm: FarmData? {
        get {
            return FarmDataController.sharedInstance.selected_farm
        }
    }
    override func viewDidLoad() {
        navigationController?.navigationBarHidden = false
    }
   
    override func viewDidAppear(animated: Bool) {
        if farm == nil {
            new_farm_button.enabled = false
            clear_button.enabled = false
            let alert = UIAlertView(title: "No Farm Selected", message: "You need to select a farm before you can add trees.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            new_farm_button.enabled = true
            clear_button.enabled = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {

    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == alertView.cancelButtonIndex + 1 {
            if farm != nil {
                farm?.trees_data = []
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let tree = farm!.trees_data[row]
        let cell = tableView.dequeueReusableCellWithIdentifier(TREE_DATA_VIEW_CELL_IDENTIFIER)!
        let title = cell.contentView.viewWithTag(1) as! UILabel
        let subtitle = cell.contentView.viewWithTag(2) as! UILabel
        title.text = "Tree \(row+1)"
        title.textColor = cell.tintColor
        subtitle.text = "Green: \(tree.green) CBB: \(tree.cbb) Fungus: \(tree.fungus)"
        subtitle.textColor = UIColor.lightGrayColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let trees_count = farm?.trees_data.count {
            return trees_count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            farm?.trees_data.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.reloadData()
            FarmDataController.sharedInstance.sync()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == NEW_TREE_PUSH_SEGUE {
            (segue.destinationViewController as! TreeDataEditorViewController).tree_index = farm?.trees_data.count
        }
        else if segue.identifier == SELECT_TREE_PUSH_SEGUE {
            (segue.destinationViewController as! TreeDataEditorViewController).tree_index = (view as! UITableView).indexPathForSelectedRow!.row
        }
        
    }
}
