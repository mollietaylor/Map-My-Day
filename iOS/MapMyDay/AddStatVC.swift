//
//  AddStatVC.swift
//  MapMyDay
//
//  Created by Mollie on 3/15/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class AddStatVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Stat"
        
        navigationController?.navigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "saveStat")

        // Do any additional setup after loading the view.
    }
    
    // minimize keyboard on tap outside
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    
    func saveStat() {
        
        // save data
        var currentDay = DaysData.mainData().selectedDay!
        var stats = currentDay["stats"] as [String:AnyObject]
        stats.updateValue(numberTextField.text, forKey: nameTextField.text)
        currentDay.setValue(stats, forKey: "stats")
        currentDay.saveInBackground()
        
        // dismiss VC
        navigationController?.popViewControllerAnimated(true)
        
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
