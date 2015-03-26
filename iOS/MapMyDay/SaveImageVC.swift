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

class SaveImageVC: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var quotesView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var mapViewView: UIView!
    
    var addedViews = [UIView]()
    var stats = [String:AnyObject]()
    var currentDay:PFObject!
    var index = 0
    var media = [[String:String]]()
    
    var mapView = MKMapView()
    var tableView = UITableView()
    
    var tabBarHeight: CGFloat = 0
    var statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exportImages.removeAll()
        
        tabBarHeight = tabBarController!.tabBar.frame.height
        
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
        quotesView.hidden = true
        commentLabel.hidden = true
        
        let item = media[index] as [String:String]
        
        // MARK: Map
        if item["type"] == "map" {
            
            // display map view
            let height = view.frame.height - 60 - tabBarHeight - statusBarHeight
            mapView = MKMapView(frame: CGRectMake(0, 0, mainView.frame.width, height))
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
            
            // mini map
            let y = view.frame.height - 60 - tabBarHeight - 100 - 16
            let width = view.frame.width - 32
            mapView = MKMapView(frame: mapViewView.frame)
            mainView.addSubview(mapView)
            mapView.delegate = self
            addedViews.append(mapView)
            mapDay(mapView, currentDay)
            
            let venueQuery = PFQuery(className: "Venue")
            venueQuery.getObjectInBackgroundWithId(item["objectId"], block: { (object, error) -> Void in
                
                self.titleLabel.text = object["name"] as? String
                self.categoryLabel.text = object["category"] as? String
                if let venueComment = object["comment"] as? String {
                    self.commentLabel.text = venueComment
                    self.quotesView.hidden = false
                } else {
                    self.commentLabel.text = ""
                }
                
                if let location = object["location"] as? [String:AnyObject] {
                    if let latitude = location["latitude"] as? Double {
                        if let longitude = location["longitude"] as? Double {
                            let mapLocation = CLLocationCoordinate2DMake(latitude, longitude)
                            let span = MKCoordinateSpanMake(0.005, 0.005)
                            self.mapView.setRegion(MKCoordinateRegionMake(mapLocation, span), animated: true)
                        }
                    }
                }
                
            })
            
            
        } else if item["type"] == "text" {
            // TODO: add map view
            
            titleLabel.hidden = false
            commentLabel.hidden = false
            
            // mini map
            let y = view.frame.height - 60 - tabBarHeight - 100 - 16
            let width = view.frame.width - 32
            mapView = MKMapView(frame: mapViewView.frame)
            mainView.addSubview(mapView)
            mapView.delegate = self
            addedViews.append(mapView)
            mapDay(mapView, currentDay)
            
            let textQuery = PFQuery(className: "Text")
            textQuery.getObjectInBackgroundWithId(item["objectId"], block: { (object, error) -> Void in
                
                if let title = object["title"] as? String {
                    self.titleLabel.text = title
                } else {
                    self.titleLabel.text = ""
                }
                if let detail = object["detail"] as? String {
                    self.commentLabel.text = detail
                    self.quotesView.hidden = false
                } else {
                    self.commentLabel.text = ""
                }
                
                if let location = object["location"] as? [String:AnyObject] {
                    if let latitude = location["latitude"] as? Double {
                        if let longitude = location["longitude"] as? Double {
                            let mapLocation = CLLocationCoordinate2DMake(latitude, longitude)
                            let span = MKCoordinateSpanMake(0.005, 0.005)
                            self.mapView.setRegion(MKCoordinateRegionMake(mapLocation, span), animated: true)
                        }
                    }
                }
                
            })
            
        } else if item["type"] == "photo" {
            
            // mini map
            let y = (view.frame.width * 3 / 4)
            mapView = MKMapView(frame: CGRectMake(0, y, view.frame.width, view.frame.height - y - 60 - statusBarHeight))
            mainView.addSubview(mapView)
            mapView.delegate = self
            addedViews.append(mapView)
            mapDay(mapView, currentDay)
            
            let photoQuery = PFQuery(className: "Image")
            photoQuery.getObjectInBackgroundWithId(item["objectId"], block: { (object, error) -> Void in
                
                let imageFile = object["image"] as? PFFile
                imageFile?.getDataInBackgroundWithBlock { (imageData: NSData!, error: NSError!) -> Void in
                    
                    let image: UIImage = UIImage(data: imageData)!
                    var imageView = UIImageView(image: image)
                    imageView.frame = CGRectMake(0, 0, self.view.frame.width, (self.view.frame.width * 3 / 4))
                    self.mainView.addSubview(imageView)
                    self.addedViews.append(imageView)
                    
                }
                
            })
            
        } else if item["type"] == "stats" {
            
            let height = view.frame.height - 60 - tabBarHeight - 20
            tableView = UITableView(frame: CGRectMake(0, 20, view.frame.width, height))
            tableView.delegate = self
            tableView.dataSource = self
            mainView.addSubview(tableView)
            addedViews.append(tableView)
            
        }
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 60))
        let headerLabel = UILabel(frame: headerView.frame)
        headerLabel.text = "STATS"
        headerLabel.textColor = UIColor(red:0.53, green:0.53, blue:0.53, alpha:1)
        headerLabel.font = UIFont(name: thinFont, size: 28)
        headerLabel.textAlignment = NSTextAlignment.Center
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: "cell")
        
        let statsKeys = stats.keys.array
        let statsValues = stats.values.array
        
        cell.textLabel?.tintColor = UIColor(red:0, green:0.6, blue:0, alpha:1)
        
        cell.textLabel?.text = statsKeys[indexPath.row]
        cell.textLabel?.font = UIFont(name: primaryFont, size: 12)
        cell.textLabel?.textColor = UIColor(red:0.53, green:0.53, blue:0.53, alpha:1)
        cell.detailTextLabel?.font = UIFont(name: primaryFont, size: 24)
        
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
