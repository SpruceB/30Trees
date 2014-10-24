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
let NO_SELECTED_FARM_SEGUE = "No Selected Farm Segue"

class TreeDataViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    
    var farm: FarmData? {
        get {
            return FarmDataController.sharedInstance.selected_farm?
        }
    }
    override func viewDidLoad() {
        navigationController?.navigationBarHidden = false
    }
   
    override func viewDidAppear(animated: Bool) {
        if farm == nil {
            var alert = UIAlertView(title: "No Farm Selected", message: "You need to select a farm before you can add trees.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        navigationController?.navigationBarHidden = false
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        tabBarController?.selectedIndex = 0
        // Below code moves to farm editor after alert. 
        //TODO: Check if this is UX client wants
        var settings = (tabBarController?.selectedViewController as UINavigationController).viewControllers![0] as UIViewController
        settings.performSegueWithIdentifier(FARM_EDITOR_SEGUE, sender: settings)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let tree = farm!.trees_data[row]
        var cell = tableView.dequeueReusableCellWithIdentifier("tree")!
         as UITableViewCell
        var title = cell.contentView.viewWithTag(1) as UILabel
        var subtitle = cell.contentView.viewWithTag(2) as UILabel
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
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == NEW_TREE_PUSH_SEGUE {
            (segue.destinationViewController as TreeDataEditorViewController).tree_index = farm?.trees_data.count
        }
        else if segue.identifier == SELECT_TREE_PUSH_SEGUE {
            (segue.destinationViewController as TreeDataEditorViewController).tree_index = (view as UITableView).indexPathForSelectedRow()!.row
        }
        else if segue.identifier == NO_SELECTED_FARM_SEGUE {
            segue.destinationViewController.viewControllers![0].performSegueWithIdentifier(FARM_EDITOR_SEGUE, sender: segue.destinationViewController.viewControllers![0])
        }

        
    }
 
}
