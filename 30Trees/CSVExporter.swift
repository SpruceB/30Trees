//
//  CSVExporter.swift
//  30Trees
//
//  Created by Spruce Bondera on 11/15/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import Foundation

class CSVWriter {
    var csv_string = ""
    let deliminator: String
    let newline: String
    

    func convertDate(date: NSDate?) -> String? {
        let f = NSDateFormatter()
        f.timeStyle = NSDateFormatterStyle.NoStyle
        f.dateStyle = NSDateFormatterStyle.LongStyle
        f.locale = NSLocale.currentLocale()
        if date != nil {
            return f.stringFromDate(date!)
        } else {
            return nil
        }
    }
    
    init(deliminator:String=",", newline:String="\n") {
        self.deliminator = deliminator
        self.newline = newline
    }
    
    convenience init(farmForTrees: FarmData) {
        self.init()
        self.writeFarmTreeData(farmForTrees)
    }
    
    convenience init(farmForFarm: FarmData) {
        self.init()
        self.writeFarmData(farmForFarm)
    }
    
    func writeField(field: AnyObject) {
        var write_string = field.description
        write_string = write_string.stringByReplacingOccurrencesOfString("\"", withString: "\"\"")
        write_string = "\"\(write_string)\""
        write_string.extend(deliminator)
        csv_string.extend(write_string)
    }
    
    func writeFields(fields: [AnyObject?]) {
        for field in fields {
            if field != nil {
                writeField(field!)
            } else {
                writeField("Unkown")
            }
        }
    }
    
    func writeLine(fields: [AnyObject?]) {
        writeFields(fields)
        // Skips the last character to avoid the trailing deliminator added on by writeField
        csv_string = csv_string.substringToIndex(csv_string.endIndex.predecessor()).stringByAppendingString(newline)
    }
    
    func writeFarmTreeData(farm: FarmData) {
        writeLine(["Green", "Fungus", "CBB", "Date"])
        for tree in farm.trees_data {
            writeLine([tree.green, tree.fungus, tree.cbb, convertDate(tree.date_created)])
        }
        // Skips last newline
        csv_string = csv_string.substringToIndex(csv_string.endIndex.predecessor())
    }
    func writeFarmData(farm: FarmData) {
        let data: [(String, AnyObject?)] = [
            ("Farm Name", farm.name),
            ("Grower Name", farm.grower_name),
            ("TMK", farm.location),
            ("Phone Number", farm.phone_number),
            ("Farm Size (acres)", farm.size),
            ("Number of Trees", farm.num_trees),
            ("AB Alive", farm.ab_alive),
            ("AB Dead", farm.ab_dead),
            ("AB Absent", farm.ab_absent),
            ("CD", farm.cd),
            ("Last Spray Date", convertDate(farm.last_spray_date))
        ]
        for (name, item) in data {
            writeLine([name, item])
        }
    }
}

protocol CSVExporterDelegate {
    func exporterWasSetup(sender: CSVExporter)
    func exporterWasCleaned(sender: CSVExporter)
}

class CSVExporter {
    let farms: [FarmData]
    var currentDirectory: NSURL?
    var farmURLs: [(NSURL, NSURL)]?
    var setup = false
    var delgate: CSVExporterDelegate?
    init(farms: [FarmData]) {
        self.farms = farms
    }
    func saveFile(fileURL: NSURL, csv: CSVWriter) throws {
        try csv.csv_string.writeToURL(fileURL.filePathURL!, atomically: false, encoding: NSUnicodeStringEncoding)
    }
    
    func deleteFile(fileURL: NSURL) throws {
        let manager = NSFileManager.defaultManager()
        if manager.fileExistsAtPath(fileURL.path!) {
            try manager.removeItemAtURL(fileURL.filePathURL!)
        }
    }
    
    func tempDirectory() -> NSURL {
        let temp = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let uniqueString = NSProcessInfo().globallyUniqueString
        let uniqueURL = temp.URLByAppendingPathComponent(uniqueString, isDirectory: true)
        return uniqueURL
    }
    
