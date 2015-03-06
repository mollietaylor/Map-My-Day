//
//  TrackingVC.swift
//  Map My Day
//
//  Created by Mollie on 3/2/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TrackingVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var seconds:Int = 0
    var distance:Float = 0
    var manager:CLLocationManager!
    var trackedLocations:[CLLocation] = []
    var timer = NSTimer()
    var isRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBarHidden = true
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        timer.invalidate()
    }
    
    func eachSecond() {
        
        seconds++
        timeLabel.text = "\(stringifySecondCount(seconds, false))"
        distanceLabel.text = "\(stringifyDistance(distance))"
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        trackedLocations.append(locations[0] as CLLocation)
        
        let spanX = 0.007
        let spanY = 0.007
        var newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
        
        if trackedLocations.count > 1 && isRunning {
            
            let sourceIndex = trackedLocations.count - 1
            let destinationIndex = trackedLocations.count - 2
            
            var c1 = trackedLocations[sourceIndex].coordinate
            var c2 = trackedLocations[destinationIndex].coordinate
            var a = [c1, c2]
            var polyline = MKPolyline(coordinates: &a, count: a.count)
            mapView.addOverlay(polyline)
            
        }
        
        
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(red:0.15, green:0.68, blue:0.38, alpha:1)
            renderer.lineWidth = 4
            return renderer
            
        }
        
        return nil
        
    }
    
    @IBAction func stopTracking(sender: AnyObject) {
        
        // save data here, or ideally save while running
        
    }
    
    @IBAction func startTracking(sender: AnyObject) {

        // these should only reset the first time the start button is pressed
        seconds = 0
        distance = 0
        trackedLocations = []
        timer = NSTimer(timeInterval: 1, target: self, selector: "eachSecond", userInfo: nil, repeats: true)
        isRunning = isRunning == false ? true : false
        if startButton.titleLabel?.text == "Start" {
            startButton.setTitle("Pause", forState: .Normal)
        } else {
            startButton.setTitle("Start", forState: UIControlState.Normal)
        }
        
        stopButton.hidden = false
        
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
