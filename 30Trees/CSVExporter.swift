//
//  CSVExporter.swift
//  30Trees
//
//  Created by Spruce Bondera on 11/15/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import Foundation
import MessageUI

class CSVExporter {
    var csv_string = ""
    let deliminator: String
    let newline: String
    
    init(deliminator:String=",", newline:String="\n") {
        self.deliminator = deliminator
        self.newline = newline
    }
    
    func writeField(field: AnyObject){
        var write_string: String = field.description
        if contains(Array(write_string), "\"") {
            write_string = (write_string as String).stringByReplacingOccurrencesOfString("\"", withString: "\"\"")
        }
        
        write_string = "\"\(write_string)\""
        write_string = write_string + deliminator
        csv_string += write_string
    }
    
    func writeFields(fields: [AnyObject]) {
        for field in fields {
            writeField(field)
        }
    }
    
    func endLine() {
        // Skips the last character to avoid the trailing deliminator added on by writeField
        csv_string = csv_string[csv_string.startIndex..<advance(csv_string.endIndex, -1)] + newline
    }
    
    func writeLine(fields: [AnyObject]) {
        writeFields(fields)
        endLine()
    }
    
    func writeFarmData(farm: FarmData) {
        writeLine(["Green", "Fungus", "CBB", "Date"])
        for tree in farm.trees_data {
            writeLine([tree.green, tree.fungus, tree.cbb, tree.date_created])
        }
    }
    
    func saveFile(filename: String, directory_path: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)[0] as String) -> String {
        let filepath = directory_path + "/\(filename)"
        csv_string.writeToFile(filepath, atomically: false, encoding: NSUnicodeStringEncoding, error: nil)
        return filepath
    }
    
    func deleteFile(filename: String, directory_path: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)[0] as String) {
        NSFileManager.defaultManager().removeItemAtPath(directory_path + "/\(filename)", error: nil)
    }
    
    func emailFile<T: UIViewController where T: UINavigationControllerDelegate>(filename: String, recipient: String, view: T) {
        let mail_composer = MFMailComposeViewController()
        mail_composer.delegate = view
        mail_composer.setToRecipients([recipient])
        // TODO: Figure out good subject line
        mail_composer.setSubject("30Trees Subject Line")
        mail_composer.setMessageBody("Testing!\n", isHTML: false)
        deleteFile(filename)
        let filepath = saveFile(filename)
        let data = NSData.dataWithContentsOfMappedFile(filepath) as NSData
        mail_composer.addAttachmentData(data, mimeType: "text/csv", fileName: filename)
        view.presentViewController(mail_composer, animated: true, nil)
        deleteFile(filename)
    }
}
