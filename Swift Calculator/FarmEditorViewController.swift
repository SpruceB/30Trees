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

class FarmEditorViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    var farms: FarmDataController = FarmDataController.sharedInstance
    
    @IBAction func addFarmButtonPressed(sender: UIBarButtonItem) {
        
    }
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController.navigationBarHidden = false
    }
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("farm") as UITableViewCell
        var label = cell.contentView.viewWithTag(1) as UILabel
        label.text = "\(farms.farms_list[indexPath.row].name)"
        return cell
    }
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return farms.farms_list.count
    }
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == FARM_DATA_EDITOR_SEGUE {
            let editor_controller = segue.destinationViewController as FarmDataEditorViewController
            editor_controller.farm = farms.farms_list[self.tableView.indexPathForSelectedRow().row]
            
        }
    }
}
