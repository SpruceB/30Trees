//
//  FarmDataController.swift
//  30Trees
//
//  Created by Spruce Bondera on 10/1/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import Foundation

let persisted = FarmDataController.persisted_data
let FarmDataControllerSharedInstance = persisted != nil ? persisted! : FarmDataController()

let FARMS_DATA_KEY = "farms"
let FARMS_LIST_KEY = "farms_list"
let SELECTED_FARM_KEY = "selected_farm"
let SELECTED_FARM_INDEX_KEY = "selected_farm_index"

class FarmDataController: NSObject, NSCoding {
    
    class var sharedInstance: FarmDataController {
        return FarmDataControllerSharedInstance
    }
    
    class var persisted_data: FarmDataController? {
        get {
            if let data = NSUserDefaults.standardUserDefaults().dataForKey(FARMS_DATA_KEY) {
                return NSKeyedUnarchiver.unarchiveObjectWithData(data) as FarmDataController?
            } else {
                return nil
            }
        }
        
        set {
            var defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(newValue!), forKey: FARMS_DATA_KEY)
            defaults.synchronize()
        }
    }
    
    var farms_list: [FarmData] = [] {
        didSet {
            sync()
        }
    }
    
    var selected_farm: FarmData?
    var selected_farm_index: Int?
    
    
    override init(){
        super.init()
        sync()
    }
    
    required init(coder: NSCoder) {
        self.farms_list = coder.decodeObjectForKey(FARMS_LIST_KEY) as [FarmData]
        self.selected_farm = coder.decodeObjectForKey(SELECTED_FARM_KEY) as FarmData?
        self.selected_farm_index = coder.decodeObjectForKey(SELECTED_FARM_INDEX_KEY) as Int?
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(farms_list, forKey: FARMS_LIST_KEY)
        coder.encodeObject(selected_farm, forKey: SELECTED_FARM_KEY)
        coder.encodeObject(selected_farm_index, forKey: SELECTED_FARM_INDEX_KEY)
    }
    
    func sync() {
        println("Testing")
        FarmDataController.persisted_data = self
    }
}

