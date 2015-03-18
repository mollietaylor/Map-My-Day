//
//  Math.swift
//  Map My Day
//
//  Created by Mollie on 3/2/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import Foundation

let isMetric = false
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
    
    let distance = round((meters / unitDivider) * 10) / 10
    return "\(distance) \(unitName)"
    
}
//
//func updateTime() {
//    var currentTime = NSDate.timeIntervalSinceReferenceDate()
//    
//    //Find the difference between current time and start time.
//    var elapsedTime: NSTimeInterval = currentTime – startTime
//    
//    //calculate the minutes in elapsed time.
//    let minutes = UInt8(elapsedTime / 60.0)
//    elapsedTime -= (NSTimeInterval(minutes) * 60)
//    
//    //calculate the seconds in elapsed time.
//    let seconds = UInt8(elapsedTime)
//    elapsedTime -= NSTimeInterval(seconds)
//    
//    //find out the fraction of milliseconds to be displayed.
//    let fraction = UInt8(elapsedTime * 100)
//    
//    //add the leading zero for minutes, seconds and millseconds and store them as string constants
//    let strMinutes = minutes > 9 ? String(minutes):“0” + String(minutes)
//    let strSeconds = seconds > 9 ? String(seconds):“0” + String(seconds)
//    let strFraction = fraction > 9 ? String(fraction):“0” + String(fraction)
//    
//    //concatenate minuets, seconds and milliseconds as assign it to the UILabel
//    displayTimeLabel.text = “\(strMinutes):\(strSeconds):\(strFraction)”
//}

func stringifySecondCount(seconds: Int, usingLongFormat: Bool) -> String {
    
    var remainingSeconds = seconds
    
    let hours = remainingSeconds / 3600
    remainingSeconds -= hours * 3600
    
    let minutes = remainingSeconds / 60
    remainingSeconds -= minutes * 60
    let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
    
    let strSeconds = remainingSeconds > 9 ? String(remainingSeconds):"0" + String(remainingSeconds)
    
    if usingLongFormat {
        
        if hours > 0 {
            return "\(hours)hr \(strMinutes)min \(strSeconds)sec"
        } else if minutes > 0 {
            return "\(strMinutes)min \(strSeconds)sec"
        } else {
            return "\(remainingSeconds)sec"
        }
        
    } else {
        
        return "\(hours):\(strMinutes):\(strSeconds)"
        
    }
    
}

func dateformatterTime(date: NSDate) -> String {
    
    var dateFormatter: NSDateFormatter = NSDateFormatter()
    dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
    return dateFormatter.stringFromDate(date)
    
}

