// This class stores the data for a single farm, which includes a list of data collected from trees (trees_data),
// an estimate of the number of trees on the farm (num_trees), an estimate of the size of the farm in acres (size),
// and of course the name of the farm (name).

import Foundation

let NAME_KEY = "name"
let SIZE_KEY = "size"
let NUM_TREES_KEY = "num_trees"
let TREES_DATA_KEY = "trees_data"
let AB_ALIVE = "ab_alive"
let AB_DEAD = "ab_dead"
let AB_ABSENT = "ab_absent"
let CD = "cd"
let LOCATION = "location"
let GROWER_KEY = "grower"
let PHONE_KEY = "phone_number"
let LAST_SPRAY_DATE_KEY = "last_spray_date"

class FarmData: NSObject, NSCoding {
    var name: String
    var size: Double
    var num_trees: Int
    var trees_data: [TreeData]
    var ab_alive: Int
    var ab_dead: Int
    var ab_absent: Int
    var cd: Int
    var location: String
    var grower_name: String?
    var phone_number: String?
    var last_spray_date: NSDate?
    
    init(name: String, size: Double, num_trees: Int, trees_data:[TreeData], ab_alive: Int, ab_dead: Int, ab_absent: Int, cd: Int, location: String, grower_name: String?, phone_number: String?, last_spray_date: NSDate?) {
        self.name = name
        self.size = size
        self.num_trees = num_trees
        self.trees_data = trees_data
        self.ab_alive = ab_alive
        self.ab_dead = ab_dead
        self.ab_absent = ab_absent
        self.cd = cd
        self.location = location
        self.grower_name = grower_name
        self.phone_number = phone_number
        self.last_spray_date = last_spray_date
            
        super.init()
    }
    
    required init(coder: NSCoder) {
        if let name = coder.decodeObjectForKey(NAME_KEY) as! String? {
            self.name = name
        } else {
            self.name = "DEFAULT_NAME"
        }
        self.size = coder.decodeDoubleForKey(SIZE_KEY)
        self.num_trees = coder.decodeIntegerForKey(NUM_TREES_KEY)
        if let trees_data = coder.decodeObjectForKey(TREES_DATA_KEY) as! [TreeData]? {
            self.trees_data = trees_data
        } else {
            self.trees_data = []
        }
        self.ab_alive = coder.decodeIntegerForKey(AB_ALIVE)
        self.ab_dead = coder.decodeIntegerForKey(AB_DEAD)
        self.ab_absent = coder.decodeIntegerForKey(AB_ABSENT)
        self.cd = coder.decodeIntegerForKey(CD)
        if let location = coder.decodeObjectForKey(LOCATION) as! String? {
            self.location = location
        } else {
            self.location = ""
        }
        self.grower_name = coder.decodeObjectForKey(GROWER_KEY) as? String
        self.phone_number = coder.decodeObjectForKey(PHONE_KEY) as? String
        self.last_spray_date = coder.decodeObjectForKey(LAST_SPRAY_DATE_KEY) as? NSDate
    }
    
    convenience init(name: String) {
        self.init(name: name, size: 0, num_trees: 0, trees_data: [], ab_alive: 0, ab_dead: 0, ab_absent: 0, cd: 0, location: "", grower_name: nil, phone_number: nil, last_spray_date: nil)
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(name, forKey: NAME_KEY)
        coder.encodeDouble(size, forKey: SIZE_KEY)
        coder.encodeInteger(num_trees, forKey: NUM_TREES_KEY)
        coder.encodeObject(trees_data, forKey: TREES_DATA_KEY)
        coder.encodeInteger(ab_alive, forKey: AB_ALIVE)
        coder.encodeInteger(ab_dead, forKey: AB_DEAD)
        coder.encodeInteger(ab_absent, forKey: AB_ABSENT)
        coder.encodeInteger(cd, forKey: CD)
        coder.encodeObject(location, forKey: LOCATION)
        coder.encodeObject(grower_name, forKey: GROWER_KEY)
        coder.encodeObject(phone_number, forKey: PHONE_KEY)
        coder.encodeObject(last_spray_date, forKey: LAST_SPRAY_DATE_KEY)
    }

    
}

func ==(left: FarmData, right: FarmData) -> Bool {
    return (left.name == right.name) &&
            (left.size == right.size) &&
            (left.num_trees == right.num_trees) &&
            (left.trees_data == right.trees_data) &&
            (left.ab_alive == right.ab_alive) &&
            (left.ab_dead == right.ab_dead) &&
            (left.ab_absent == right.ab_absent) &&
            (left.cd == right.cd) &&
            (left.location == right.location) &&
            (left.grower_name == right.grower_name) &&
            (left.phone_number == right.phone_number) &&
            (left.last_spray_date == right.last_spray_date)
}
