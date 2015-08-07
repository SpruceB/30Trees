//
//  ReminderViewController.swift
//  30Trees
//
//  Created by Spruce Bondera on 12/14/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import UIKit

let SELECTED_REMINDER_INTERVAL_KEY = "reminder interval key"

class ReminderViewController: UITableViewController {
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    var last_selected_cell: UITableViewCell? = nil
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selected_row = indexPath.row
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        if selected_row != 0 {
            let reminder = UILocalNotification()
            var reminder_interval: NSCalendarUnit? = nil
            let reminder_date_components: NSDateComponents = NSDateComponents()
            switch selected_row {
                case 1:
                    reminder_interval = NSCalendarUnit.NSDayCalendarUnit
                    reminder_date_components.day = 1
                case 2:
                    reminder_interval = NSCalendarUnit.NSWeekCalendarUnit
                    reminder_date_components.day = 7
                case 3:
                    reminder_interval = NSCalendarUnit.NSMonthCalendarUnit
                    reminder_date_components.month = 1
                case 4:
                    reminder_interval = NSCalendarUnit.NSYearCalendarUnit
                    reminder_date_components.year = 1
                default:
                    NSException(name: "UnknownReminderIntervalException", reason: "Non-existant reminder interval index", userInfo:["index": selected_row]).raise()
            }
            let cal = NSCalendar.currentCalendar()
            let current_date = NSDate()
            let reminder_date = cal.dateByAddingComponents(reminder_date_components, toDate: current_date, options: NSCalendarOptions())

            reminder.fireDate = reminder_date
            reminder.timeZone = NSTimeZone.defaultTimeZone()
            reminder.repeatInterval = reminder_interval!
            reminder.alertBody = "Remember to check your trees for CBB!"
            reminder.hasAction = false
            UIApplication.sharedApplication().scheduleLocalNotification(reminder)
        }
        NSUserDefaults.standardUserDefaults().setInteger(selected_row, forKey: SELECTED_REMINDER_INTERVAL_KEY)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        last_selected_cell?.accessoryType = UITableViewCellAccessoryType.None
        last_selected_cell = cell
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBarHidden = false
        
        let selected_row = NSUserDefaults.standardUserDefaults().integerForKey(SELECTED_REMINDER_INTERVAL_KEY)
        let selected_index_path = NSIndexPath(forRow: selected_row, inSection: 0)
        self.tableView.selectRowAtIndexPath(selected_index_path, animated: false, scrollPosition: UITableViewScrollPosition.None)
        self.tableView(self.tableView, didSelectRowAtIndexPath: selected_index_path)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
}
