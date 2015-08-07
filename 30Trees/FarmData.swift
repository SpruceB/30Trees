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
let CD = "cd"
let LOCATION = "location"

class FarmData: NSObject, NSCoding {
    var name: String
    var size: Double
    var num_trees: Int
    var trees_data: [TreeData]
    var ab_alive: Int
    var ab_dead: Int
    var cd: Int
    var location: String
    
    init(name: String, size: Double, num_trees: Int, trees_data: [TreeData],
         ab_alive: Int, ab_dead: Int, cd: Int, location: String){
        self.name = name
        self.size = size
        self.num_trees = num_trees
        self.trees_data = trees_data
        self.ab_alive = ab_alive
        self.ab_dead = ab_dead
        self.cd = cd
        self.location = location
        super.init()
    }
    
    required init(coder: NSCoder) {
        self.name = coder.decodeObjectForKey(NAME_KEY) as! String
        self.size = coder.decodeDoubleForKey(SIZE_KEY)
        self.num_trees = coder.decodeIntegerForKey(NUM_TREES_KEY)
        self.trees_data = coder.decodeObjectForKey(TREES_DATA_KEY) as! [TreeData]
        self.ab_alive = coder.decodeIntegerForKey(AB_ALIVE)
        self.ab_dead = coder.decodeIntegerForKey(AB_DEAD)
        self.cd = coder.decodeIntegerForKey(CD)
        self.location = coder.decodeObjectForKey(LOCATION) as! String
        
    }
    
    convenience init(name: String) {
        self.init(name: name, size: 0, num_trees: 0, trees_data: [], ab_alive: 0, ab_dead: 0, cd: 0, location: "")
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(name, forKey: NAME_KEY)
        coder.encodeDouble(size, forKey: SIZE_KEY)
        coder.encodeInteger(num_trees, forKey: NUM_TREES_KEY)
        coder.encodeObject(trees_data, forKey: TREES_DATA_KEY)
        coder.encodeInteger(ab_alive, forKey: AB_ALIVE)
        coder.encodeInteger(ab_dead, forKey: AB_DEAD)
        coder.encodeInteger(cd, forKey: CD)
        coder.encodeObject(location, forKey: LOCATION)
    }

    
}

func ==(left: FarmData, right: FarmData) -> Bool {
    return (left.name == right.name) && (left.size == right.size) && (left.num_trees == right.num_trees) &&
                (left.trees_data == right.trees_data) && (left.ab_alive == right.ab_alive) &&
                (left.ab_dead == right.ab_dead) && (left.cd == right.cd) && (left.location == right.location)
}
