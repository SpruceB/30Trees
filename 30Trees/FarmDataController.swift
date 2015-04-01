// FarmDataController is a singleton that holds the user created farms as well as the currently selected farm.
// It also handles saving the data to NSUserDefaults (although it will use Core Data in the future).


import Foundation
// The swift method of implementing the singleton pattern. Also uses the persisted_data class property
// of FarmDataController to set the sharedInstance to the version in data storage (or a new instance if there isn't one).
let persisted = FarmDataController.persisted_data
let FarmDataControllerSharedInstance = persisted != nil ? persisted! : FarmDataController()

let FARMS_DATA_KEY = "farms"
let FARMS_LIST_KEY = "farms_list"
let SELECTED_FARM_KEY = "selected_farm"
let SELECTED_FARM_INDEX_KEY = "selected_farm_index"

class FarmDataController: NSObject, NSCoding {
    
    // Part of the singleton pattern. Always returns same instance, which is defined outside of the class.
    class var sharedInstance: FarmDataController {
        return FarmDataControllerSharedInstance
    }
    
    // Automatically archives/unarchives data from/to NSUserDefaults.
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

        self.selected_farm_index = coder.decodeObjectForKey(SELECTED_FARM_INDEX_KEY) as Int?
        if let index = selected_farm_index {
            self.selected_farm = farms_list[index]
        } else {
            self.selected_farm = nil
        }
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(farms_list, forKey: FARMS_LIST_KEY)
        coder.encodeObject(selected_farm, forKey: SELECTED_FARM_KEY)
        coder.encodeObject(selected_farm_index, forKey: SELECTED_FARM_INDEX_KEY)
    }
    
    func sync() {
        FarmDataController.persisted_data = self
    }
}

