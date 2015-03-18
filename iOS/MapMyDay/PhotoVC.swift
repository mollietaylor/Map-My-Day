//
//  PhotoVC.swift
//  Map My Day
//
//  Created by Mollie on 3/13/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
    }
    
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as UIImage
        self.imageView.image = image
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func cancelImage(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func resizeImage(image: UIImage, withSize size: CGSize) -> UIImage {
        
        // make square
        
        //        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
        
    }
    
    @IBAction func saveImage(sender: AnyObject) {
        
        var newImage = PFObject(className: "Image") // Media or Image
        newImage["user"] = PFUser.currentUser()
        
        let location = manager.location
        
        newImage["location"] = ["latitude":location.coordinate.latitude,
            "longitude":location.coordinate.longitude,
            "altitude":location.altitude,
            "horizontalAccuracy":location.horizontalAccuracy,
            "verticalAccuracy":location.verticalAccuracy,
            "time":dateformatterTime(location.timestamp)]
        newImage["time"] = NSDate()
        
        let width = 540 * imageView.image!.size.width / imageView.image!.size.height
        let image = resizeImage(imageView.image!, withSize: CGSizeMake(width, 540.0))
        
        // turn UIImage into PFFile
        let imageFile = PFFile(name: "image.png", data: UIImagePNGRepresentation(image))
        newImage["image"] = imageFile

        newImage.saveInBackground()
        newImage.saveInBackgroundWithBlock { (success, error) -> Void in
            photos.append(newImage.objectId)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
