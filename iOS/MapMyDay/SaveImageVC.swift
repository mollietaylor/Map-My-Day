//
//  SaveImageVC.swift
//  MapMyDay
//
//  Created by Mollie on 3/18/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import MapKit

var exportImages: [UIImage] = [UIImage]()

class SaveImageVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mainView: UIView!
    
    var stats = [String:AnyObject]()
    var currentDay:PFObject!
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDay = DaysData.mainData().selectedDay!
        media = currentDay["media"] as [[String:String]]
        stats = currentDay["stats"] as [String:AnyObject]
        
        // get media from parse
        
        media.insert(["type": "map"], atIndex: 0)
        media.append(["type": "stats"])
        println(media)
        
        setView()
        
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
        
        // TODO: move this code somewhere that it doesn't run every time ViewDay is run, at the very least, it shouldn't run for someone else's day
        
        
    }

    @IBAction func saveImage(sender: AnyObject) {
        
        //        UIGraphicsBeginImageContext(mapView.frame.size)
        UIGraphicsBeginImageContextWithOptions(mainView.frame.size, false, 0)
        mainView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        exportImages.append(image)
        
        if index < media.count { // TODO: make sure this is right
            index++
            setView()
        } else {
            // if that was the last index, advance to exportCVC
            
        }
        
    }
    
    func setView() {
        
        // clear view
        for subview in mainView.subviews {
            subview.removeFromSuperview()
        }
        
        let item = media[index] as [String:String]
        
        // MARK: Map
        if item["type"] == "map" {
            
            // display map view
            let tabBarHeight = tabBarController!.tabBar.frame.height
            let height = view.frame.height - 60 - tabBarHeight
            var mapView = MKMapView(frame: CGRectMake(0, 0, mainView.frame.width, height))
            mainView.addSubview(mapView)
            mapView.delegate = self
            
            // map stuff
            mapDay(mapView, currentDay)
            
        }
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
