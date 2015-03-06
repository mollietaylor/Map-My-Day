//
//  Data.swift
//  Map My Day
//
//  Created by Mollie on 3/3/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import Foundation
import MapKit

class Day: NSObject {
    
    var track: [[String:AnyObject]] = [[:]]
    // track example
    // [["mode":"bicycle",
    //   "track":[CLLocation] // time, coordinate, altitude, accuracy
    //   "distance":Float,
    //   "time":Float,
    //   "date":NSDate,
    //   "user":PFUser],
    //  ["mode":"car",
    //   "track":[CLLocation]
    //   "distance":Float,
    //   "time":Float,
    //   "date":NSDate,
    //   "user":PFUser]]

    var media: [[String:AnyObject]] = [[:]]
    // media example
    // [["medium":"photo",
    //  "time":NSDate,
    //  "coordinate":CLLocation, // or CLLocationCoordinate2D
    //  "content":AnyObject]] // String, URL, or other
    
    
}
