import UIKit
import MessageUI

let FARM_EDITOR_SEGUE = "FarmEditorPushSegue"
class SettingsViewController: UITableViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet var farmSettingsCell: UITableViewCell!
    @IBOutlet var reminderSettingsCell: UITableViewCell!
    
    override func viewDidLoad() {
        self.tableView.alwaysBounceVertical = false
        self.tableView.scrollEnabled = false
        self.tableView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            exportData()
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        print("mailComposeController called")
        if result == MFMailComposeResultSent { print("sent!") }
        print(result)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func exportData() {
        if let farm = FarmDataController.sharedInstance.selected_farm {
            let csv_data = CSVExporter()
            csv_data.writeFarmData(farm)
            print("cvs")
            print(csv_data.csv_string)
            csv_data.emailFile(farm.name, recipient: "sprucebondera@gmail.com", viewController: self)
        } else {
            UIAlertView(title: "No Farm Selected", message: "You must select a farm to export farm data", delegate: nil, cancelButtonTitle: "OK").show()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    override func viewWillAppear(animated: Bool) {
        if let farm = FarmDataController.sharedInstance.selected_farm {
            farmSettingsCell.textLabel?.text = farm.name
            farmSettingsCell.textLabel?.textColor = farmSettingsCell.tintColor
        } else {
            farmSettingsCell.textLabel?.text = "No farm selected"
            farmSettingsCell.textLabel?.textColor = UIColor.lightGrayColor()
        }
        let reminder_text = ["Never", "Every Day", "Every Week", "Every Month", "Every Year"]
        
        var index = NSUserDefaults.standardUserDefaults().objectForKey(SELECTED_REMINDER_INTERVAL_KEY) as? Int
        if index == nil {
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: SELECTED_REMINDER_INTERVAL_KEY)
            index = 0
        }
        reminderSettingsCell.textLabel?.text = reminder_text[index!]
        
        self.navigationController!.navigationBarHidden = true
        self.tableView.reloadData()
    }
}

