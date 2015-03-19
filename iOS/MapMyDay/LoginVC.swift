//
//  LoginViewController.swift
//  Sit Fit
//
//  Created by Mollie on 2/3/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameConstraint: NSLayoutConstraint!
    
    var loginMode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goButton.hidden = true
        usernameField.hidden = true
        emailField.hidden = true
        passwordField.hidden = true
        
        checkIfLoggedIn()
        
        self.view.layoutIfNeeded()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
            if let kbSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size {
                
                self.buttonBottomConstraint.constant = 20 + kbSize.height
                self.imageConstraint.constant = 28 - kbSize.height
                self.view.layoutIfNeeded()
                
                // or:
                //                self.view.frame.origin.y = -kbSize.height
                
            }
            
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
            self.buttonBottomConstraint.constant = 20
            self.imageConstraint.constant = 28
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    // minimize keyboard on tap outside
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        
        loginMode = "login"
        usernameField.hidden = false
        usernameConstraint.constant = 8
        passwordField.hidden = false
        goButton.hidden = false
        
    }
    
    @IBAction func registerPressed(sender: AnyObject) {
        
        loginMode = "register"
        usernameField.hidden = false
        emailField.hidden = false
        passwordField.hidden = false
        goButton.hidden = false
        
    }
    
    @IBAction func loginRegister(sender: AnyObject) {
        
        var fieldValues: [String] = [usernameField.text, emailField.text, passwordField.text]
        if loginMode == "login" {
            fieldValues = [usernameField.text, passwordField.text]
        }
            
        if find(fieldValues, "") == nil {
            
            var userQuery = PFUser.query()
            
            userQuery.whereKey("username", equalTo: usernameField.text)
            
            userQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if objects.count > 0 {
                    
                    self.login()
                    
                } else {
                    
                    self.signUp()
                    
                }
                
            })
            
        } else {
            
            var alertViewController = UIAlertController(title: "Submission Error", message: "All fields need to be filled in", preferredStyle: UIAlertControllerStyle.Alert)
            var defaultAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alertViewController.addAction(defaultAction)
            
            presentViewController(alertViewController, animated: true, completion: nil)
            
        }
        
    }
    
    func login() {
        
        PFUser.logInWithUsernameInBackground(usernameField.text, password:passwordField.text) {
            (user: PFUser!, error: NSError!) -> Void in
            
            if user != nil {
                
                println("logged in as \(user)")
                self.isLoggedIn = true
                self.checkIfLoggedIn()
                
            } else {
                // The login failed. Check error to see why.
                println(error)
            }
        }
    }
    
    func signUp() {
        
        var user = PFUser()
        user.username = usernameField.text
        user.email = emailField.text
        user.password = passwordField.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                println(user)
                
                self.isLoggedIn = true
                self.checkIfLoggedIn()
                
                self.usernameField.text = ""
                self.emailField.text = ""
                self.passwordField.text = ""
                
            } else {
                let errorString = error.userInfo?["error"] as NSString
                // Show the errorString somewhere and let the user try again.
            }
        }
        
    }
    
    
    // MARK: more login stuff
    var isLoggedIn: Bool {
        
        get {
            
            return NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn")
            
        }
        
        set {
            
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "isLoggedIn")
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
        
    }
    
    func checkIfLoggedIn() {
        
        if isLoggedIn {
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var tbc = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
            UIApplication.sharedApplication().keyWindow?.rootViewController = tbc
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
