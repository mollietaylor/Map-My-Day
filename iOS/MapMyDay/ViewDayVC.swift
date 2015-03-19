//
//  ViewDayVC.swift
//  MapMyDay
//
//  Created by Mollie on 3/15/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import MapKit

class ViewDayVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableViewHeader: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewFooter: UIView!
    @IBOutlet weak var publicSwitch: UISwitch!
    
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
        
        stats = currentDay["stats"] as [String:AnyObject]
        
        if currentDay["user"].objectId == PFUser.currentUser().objectId {
            
            tableViewHeader.hidden = false
            tableViewFooter.hidden = false
            
        } else {
            tableViewHeader.hidden = true
            tableViewHeader.frame.size.height = 0
            tableViewFooter.hidden = true
        }
        
        if let isPublic = currentDay["public"] as? Bool {
            if isPublic {
                publicSwitch.setOn(true, animated: true)
            } else {
                publicSwitch.setOn(false, animated: true)
            }
        }
        
        mapDay(mapView, currentDay)
        tableView.reloadData()

    }
    
    @IBAction func switchPublic(sender: AnyObject) {
        
        if publicSwitch.on {
            
            displayAlert()
            
        } else {
            
            // save to Parse
            var currentDay = DaysData.mainData().selectedDay!
            currentDay.setValue(false, forKey: "public")
            currentDay.saveInBackground()
            
        }
        
    }
    
    func displayAlert() {
        
        let alertController = UIAlertController(title: "Are you sure you want to make this event viewable by other users?", message: "", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel) { (action) in
            
            self.publicSwitch.setOn(false, animated: true)
            
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            
            // save to Parse
            var currentDay = DaysData.mainData().selectedDay!
            currentDay.setValue(true, forKey: "public")
            currentDay.saveInBackground()
            
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
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

}
