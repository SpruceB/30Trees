// This class stores the data that needs to be taken on a single tree, specifically the number of green cherries (green),
// the number of CBB infested cherries (cbb), and the number of B. Bassiana fungus infected cherries (fungus). It also allows
// for archiving of this data into NSData objects through the NSCoding protocol, and implements Equatable.

import Foundation

let GREEN_KEY = "green"
let CBB_KEY = "cbb"
let FUNGUS_KEY = "fungus"
let DATE_KEY = "date"

class TreeData: NSObject, NSCoding {
    var green: Int
    var cbb: Int
    var fungus: Int
    var date_created: NSDate
    
    init(green:Int, cbb: Int, fungus: Int, date_created: NSDate){
        self.green = green
        self.cbb = cbb
        self.fungus = fungus
        self.date_created = date_created
        super.init()
    }
    
    // start_num is only included so this method doesn't have the same signature as the superclass (NSObject) init
    convenience init(start_num: Int = 0){
        self.init(green: start_num, cbb: start_num, fungus: start_num, date_created: NSDate())
    }
    
    required init(coder: NSCoder) {
        self.green = coder.decodeIntegerForKey(GREEN_KEY)
        self.cbb = coder.decodeIntegerForKey(CBB_KEY)
        self.fungus = coder.decodeIntegerForKey(FUNGUS_KEY)
        self.date_created = coder.decodeObjectForKey(DATE_KEY) as! NSDate
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeInteger(green, forKey: GREEN_KEY)
        coder.encodeInteger(cbb, forKey: CBB_KEY)
        coder.encodeInteger(fungus, forKey: FUNGUS_KEY) 
        coder.encodeObject(date_created, forKey: DATE_KEY)
    }
}

func ==(left: TreeData, right: TreeData) -> Bool {
    return left.green == right.green && left.cbb == right.cbb && left.fungus == right.fungus
}