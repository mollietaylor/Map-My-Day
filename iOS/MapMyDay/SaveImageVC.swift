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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var addedViews = [UIView]()
    var stats = [String:AnyObject]()
    var currentDay:PFObject!
    var index = 0
    
    var media = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDay = DaysData.mainData().selectedDay!
        media = currentDay["media"] as [[String:String]]
        stats = currentDay["stats"] as [String:AnyObject]
        
        media.insert(["type": "map"], atIndex: 0)
        media.append(["type": "stats"])
        println(media)
        
        setView()
        
    }

    @IBAction func saveImage(sender: AnyObject) {
        
        //        UIGraphicsBeginImageContext(mapView.frame.size)
        UIGraphicsBeginImageContextWithOptions(mainView.frame.size, false, 0)
        mainView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        exportImages.append(image)
        
        if index < media.count - 1 {
            
            println(media[index])
            index++
            setView()
            
        } else {
            
            // if that was the last index, advance to exportCVC
            performSegueWithIdentifier("showExportCVC", sender: self)

        }
        
    }
    
    func setView() {
        
        // clear view
        for view in addedViews {
            view.removeFromSuperview()
        }
        addedViews.removeAll()
        titleLabel.hidden = true
        categoryLabel.hidden = true
        commentLabel.hidden = true
        
        let item = media[index] as [String:String]
        
        // MARK: Map
        if item["type"] == "map" {
            
            // display map view
            let tabBarHeight = tabBarController!.tabBar.frame.height
            let height = view.frame.height - 60 - tabBarHeight
            var mapView = MKMapView(frame: CGRectMake(0, 0, mainView.frame.width, height))
            mainView.addSubview(mapView)
            mapView.delegate = self
            addedViews.append(mapView)
            
            // map stuff
            mapDay(mapView, currentDay)
            
        } else if item["type"] == "venue" {
            // TODO: add map view
            
            titleLabel.hidden = false
            categoryLabel.hidden = false
            commentLabel.hidden = false
            
            let venueQuery = PFQuery(className: "Venue")
            venueQuery.getObjectInBackgroundWithId(item["objectId"], block: { (object, error) -> Void in
                
                self.titleLabel.text = object["name"] as? String
                self.categoryLabel.text = object["category"] as? String
                if let venueComment = object["comment"] as? String {
                    self.commentLabel.text = venueComment
                    self.commentLabel.backgroundColor = UIColor(patternImage: UIImage(named: "Quotes")!)
                } else {
                    self.commentLabel.text = ""
                }
                
            })
            
        } else if item["type"] == "text" {
            // TODO: add map view
            
            titleLabel.hidden = false
            commentLabel.hidden = false
            
            
            let textQuery = PFQuery(className: "Text")
            textQuery.getObjectInBackgroundWithId(item["objectId"], block: { (object, error) -> Void in
                
                if let title = object["title"] as? String {
                    self.titleLabel.text = title
                } else {
                    self.titleLabel.text = ""
                }
                if let detail = object["detail"] as? String {
                    self.commentLabel.text = detail
                    self.commentLabel.backgroundColor = UIColor(patternImage: UIImage(named: "Quotes")!)
                } else {
                    self.commentLabel.text = ""
                }
                
            })
            
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