    func fileURL(name: String, dir: NSURL) -> NSURL {
        return dir.URLByAppendingPathComponent(name.stringByReplacingOccurrencesOfString("/", withString: "-frwrd_slash-"), isDirectory: false).URLByAppendingPathExtension("txt")
    }
    
    func setupFiles() throws {
        setup = true
        currentDirectory = tempDirectory()
        let manager = NSFileManager.defaultManager()
        do {
            try manager.createDirectoryAtURL(currentDirectory!, withIntermediateDirectories: false, attributes: nil)
            farmURLs = []
            for farm in self.farms {
                let csv_trees = CSVWriter(farmForTrees: farm)
                let trees_csv_name = farm.name + " Tree Data"
                let csv_farm = CSVWriter(farmForFarm: farm)
                let farm_csv_name = farm.name + " Farm Data"
                let treesURL = currentDirectory?.URLByAppendingPathComponent(trees_csv_name, isDirectory: false).URLByAppendingPathExtension("csv")
                let farmURL = currentDirectory?.URLByAppendingPathComponent(farm_csv_name, isDirectory: false).URLByAppendingPathExtension("csv")
                try saveFile(treesURL!, csv: csv_trees)
                try saveFile(farmURL!, csv: csv_farm)
                farmURLs?.append((treesURL!, farmURL!))
            }
        } catch let error {
            throw CSVExporterError.FailedSetup(error: error)
        }
        print("setup!")
        print(self.farmURLs)
        delgate?.exporterWasSetup(self)
    }
    
    func cleanupFiles() throws {
        let manager = NSFileManager.defaultManager()
        do {
            for (treeURL, farmURL) in farmURLs! {
                if manager.fileExistsAtPath(treeURL.path!) {
                    try manager.removeItemAtURL(treeURL.filePathURL!)
                }
                if manager.fileExistsAtPath(farmURL.path!) {
                    try manager.removeItemAtURL(farmURL.filePathURL!)
                }
            }
            if let path = currentDirectory?.path {
                if manager.fileExistsAtPath(path) {
                    try manager.removeItemAtURL(currentDirectory!)
                }
            }
        } catch let error {
            throw CSVExporterError.FailedCleanup(error: error)
        }
        farmURLs = nil
        currentDirectory = nil
        print("cleaned!")
        setup = false
        delgate?.exporterWasCleaned(self)
    }

    
//    func emailFile<T: UIViewController where T: UINavigationControllerDelegate, T: MFMailComposeViewControllerDelegate>(filename: String, recipient: String, viewController: T) {
//        if MFMailComposeViewController.canSendMail() {
//            let mail_composer = MFMailComposeViewController()
//            mail_composer.mailComposeDelegate = viewController
//            mail_composer.setToRecipients([recipient])
//            // TODO: Figure out good subject line
//            mail_composer.setSubject("30Trees Subject Line")
//            mail_composer.setMessageBody("Testing!\n", isHTML: false)
//            do {
//                if NSFileManager.defaultManager().fileExistsAtPath(filename) {
//                    try deleteFile(filename)
//                }
//                let filepath = try saveFile(filename)
//                let data = NSData.dataWithContentsOfMappedFile(filepath) as! NSData
//                mail_composer.addAttachmentData(data, mimeType: "text/csv", fileName: filename)
//                print("mail presenting")
//                viewController.presentViewController(mail_composer, animated: true, completion: nil)
//                print("mail presented")
//                if NSFileManager.defaultManager().fileExistsAtPath(filename) {
//                    try deleteFile(filename)
//                }
//            }
//            catch let error as NSError where error.domain == NSCocoaErrorDomain && error.code == 4 {
//                print("Cocoa Error")
//                UIAlertView(title: "An error has occured", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
//                print(error)
//            }
//            catch let error {
//                print("Unknown error: \(error)")
//                UIAlertView(title: "An error has occured", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
//            }
//        } else {
//            UIAlertView(title: "Device cannot send emails", message: "Your device must be able to send emails to export data", delegate: nil, cancelButtonTitle: "OK").show()
//        }
//    }
}

enum CSVExporterError: ErrorType {
    case MissingURLs
    case FailedSetup(error: ErrorType?)
    case FailedCleanup(error: ErrorType?)
    case ErrorWithMessage(message: String)
}

