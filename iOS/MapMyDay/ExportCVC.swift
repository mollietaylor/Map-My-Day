//
//  ExportCVC.swift
//  MapMyDay
//
//  Created by Mollie on 3/17/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class ExportCVC: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.delegate = self
        collectionView?.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return exportImages.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        
        println(exportImages[0].size)
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, 300, 300))
        imageView.image = exportImages[indexPath.row]
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        cell.addSubview(imageView)
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footerCell", forIndexPath: indexPath) as UICollectionReusableView
        return footer
    }
    
    // TODO: on export,
    
//    let imageData = UIImagePNGRepresentation(image)
    
    @IBAction func saveImages(sender: AnyObject) {
        
        for image in exportImages {
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
        }
        
        navigationController?.popToRootViewControllerAnimated(true)
        
        // maybe open camera roll?
        
    }

}
