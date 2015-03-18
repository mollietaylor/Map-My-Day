//
//  ExploreTVC.swift
//  MapMyDay
//
//  Created by Mollie on 3/15/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class ExploreTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        refreshDays()
        
    }
    
    func refreshDays() {
        
        DaysData.mainData().refreshDays { () -> () in
            
            self.tableView.reloadData()
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return DaysData.mainData().days.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> DayCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath) as DayCell
        
        let day = DaysData.mainData().days[indexPath.row]
        
        cell.dayInfo = day

        return cell
    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        DaysData.mainData().selectedDay = DaysData.mainData().days[indexPath.row]
        
        let editVC = storyboard?.instantiateViewControllerWithIdentifier("editDayVC") as ViewDayVC
        
        navigationController?.pushViewController(editVC, animated: true)
        
    }

}
