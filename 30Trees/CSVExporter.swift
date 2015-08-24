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
    var delegate: CSVExporterDelegate?
    init(farms: [FarmData]) {
        self.farms = farms
    }
    func saveFile(fileURL: NSURL, csv: CSVWriter) throws {
        try csv.csv_string.writeToURL(fileURL.filePathURL!, atomically: false, encoding: NSUTF8StringEncoding)
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
        let uniqueURL = temp.URLByAppendingPathComponent(uniqueString, isDirectory: true).filePathURL!
        return uniqueURL
    }
    
    func fileURLGen(name: String, dir: NSURL) -> NSURL {
        var name = name.stringByReplacingOccurrencesOfString("/", withString: "").stringByReplacingOccurrencesOfString(":", withString: "")
        if name.characters.count >= Int(NAME_MAX) {
            name = name.substringWithRange(name.startIndex..<advance(name.startIndex, Int(NAME_MAX)))
        }
        return dir.URLByAppendingPathComponent(name.stringByReplacingOccurrencesOfString("/", withString: "-frwrd_slash-"), isDirectory: false).URLByAppendingPathExtension("csv").filePathURL!
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
                let treesURL = fileURLGen(trees_csv_name, dir: currentDirectory!)
                let farmURL = fileURLGen(farm_csv_name, dir: currentDirectory!)
                try saveFile(treesURL, csv: csv_trees)
                try saveFile(farmURL, csv: csv_farm)
                farmURLs?.append((treesURL, farmURL))
            }
        } catch let error {
            throw CSVExporterError.FailedSetup(error: error)
        }
        print("setup!")
        print(self.farmURLs)
        delegate?.exporterWasSetup(self)
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
        delegate?.exporterWasCleaned(self)
    }

}

enum CSVExporterError: ErrorType {
    case MissingURLs
    case FailedSetup(error: ErrorType?)
    case FailedCleanup(error: ErrorType?)
    case ErrorWithMessage(message: String)
}

