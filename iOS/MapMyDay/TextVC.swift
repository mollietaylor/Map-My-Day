//
//  TextVC.swift
//  MapMyDay
//
//  Created by Mollie on 3/15/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class TextVC: UIViewController {
    
    var location = CLLocation()
    
    @IBOutlet weak var itemTitle: UITextField!
    @IBOutlet weak var itemDetail: UITextView!
    
    @IBOutlet weak var detailBottomConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.translucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("saveItem"))
        
        itemTitle.autocapitalizationType = UITextAutocapitalizationType.Sentences
        itemDetail.autocapitalizationType = UITextAutocapitalizationType.Sentences
        
        itemDetail.layer.borderWidth = 1
        itemDetail.layer.borderColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1).CGColor
        itemDetail.layer.cornerRadius = 5
        itemDetail.clipsToBounds = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                detailBottomConstraint.constant = keyboardSize.height + 16
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        detailBottomConstraint.constant = 16
    }
    
    // minimize keyboard on tap outside
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    
    @IBAction func saveItem(sender: AnyObject) {
        
        var newText = PFObject(className: "Text")
        newText["user"] = PFUser.currentUser()
        newText["location"] = ["latitude":location.coordinate.latitude,
            "longitude":location.coordinate.longitude,
            "altitude":location.altitude,
            "horizontalAccuracy":location.horizontalAccuracy,
            "verticalAccuracy":location.verticalAccuracy,
            "time":dateformatterTime(location.timestamp)]
        newText["time"] = NSDate()
        newText["title"] = itemTitle.text
        newText["detail"] = itemDetail.text
        
        newText.saveInBackground()
        newText.saveInBackgroundWithBlock { (success, error) -> Void in
            
            text.append(newText.objectId)
            
        }
        
        // save data
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func cancelItem(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
