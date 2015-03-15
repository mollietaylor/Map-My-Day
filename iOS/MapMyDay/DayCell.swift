//
//  DayCell.swift
//  MapMyDay
//
//  Created by Mollie on 3/15/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {
    
    var dayInfo: PFObject? {
        
        didSet {
            
            println(dayInfo)
            
            textLabel?.text = dayInfo?["user"].objectId // FIXME: this should actually return username not User
            let startTime = dayInfo?["startTime"] as? String
            println(startTime)
            let endTime = dayInfo?["endTime"] as? String
            detailTextLabel?.text = "\(startTime) - \(endTime)" // or just date portion of startTime
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
