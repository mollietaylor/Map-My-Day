//
//  ViewDayVC.swift
//  MapMyDay
//
//  Created by Mollie on 3/15/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import MapKit

var exportImages: [UIImage] = [UIImage]()

class ViewDayVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewFooter: UIView!
    
    var stats = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBarHidden = true
        
        let currentDay = DaysData.mainData().selectedDay!
            
        if currentDay["user"].objectId == PFUser.currentUser().objectId {
            
            tableViewFooter.hidden = false
            
        } else { tableViewFooter.hidden = true }
        
        // MARK: add pins
        
        let photos = currentDay["photos"] as [String]
        let texts = currentDay["text"] as [String]
        stats = currentDay["stats"] as [String:AnyObject]
        tableView.reloadData()
        
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
                            
                            self.mapView.addAnnotation(annotation)
                            
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
                            
                            self.mapView.addAnnotation(annotation)
                            
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
                
                let line = polyline(trackPoints, color: color)
                mapView.addOverlay(line)
                
                // zoom to overlay
                
                // FIXME:
                mapView.visibleMapRect = mapView.mapRectThatFits(line.boundingMapRect)
                mapView.mapRectThatFits(line.boundingMapRect, edgePadding: UIEdgeInsetsMake(200, 50, 200, 50))
                
            }
            
        }
        
        // TODO: move this code somewhere that it doesn't run every time ViewDay is run, at the very least, it shouldn't run for someone else's day
        
        UIGraphicsBeginImageContext(mapView.frame.size)
        mapView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        exportImages.append(image)

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
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: CustomPolyline!) -> MKOverlayRenderer! {
            
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = overlay.color
        renderer.lineWidth = 4
        return renderer
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pinView.canShowCallout = true
        
        return pinView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let statsKeys = stats.keys.array
        
        let statsValues = stats.values.array
        
        cell.textLabel?.text = statsKeys[indexPath.row]
        
        if statsKeys[indexPath.row] == "Time" {
            let seconds = statsValues[indexPath.row] as Int
            cell.detailTextLabel?.text = stringifySecondCount(seconds, false)
        } else if statsKeys[indexPath.row] == "Distance" {
            let distance = statsValues[indexPath.row] as Float
            cell.detailTextLabel?.text = stringifyDistance(distance)
        } else {
            cell.detailTextLabel?.text = statsValues[indexPath.row].description
        }
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
