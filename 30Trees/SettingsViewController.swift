import UIKit
import MessageUI
import QuickLook

let FARM_EDITOR_SEGUE = "FarmEditorPushSegue"
class SettingsViewController: UITableViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet var farmSettingsCell: UITableViewCell!
    @IBOutlet var reminderSettingsCell: UITableViewCell!
    
    var admin = "sprucebondera@gmail.com"
    
    override func viewDidLoad() {
        self.tableView.alwaysBounceVertical = false
        self.tableView.scrollEnabled = false
        self.tableView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
            exportButtonPressed()
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        print("yaya")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func errorAlert(title: String?, message: String?) {
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    func exportButtonPressed() {
        if let farm = FarmDataController.sharedInstance.selected_farm {
            if #available(iOS 8.0, *) {
                let menu = UIAlertController(title: "Export", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                menu.addAction(UIAlertAction(title: "Email", style: UIAlertActionStyle.Default, handler: {U in self.emailData(farm)}))
                menu.addAction(UIAlertAction(title: "Send to Admin", style: UIAlertActionStyle.Default, handler: {U in self.emailData(farm, toAdmin: true)}))
                menu.addAction(UIAlertAction(title: "Print", style: UIAlertActionStyle.Default, handler: {U in self.printData(farm)}))
                
                menu.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                    let cellIndex = NSIndexPath(forRow: 0, inSection: 2)
                    let exportCellLabel = self.tableView.cellForRowAtIndexPath(cellIndex)
                    let popover = menu.popoverPresentationController
                    popover?.sourceView = exportCellLabel
                    popover?.sourceRect = exportCellLabel!.bounds
                    presentViewController(menu, animated: true, completion: nil)
                }
                else {
                    self.presentViewController(menu, animated: true, completion: nil)
                }
            } else {
                let menu = UIAlertView(title: "test", message: "test", delegate: nil, cancelButtonTitle: "nil")
                menu.show()
            }
        } else {
            self.errorAlert("No Farm Selected", message: "You need to select a farm before exporting data")
        }
    }
    
    func emailData(farm: FarmData, toAdmin: Bool = false) {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        if toAdmin {
            mailComposer.setToRecipients([admin])
            mailComposer.setSubject("Thirty Trees Sampling Data")
            mailComposer.setMessageBody("Farm data", isHTML: false)
        }
        let exporter = CSVExporter(farms: [farm])
        exporter.delegate = UIApplication.sharedApplication().delegate as? CSVExporterDelegate
        do {
            try exporter.setupFiles()
            if let urls = exporter.farmURLs {
                for (trees_csv_url, farm_csv_url) in urls {
                    if let trees_data = NSData(contentsOfURL: trees_csv_url),
                            farm_data = NSData(contentsOfURL: farm_csv_url) {
                                
                        mailComposer.addAttachmentData(trees_data, mimeType: "text/csv", fileName: trees_csv_url.lastPathComponent!)
                        mailComposer.addAttachmentData(farm_data, mimeType: "text/csv", fileName: farm_csv_url.lastPathComponent!)
                        self.presentViewController(mailComposer, animated: true, completion: nil)
                    } else {
                        throw CSVExporterError.MissingURLs
                    }
                }
            } else {
                throw CSVExporterError.FailedSetup(error: CSVExporterError.MissingURLs)
            }
            try exporter.cleanupFiles()
        } catch CSVExporterError.MissingURLs {
            self.errorAlert("Export data missing", message: "The data to export could not be found. Try again later.")
        } catch CSVExporterError.FailedSetup(let error) {
            self.errorAlert("Export setup failed", message: "The data to export failed to set up properly. Try again later.")
            print(error)
            do {
                try exporter.cleanupFiles()
            } catch {}
        } catch CSVExporterError.FailedCleanup(let error) {
            self.errorAlert("Data cleanup failed", message: "It will be cleared automatically later.")
            print(error)
        }
        catch {
            self.errorAlert("An unkown error occured", message: "Try again after later.")
        }
    }
    
    func printData(farm: FarmData) {
        
        if UIPrintInteractionController.isPrintingAvailable() {
            let printController = UIPrintInteractionController.sharedPrintController()
            let exporter = CSVExporter(farms: [farm])
            
            do {
                try exporter.setupFiles()
                if let trees_url = exporter.farmURLs?.first?.0, farm_url = exporter.farmURLs?.first?.1 {
                    let trees_web_view = UIWebView()
                    trees_web_view.loadRequest(NSURLRequest(URL: trees_url))
                    let farm_web_vew = UIWebView()
                    farm_web_vew.loadRequest(NSURLRequest(URL: farm_url))
                    
                    let info = UIPrintInfo.printInfo()
                    info.duplex = UIPrintInfoDuplex.None
                    info.orientation = UIPrintInfoOrientation.Portrait
                    info.outputType = UIPrintInfoOutputType.Grayscale
                    let renderer = UIPrintPageRenderer()
                    let farm_web_view_formatter = farm_web_vew.viewPrintFormatter()
                    renderer.addPrintFormatter(farm_web_view_formatter, startingAtPageAtIndex: 0)
                    renderer.addPrintFormatter(trees_web_view.viewPrintFormatter(), startingAtPageAtIndex: 1)
                    printController.printPageRenderer = renderer
                    printController.showsPageRange = true
                    printController.printInfo = info

                    printController.presentAnimated(true, completionHandler:
                        {controller, successful, error in
                            do {
                                try exporter.cleanupFiles()
                            } catch CSVExporterError.FailedCleanup(let cleanup_error) {
                                print(cleanup_error)
                            } catch {}
                            if !successful && error != nil {
                                self.errorAlert("Print failed", message: "Try again")}})
                    
                } else {
                    throw CSVExporterError.MissingURLs
                }
                
            } catch is CSVExporterError {
                self.errorAlert("Failed data setup", message: "Try again later")
            } catch {
                self.errorAlert("An unknown error occured", message: "Try again later")
            }
        } else {
            errorAlert("This device can't print", message: "Try on a different device")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()

        print(self.tableView.indexPathForSelectedRow)
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
