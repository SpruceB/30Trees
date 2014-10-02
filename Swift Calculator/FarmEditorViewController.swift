//
//  FarmEditorViewController.swift
//  30Trees
//
//  Created by Spruce Bondera on 9/30/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import UIKit

class FarmEditorViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("farm") as UITableViewCell
        println(cell)
        var label = cell.contentView.viewWithTag(1) as UILabel
        label.text = "\(indexPath.row + 1)"
        return cell
    }
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }
}
