//
//  VenueVC.swift
//  MapMyDay
//
//  Created by Mollie on 3/18/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class VenueVC: UIViewController {
    var venue = [String:AnyObject]()

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var foursquareButton: UIButton!
    @IBOutlet weak var slideView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = venue["name"] as? String
        
        urlButton.contentHorizontalAlignment = .Left
        addressButton.contentHorizontalAlignment = .Left
        
        println(venue)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        if venue.count > 0 {
            
            if let categories = venue["categories"] as? [[String:AnyObject]] {
                if !categories.isEmpty {
                    categoryLabel.textColor = UIColor.blackColor()
                    categoryLabel.text = categories[0]["name"] as? String
                }
            }
            
            if let location: AnyObject = venue["location"] {
                if let address = location["address"] as? String {
                    addressButton.setTitleColor(blueColor, forState: .Normal)
                    addressButton.setTitle(address, forState: .Normal)
                }
            }
            
            if let url: AnyObject = venue["url"] {
                urlButton.setTitleColor(blueColor, forState: .Normal)
                urlButton.setTitle(url as? String, forState: .Normal)
            }
            
            if let hours: AnyObject = venue["hours"] {
                if hours["isOpen"] as? Int == 1 {
                    hoursLabel.textColor = greenColor
                } else {
                    hoursLabel.textColor = redColor
                }
                hoursLabel.text = hours["status"] as? String
            }
            
            foursquareButton.setBackgroundImage(UIImage(named: "powered-by-foursquare"), forState: .Normal)
            
        }
        
    }
    
    
    @IBAction func urlButtonPressed(sender: AnyObject) {
        
        if venue.count > 0 {
            
            if let url: String = venue["url"] as? String {
                
                UIApplication.sharedApplication().openURL(NSURL(string:url)!)
                
            }
            
        }
        
    }
    
    @IBAction func addressButtonPressed(sender: AnyObject) {
        
        // TODO: Refactor??
        if venue.count > 0 {
            
            if let location: AnyObject = venue["location"] {
                
                if let address: [String] = location["formattedAddress"] as? [String] {
                    
                    var url: String = ""
                    
                    if address[0] != "" {
                        
                        if address[1] != "" {
                            url = "http://maps.apple.com/?q=" + address[0] + ", " + address[1]
                        } else {
                            url = "http://maps.apple.com/?q=" + address[0] + ", Atlanta GA"
                        }
                        
                    }
                    
                    if url != "" {
                        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                        UIApplication.sharedApplication().openURL(NSURL(string:url)!)
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    
    @IBAction func foursquarePressed(sender: AnyObject) {
        
        let venueID = venue["id"] as String
        
        let foursquareURL = "foursquare://venues/" + venueID
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: foursquareURL)!) {
            
            UIApplication.sharedApplication().openURL(NSURL(string: foursquareURL)!)
            
        } else {
            
            let url = "https://foursquare.com/v/" + venueID + "?ref=" + CLIENT_ID
            UIApplication.sharedApplication().openURL(NSURL(string:url)!)
            
        }
        
    }
    
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
    func keyboardWillShow(notification: NSNotification) {
        let navBarHeight = navigationController?.navigationBar.frame.size.height
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                view.frame.origin.y = -keyboardSize.height + navBarHeight! + statusBarHeight
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let navBarHeight = navigationController?.navigationBar.frame.size.height
        view.frame.origin.y = 0 + navBarHeight! + statusBarHeight
    }
    
    // minimize keyboard on tap outside
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    
    @IBAction func addVenueToMap(sender: AnyObject) {
        
        let location = manager.location
        
        var category = ""
        
        if let categories = venue["categories"] as? [[String:AnyObject]] {
            if !categories.isEmpty {
                category = categories[0]["name"] as String
            }
        }
        
        var newVenue = PFObject(className: "Venue")
        newVenue["user"] = PFUser.currentUser()
        newVenue["location"] = ["latitude":location.coordinate.latitude,
            "longitude":location.coordinate.longitude,
            "altitude":location.altitude,
            "horizontalAccuracy":location.horizontalAccuracy,
            "verticalAccuracy":location.verticalAccuracy,
            "time":dateformatterTime(location.timestamp)]
        newVenue["time"] = NSDate()
        newVenue["name"] = venue["name"]
        newVenue["category"] = category
        newVenue["foursquareId"] = venue["id"]
        newVenue["comment"] = commentTextField.text
        
        newVenue.saveInBackgroundWithBlock { (success, error) -> Void in
            
            venues.append(newVenue.objectId)
            media.append(["type": "venue", "objectId": newVenue.objectId])
            
        }
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
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
