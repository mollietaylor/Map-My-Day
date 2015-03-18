//
//  VenuesTVC.swift
//  MapMyDay
//
//  Created by Mollie on 3/18/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class VenuesTVC: UITableViewController {
    
    var foundVenues: [AnyObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelVenue")
    
        foundVenues = FourSquareRequest.requestVenuesWithLocation(manager.location)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundVenues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let venue = foundVenues[indexPath.row] as [String:AnyObject]
        
        cell.textLabel?.text = venue["name"] as? String
        if let categories = venue["categories"] as? [[String:AnyObject]] {
            if !categories.isEmpty {
                if let categoryName = categories[0]["name"] as? String {
                    cell.detailTextLabel?.text = categoryName
                } else {
                    cell.detailTextLabel?.text = ""
                }
            } else {
                cell.detailTextLabel?.text = ""
            }
        } else {
            cell.detailTextLabel?.text = ""
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let venue = foundVenues[indexPath.row] as [String:AnyObject]
        
        let venueVC = storyboard?.instantiateViewControllerWithIdentifier("venueVC") as VenueVC
        venueVC.venue = venue
        
        navigationController?.pushViewController(venueVC, animated: true)
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    func cancelVenue() {
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
