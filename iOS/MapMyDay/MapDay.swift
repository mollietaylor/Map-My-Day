//
//  MapDay.swift
//  MapMyDay
//
//  Created by Mollie on 3/18/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import MapKit

func mapDay(mapView: MKMapView, currentDay: PFObject) {
    
    // MARK: add pins
    
    let photos = currentDay["photos"] as [String]
    let texts = currentDay["text"] as [String]
    let venues = currentDay["venues"] as [String]
    
    // get photos and texts from parse
    
    for photo in photos {
        
        let photoQuery = PFQuery(className: "Image")
        photoQuery.getObjectInBackgroundWithId(photo, block: { (object, error) -> Void in
            
            if let location = object["location"] as? [String:AnyObject] {
                if let lat = location["latitude"] as? Double {
                    if let lon = location["longitude"] as? Double {
                        
                        let location = CLLocationCoordinate2DMake(lat, lon)
                        let annotation = MKPointAnnotation()
                        annotation.title = "Photo"
                        annotation.coordinate = location
                        
                        mapView.addAnnotation(annotation)
                        
                    }
                }
            }
            
        })
        
    }
    
    for text in texts {
        
        let textQuery = PFQuery(className: "Text")
        textQuery.getObjectInBackgroundWithId(text, block: { (object, error) -> Void in
            
            if let location = object["location"] as? [String:AnyObject] {
                if let lat = location["latitude"] as? Double {
                    if let lon = location["longitude"] as? Double {
                        
                        let location = CLLocationCoordinate2DMake(lat, lon)
                        let annotation = MKPointAnnotation()
                        annotation.title = object["title"] as String
                        annotation.subtitle = object["detail"] as String
                        annotation.coordinate = location
                        
                        mapView.addAnnotation(annotation)
                        
                    }
                }
            }
            
        })
        
    }
    
    for venue in venues {
        
        let venueQuery = PFQuery(className: "Venue")
        venueQuery.getObjectInBackgroundWithId(venue, block: { (object, error) -> Void in
            
            if let location = object["location"] as? [String:AnyObject] {
                if let lat = location["latitude"] as? Double {
                    if let lon = location["longitude"] as? Double {
                        
                        let location = CLLocationCoordinate2DMake(lat, lon)
                        let annotation = MKPointAnnotation()
                        annotation.title = object["name"] as String
                        annotation.subtitle = object["comment"] as String
                        annotation.coordinate = location
                        
                        mapView.addAnnotation(annotation)
                        
                    }
                }
            }
            
        })
        
    }
    
    // maybe this shouldn't be in viewWillAppear, but instead reload map or something
    // MARK: draw tracks
    let tracks = currentDay["tracks"] as [[String:AnyObject]]
    
    for track in tracks {
        
        if let trackPoints = track["track"] as? [[String:AnyObject]] {
            let mode = track["mode"] as String
            
            // get color of mode
            var color = UIColor.redColor()
            if let i = find(modesCollection, mode) {
                color = modesColors[i]
            }
            
            let line = polyline(trackPoints, color)
            mapView.addOverlay(line)
            
            // zoom to overlay
            
            // FIXME:
            mapView.visibleMapRect = mapView.mapRectThatFits(line.boundingMapRect)
            mapView.mapRectThatFits(line.boundingMapRect, edgePadding: UIEdgeInsetsMake(200, 50, 200, 50))
            
        }
        
    }
    
}

func polyline(track: [[String:AnyObject]], color: UIColor) -> MKPolyline {
    
    var coords: [CLLocationCoordinate2D] = []
    
    for point in track {
        
        if let lat = point["latitude"] as? Double {
            if let lon = point["longitude"] as? Double {
                let coord = CLLocationCoordinate2DMake(lat, lon)
                coords.append(coord)
            }
        }
        
    }
    
    let line = CustomPolyline(coordinates: &coords, count: coords.count)
    line.color = color
    
    return line
}
