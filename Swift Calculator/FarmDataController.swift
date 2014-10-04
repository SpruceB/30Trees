//
//  FarmDataController.swift
//  30Trees
//
//  Created by Spruce Bondera on 10/1/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import Foundation

let FarmDataControllerSharedInstance = FarmDataController()

class FarmDataController {
    class var sharedInstance: FarmDataController {
        return FarmDataControllerSharedInstance
    }
    var farms_list: [FarmData] = []
    var selected_farm: FarmData?
    init(){
        
    }
    var data_array:[AnyObject]{
        get {
            return farms_list.map({(farm: FarmData) -> AnyObject in farm.toArray()})
        }
        
        set(data) {
            farms_list = data.map({(farm: AnyObject) -> FarmData in farm as FarmData})
        }
    }
}

