//
//  Days.swift
//  MapMyDay
//
//  Created by Mollie on 3/15/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

let _mainData: DaysData = DaysData()

class DaysData: NSObject {
    
    var days: [PFObject] = []
    var selectedDay: PFObject?
    
    class func mainData() -> DaysData {
        return _mainData
    }
    
    func refreshDays(completion: () -> ()) {
        
        var daysQuery = PFQuery(className: "Day")
        daysQuery.orderByDescending("createdAt")
        daysQuery.whereKey("public", equalTo: true)
        
        daysQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if objects.count > 0 {
                
                self.days = objects as [PFObject]
                
            }
            
            completion()
            
        }
        
    }
    
    func refreshMyDays(completion: () -> ()) {
        
        var daysQuery = PFQuery(className: "Day")
        daysQuery.whereKey("user", equalTo: PFUser.currentUser())
        daysQuery.orderByDescending("createdAt")
        
        daysQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if objects.count > 0 {
                
                self.days = objects as [PFObject]
                
            }
            
            completion()
            
        }
        
    }
   
}
