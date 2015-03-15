//
//  Data.swift
//  Map My Day
//
//  Created by Mollie on 3/3/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import Foundation
import MapKit


// TODO: do i need this at all with parse?
class Day: NSObject {
    
    var startTime: NSDate = NSDate()
    var endTime: NSDate = NSDate()
    var user: PFUser = PFUser.currentUser()
    
    var tracks: [[String:AnyObject]] = [[:]]
    // track example
    // [["mode":"bicycle",
    //   "track":[CLLocation] // time, coordinate, altitude, accuracy
    //   "distance":Float,
    //   "time":Float,
    //   "date":NSDate],
    //  ["mode":"car",
    //   "track":[CLLocation]
    //   "distance":Float,
    //   "time":Float,
    //   "date":NSDate]]

    var photos: [[String:AnyObject]] = [[:]]
    // media example
    // [["medium":"photo",
    //  "time":NSDate,
    //  "coordinate":CLLocation, // or CLLocationCoordinate2D
    //  "content":AnyObject]] // String, URL, or other
    
    
}
