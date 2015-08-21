//
//  CSVExporter.swift
//  30Trees
//
//  Created by Spruce Bondera on 11/15/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import Foundation
import MessageUI
class CSVWriter {
    var csv_string = ""
    let deliminator: String
    let newline: String
    
    init(deliminator:String=",", newline:String="\n") {
        self.deliminator = deliminator
        self.newline = newline
    }
    
    convenience init(farm: FarmData) {
        self.init()
        self.writeFarmData(farm)
    }
    
    func writeField(field: AnyObject) {
        var write_string = field.description
        write_string = write_string.stringByReplacingOccurrencesOfString("\"", withString: "\"\"")
        write_string = "\"\(write_string)\""
        write_string.extend(deliminator)
        csv_string.extend(write_string)
    }
    
    func writeFields(fields: [AnyObject]) {
        for field in fields {
            writeField(field)
        }
    }
    
    func writeLine(fields: [AnyObject]) {
        writeFields(fields)
        // Skips the last character to avoid the trailing deliminator added on by writeField
        csv_string = csv_string.substringToIndex(csv_string.endIndex.predecessor()).stringByAppendingString(newline)
    }
    
    func writeFarmData(farm: FarmData) {
        writeLine(["Green", "Fungus", "CBB"])//, "Date"])
        for tree in farm.trees_data {
            writeLine([tree.green, tree.fungus, tree.cbb])//, tree.date_created])
        }
        // Skips last newline
        csv_string = csv_string.substringToIndex(csv_string.endIndex.predecessor())
    }
}

class CSVExporter {
    let farms: [FarmData]
    var currentDirectory: NSURL?
    var farmURLs: [NSURL]?
    var setup = false
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
        let manager = NSFileManager.defaultManager()
        let documents = manager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last
        let uniqueString = NSProcessInfo().globallyUniqueString
        let uniqueURL = documents?.URLByAppendingPathComponent(uniqueString, isDirectory: true)
        return uniqueURL!
    }
    
    func fileURL(name: String, dir: NSURL) -> NSURL {
        return dir.URLByAppendingPathComponent(name.stringByReplacingOccurrencesOfString("/", withString: "-frwrd_slash-"), isDirectory: false).URLByAppendingPathExtension("txt")
    }
    
    func setupFiles() throws {
        setup = true
        currentDirectory = tempDirectory()
        let manager = NSFileManager.defaultManager()
        try manager.createDirectoryAtURL(currentDirectory!, withIntermediateDirectories: false, attributes: nil)
        farmURLs = []
        for farm in self.farms {
            let csv = CSVWriter(farm: farm)
            let farmURL = currentDirectory?.URLByAppendingPathComponent(farm.name, isDirectory: false).URLByAppendingPathExtension("csv")
            try saveFile(farmURL!, csv: csv)
            farmURLs?.append(farmURL!)
        }
        print("setup!")
        print(self.farmURLs)
    }
    
    func cleanupFiles() {
        let manager = NSFileManager.defaultManager()
        do {
            for url in farmURLs! {
                    try manager.removeItemAtURL(url.filePathURL!)
            }
            try manager.removeItemAtURL(currentDirectory!)
        } catch {}
        farmURLs = nil
        currentDirectory = nil
        print("cleaned!")
        setup = false
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
