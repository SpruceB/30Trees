//
//  FarmData.swift
//  30Trees
//
//  Created by Spruce Bondera on 10/1/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import Foundation

class FarmData {
    var name: String
    var size: Double
    var num_trees: Int
    var tree_data: [Tree]
    init(name: String, size: Double, num_trees: Int, tree_data: [Tree]){
        self.name = name
        self.size = size
        self.num_trees = num_trees
        self.tree_data = tree_data
    }
    convenience init(name: String) {
        self.init(name: name, size: 0, num_trees: 0, tree_data: [])
    }
    convenience init(from_array data_array: [AnyObject]) {
        self.init(name: (data_array[0] as String), size: (data_array[1] as Double), num_trees: (data_array[2] as Int), tree_data: (data_array[3] as [Tree]))
    }
    func toArray() -> [AnyObject] {
        return [self.name, self.size, self.num_trees, self.tree_data]
    }
}

class Tree {
    var cbb_alive: Int
    init(cbb_alive: Int){
        self.cbb_alive = cbb_alive
    }
}