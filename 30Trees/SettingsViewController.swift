import UIKit
let FARM_EDITOR_SEGUE = "FarmEditorPushSegue"
class SettingsViewController: UITableViewController, UITableViewDelegate, UINavigationControllerDelegate {
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
    
    func exportData() {
        if let farm = FarmDataController.sharedInstance.selected_farm {
            var csv_data = CSVExporter()
            csv_data.writeFarmData(farm)
            csv_data.emailFile(farm.name, recipient: "sprucebondera@gmail.com", view: self)
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

