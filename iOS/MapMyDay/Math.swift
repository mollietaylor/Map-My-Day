//
//  Math.swift
//  Map My Day
//
//  Created by Mollie on 3/2/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import Foundation

let isMetric = true
let metersInKM:Float = 1000
let metersInMile:Float = 1609.334

func stringifyDistance(meters: Float) -> String {
    
    var unitDivider:Float = 0
    var unitName = ""
    
    if (isMetric) {
        unitName = "km"
        unitDivider = metersInKM
    } else {
        unitName = "mi"
        unitDivider = metersInMile
    }
    return "\(meters / unitDivider) \(unitName)"
    
}

func stringifySecondCount(seconds: Int, usingLongFormat: Bool) -> String {
    
    var remainingSeconds = seconds
    let hours = remainingSeconds / 3600
    remainingSeconds -= hours * 3600
    let minutes = remainingSeconds / 60
    remainingSeconds -= minutes * 60
    
    if usingLongFormat {
        
        if hours > 0 {
            return "\(hours)hr \(minutes)min \(remainingSeconds)sec"
        } else if minutes > 0 {
            return "\(minutes)min \(remainingSeconds)sec"
        } else {
            return "\(remainingSeconds)sec"
        }
        
    } else {
        
        if hours > 0 {
            return "\(hours):\(minutes):\(remainingSeconds)"
        } else if minutes > 0 {
            return "\(minutes):\(remainingSeconds)"
        } else {
            return "\(remainingSeconds)"
        }
        
    }
    
}

