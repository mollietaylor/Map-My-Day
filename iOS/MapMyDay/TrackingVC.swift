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

class TrackingVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var currentModeImage: UIImageView!
    @IBOutlet weak var currentModeView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var seconds:Int = 0
    var distance:Float = 0
    var startTime:NSDate = NSDate()
    var endTime:NSDate = NSDate()
    var manager:CLLocationManager!
    var trackedLocations = [CLLocation]()
    var currentTrackPoints = [[String:AnyObject]]()
    var currentTrack = [String:AnyObject]()
    var tracks = [[String:AnyObject]]()
    var timer = NSTimer()
    var isRunning = false
    
    let modesCollection = ["bicycle", "bus", "car", "ferry", "hiking", "horseback", "motorbike", "pedestrian", "plane", "skating", "skiing", "snowmobile", "subway", "train", "other"]
    let modesColors = [UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 1),
        UIColor(hue: 0.06, saturation: 1, brightness: 0.4, alpha: 1),
        UIColor(hue: 0.12, saturation: 1, brightness: 1, alpha: 1),
        UIColor(hue: 0.18, saturation: 1, brightness: 0.4, alpha: 1),
        UIColor(hue: 0.24, saturation: 1, brightness: 1, alpha: 1),
        UIColor(hue: 0.30, saturation: 1, brightness: 0.4, alpha: 1),
        UIColor(hue: 0.36, saturation: 1, brightness: 1, alpha: 1),
        UIColor(hue: 0.42, saturation: 1, brightness: 0.4, alpha: 1),
        UIColor(hue: 0.48, saturation: 1, brightness: 1, alpha: 1),
        UIColor(hue: 0.54, saturation: 1, brightness: 0.4, alpha: 1),
        UIColor(hue: 0.60, saturation: 1, brightness: 1, alpha: 1),
        UIColor(hue: 0.66, saturation: 1, brightness: 0.4, alpha: 1),
        UIColor(hue: 0.72, saturation: 1, brightness: 1, alpha: 1),
        UIColor(hue: 0.78, saturation: 1, brightness: 0.4, alpha: 1),
        UIColor(hue: 0.84, saturation: 1, brightness: 1, alpha: 1)]
    // FIXME: if we add currentMode or a default mode to NSUserDefaults or Parse, currentModeColor needs to be changed to active mode before drawing begins
    var currentModeColor = UIColor(hue: 0.12, saturation: 1, brightness: 1, alpha: 1)
    var currentMode = "car"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentModeView.frame.size.width = 88
        collectionView.hidden = true

        navigationController?.navigationBarHidden = true
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        timer.invalidate()
        
        // TODO: once data has been saved, erase tracks from map
    }
    
    func eachSecond() {
        
        seconds++
        timeLabel.text = "\(stringifySecondCount(seconds, false))"
        distanceLabel.text = "\(stringifyDistance(distance))"
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modesCollection.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, 44, 44))
        imageView.image = UIImage(named: modesCollection[indexPath.row])
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        cell.addSubview(imageView)
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // show/hide options
        collectionView.hidden = true
        currentModeView.frame.size.width = 88
        
        // change mode in data
        currentMode = modesCollection[indexPath.row]
        // TODO: save mode
        
        // change color of track
        currentModeColor = modesColors[indexPath.row]
        
        // change currentMode image
        currentModeImage.image = UIImage(named: modesCollection[indexPath.row])
        
        // add currentTrack to tracks
        if !currentTrackPoints.isEmpty {
            currentTrack["track"] = currentTrackPoints
            currentTrackPoints = [[:]]
            tracks.append(currentTrack)
            currentTrack = ["mode": currentMode,
                "track": [[:]]]
        }
        
    }
    
    // TODO: when you start, stop, or change modes (while running), tracks should begin and/or end
    
    @IBAction func changeMode(sender: AnyObject) {
        
        // collectionView didSelectItemAtIndexPath is where mode actually changes
        
        if collectionView.hidden {
            currentModeView.frame.size.width = 132
            collectionView.hidden = false
        } else {
            currentModeView.frame.size.width = 88
            collectionView.hidden = true
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        trackedLocations.append(locations[0] as CLLocation)
        
        let spanX = 0.007
        let spanY = 0.007
        var newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: false)
        
        if trackedLocations.count > 1 && isRunning {
            
            let sourceIndex = trackedLocations.count - 1
            let destinationIndex = trackedLocations.count - 2
            
            var c1 = trackedLocations[sourceIndex].coordinate
            var c2 = trackedLocations[destinationIndex].coordinate
            var a = [c1, c2]
            var polyline = MKPolyline(coordinates: &a, count: a.count)
            mapView.addOverlay(polyline)
            
        }
        
        if let location = locations[0] as? CLLocation {
        
            if isRunning {
                currentTrackPoints.append(["latitude":location.coordinate.latitude,
                                               "longitude":location.coordinate.longitude,
                                               "altitude":location.altitude,
                                               "horizontalAccuracy":location.horizontalAccuracy,
                                               "verticalAccuracy":location.verticalAccuracy,
                                               "time":dateformatterDate(location.timestamp)])
            }
            
        }
        
        
    }
    
    func dateformatterDate(date: NSDate) -> String {
        
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        return dateFormatter.stringFromDate(date)
        
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = currentModeColor
            renderer.lineWidth = 4
            return renderer
            
        }
        
        return nil
        
    }
    
    @IBAction func stopTracking(sender: AnyObject) {
        
        // add currentTrack to tracks
        currentTrack["track"] = currentTrackPoints
        currentTrackPoints = [[:]]
        tracks.append(currentTrack)
        
        // save data here, or ideally save while running
        
        var currentDay = PFObject(className: "Day")
        currentDay["user"] = PFUser.currentUser()
        currentDay["startTime"] = startTime
        currentDay["endTime"] = NSDate()
        currentDay["tracks"] = tracks
        //        currentDay["media"] =
        
        currentDay.saveInBackground()
        
    }
    
    @IBAction func startTracking(sender: AnyObject) {

        // these should only reset the first time the start button is pressed
        startTime = NSDate()
        seconds = 0
        distance = 0
        trackedLocations = []
        timer = NSTimer(timeInterval: 1, target: self, selector: "eachSecond", userInfo: nil, repeats: true)
        isRunning = isRunning == false ? true : false
        if startButton.titleLabel?.text == "Start" {
            // start/resume
            startButton.setTitle("Pause", forState: .Normal)
            // reset currentTrack
            println(currentMode)
            currentTrack = ["mode": currentMode,
                "track": [[:]]]
            
            
        } else {
            // pause
            startButton.setTitle("Start", forState: UIControlState.Normal)
            // add currentTrack to tracks
            currentTrack["track"] = currentTrackPoints
            currentTrackPoints = [[:]]
            tracks.append(currentTrack)
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
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Media", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("photoVC") as PhotoVC
        
        if let location = trackedLocations.last {
            
            vc.location = location
            
        } // TODO: what should it do if location tracking isn't on?
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    

}