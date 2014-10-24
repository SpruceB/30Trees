//
//  TreeData.swift
//  30Trees
//
//  Created by Spruce Bondera on 10/14/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import Foundation

let GREEN_KEY = "green"
let CBB_KEY = "cbb"
let FUNGUS_KEY = "fungus"

class TreeData: NSObject, NSCoding, Equatable {
    var green: Int
    var cbb: Int
    var fungus: Int
    
    init(green:Int, cbb: Int, fungus: Int){
        self.green = green
        self.cbb = cbb
        self.fungus = fungus
        super.init()
        
    }
    // start_num is only included so this method doesn't have the same signature as the superclass (NSObject) init
    convenience init(start_num: Int = 0){
        self.init(green: start_num, cbb: start_num, fungus: start_num)
    }
    
    required init(coder: NSCoder) {
        self.green = coder.decodeIntegerForKey(GREEN_KEY)
        self.cbb = coder.decodeIntegerForKey(CBB_KEY)
        self.fungus = coder.decodeIntegerForKey(FUNGUS_KEY)
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeInteger(green, forKey: GREEN_KEY)
        coder.encodeInteger(cbb, forKey: CBB_KEY)
        coder.encodeInteger(fungus, forKey: FUNGUS_KEY)
    }

}

func ==(left: TreeData, right: TreeData) -> Bool {
    return left.green == right.green && left.cbb == right.cbb && left.fungus == right.fungus
}