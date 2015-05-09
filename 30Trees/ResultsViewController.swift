//
//  ResultsViewController.swift
//  30Trees
//
//  Created by Spruce Bondera on 11/8/14.
//  Copyright (c) 2014 Spruce Bondera. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet var infestationRateView: UIView!
    @IBOutlet var infestationRateLabel: UILabel!
    @IBOutlet var abAliveView: UIView!
    @IBOutlet var abAliveLabel: UILabel!
    @IBOutlet var abAliveTitle: UILabel!
    @IBOutlet var sprayLabel: UILabel!
    
    
    override func viewDidLoad() {
    
    }
    override func viewWillAppear(animated: Bool) {
        if let farm = FarmDataController.sharedInstance.selected_farm {
            var cbb_count = farm.trees_data.reduce(0, combine: {Double($1.cbb) + Double($1.fungus) + $0})
            var total = cbb_count + farm.trees_data.reduce(0, combine: {Double($1.green) + $0})
            if total != 0 {
                var infestation_rate = round(cbb_count/total * 100 * 10)/10
                infestationRateLabel.text = "\(infestation_rate)%"
            } else {
                infestationRateLabel.text = "No Data"
            }
            
            var positional_data_total = Double(farm.ab_alive + farm.ab_dead + farm.cd)
            if positional_data_total != 0 {
                var ab_alive_percentage = round(Double(farm.ab_alive)/positional_data_total * 100 * 10)/10
                abAliveLabel.text = "\(ab_alive_percentage)%"
                
                abAliveLabel.textColor = UIColor.whiteColor()
                abAliveTitle.textColor = UIColor.whiteColor()
                sprayLabel.textColor = UIColor.whiteColor()
                
                if ab_alive_percentage >= 5 {
                    abAliveView.backgroundColor = UIColor(red: 251/255.0, green: 32/255.0, blue:37/255.0, alpha:1.0)
                    sprayLabel.text = "Spray!"
                } else if ab_alive_percentage >= 2 {
                    abAliveView.backgroundColor = UIColor(red:254/255.0, green:195/255.0, blue:8/255.0, alpha:1.0)
                    sprayLabel.text = "Consider spraying"
                } else {
                    abAliveView.backgroundColor = UIColor(red:82/255.0, green:215/255.0, blue:103/255.0, alpha:1.0)
                    sprayLabel.text = "Don't spray!"
                }
            } else {
                setABAliveViewNoData()
            }
            
            
            
        } else {
            setABAliveViewNoData()
            infestationRateLabel.text = "No Data"
        }
    }
    
    func setABAliveViewNoData() {
        abAliveView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        abAliveLabel.textColor = UIColor.blackColor()
        abAliveLabel.text = "No Data"
        abAliveTitle.textColor = UIColor.blackColor()
        sprayLabel.text = ""
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
