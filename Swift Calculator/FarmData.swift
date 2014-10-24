//
//  FarmData.swift
//  30Trees
//
//  Created by Spruce Bondera on 10/1/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import Foundation

let NAME_KEY = "name"
let SIZE_KEY = "size"
let NUM_TREES_KEY = "num_trees"
let TREES_DATA_KEY = "trees_data"

class FarmData: NSObject, NSCoding, Equatable {
    var name: String
    var size: Double
    var num_trees: Int
    var trees_data: [TreeData]
    
    init(name: String, size: Double, num_trees: Int, tree_data: [TreeData]){
        self.name = name
        self.size = size
        self.num_trees = num_trees
        self.trees_data = tree_data
        super.init()
    }
    
    required init(coder: NSCoder) {
        self.name = coder.decodeObjectForKey(NAME_KEY) as String
        self.size = coder.decodeDoubleForKey(SIZE_KEY)
        self.num_trees = coder.decodeIntegerForKey(NUM_TREES_KEY)
        self.trees_data = coder.decodeObjectForKey(TREES_DATA_KEY) as [TreeData]
    }
    
    convenience init(name: String) {
        self.init(name: name, size: 0, num_trees: 0, tree_data: [])
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(name, forKey: NAME_KEY)
        coder.encodeDouble(size, forKey: SIZE_KEY)
        coder.encodeInteger(num_trees, forKey: NUM_TREES_KEY)
        coder.encodeObject(trees_data, forKey: TREES_DATA_KEY)
        
    }

    
}

func ==(left: FarmData, right: FarmData) -> Bool {
    return left.name == right.name && left.size == right.size && left.num_trees == right.num_trees && left.trees_data == right.trees_data
}
