//
//  MyDaysTVC.swift
//  MapMyDay
//
//  Created by Mollie on 3/15/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class MyDaysTVC: ExploreTVC {
    
    override func refreshDays() {
        
        DaysData.mainData().refreshMyDays { () -> () in
            
            self.tableView.reloadData()
            
        }
        
    }

}
