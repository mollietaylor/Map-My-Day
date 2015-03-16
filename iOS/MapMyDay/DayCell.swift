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
            
            dayInfo?["user"].fetchIfNeededInBackgroundWithBlock({ (object, error) -> Void in
                let user = object as PFUser
                self.textLabel?.text = user.username
            })
            
            // format date
            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "EEEE, MMMM d, YYYY"
            dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
            
            if let startTime = dayInfo?["startTime"] as? NSDate {
                self.detailTextLabel?.text = dateFormatter.stringFromDate(startTime)
            }
            
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
