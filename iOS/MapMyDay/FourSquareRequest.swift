//
//  FourSquareRequest.swift
//  MapMyDay
//
//  Created by Mollie on 3/18/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import CoreLocation

let API_URL = "https://api.foursquare.com/v2/"
let CLIENT_ID = "3UOJCFXMG0EJH2LZYWZ0SV1WWOT02SZAIMEIEPQFMA2PCEJQ"
let CLIENT_SECRET = "HJQJGLFDK5FJ3FT35KIFBAZ3RMDNMYC5P2HUNGCFZFOBDOFZ"

class FourSquareRequest: NSObject {
    
    class func requestVenuesWithLocation(location: CLLocation) -> [AnyObject] {
        
        let requestString = API_URL + "venues/search"
            + "?" + "client_id=" + CLIENT_ID
            + "&" + "client_secret=" + CLIENT_SECRET
            + "&" + "v=20130815"
            + "&" + "ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
            + "&" + "query="
        
        if let url = NSURL(string: requestString) {
            
            let request = NSURLRequest(URL: url)
            
            // dictionary with array of venues
            if let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil) {
                
                if let returnInfo = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? [String:AnyObject] {
                    
                    let responseInfo = returnInfo["response"] as [String:AnyObject]
                    let venues = responseInfo["venues"] as [AnyObject]
                    
                    return venues
                    
                }
                
            }
            
        }
        
        return []
    }
    
}
