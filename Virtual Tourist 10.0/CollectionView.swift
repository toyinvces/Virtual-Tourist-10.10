//
//  CollectionView.swift
//  Virtual Tourist 10.0
//
//  Created by Cesar Ramirez on 11/23/15.
//  Copyright © 2015 Cesar Ramirez. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class CollectionViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,MKMapViewDelegate {
    
    var lat: Double!
    var lon: Double!
    
    var pin: Pin!
    

    
    
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func test(sender: AnyObject) {
        downloadPhotoUrls()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appending()
        
        
        if pin.photos.isEmpty {
            
            downloadPhotoUrls()
        }
        
     //    let pin = pins[0]
        
      
      //  self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

    
    }
        
    
    
    
 

    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()

    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }




    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {


        return 10
        
    }

    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
    //     let pin = pins[0]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        
       // let photo = pin.photo!s[indexPath.item]
        
        
        
        
        cell.photo.image = ImageCache().imageWithIdentifier("DSC05363")
        
        
        return cell
    }
    
    
    

        
        
        
        
        
    
    //     func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    //    {
    //
    //        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
    //
    //        detailController.meme = self.memes[indexPath.item]
    //        self.navigationController!.pushViewController(detailController, animated: true)
    //        
    //    }
    
    
    
    
    
    

   
    
  
    func downloadPhotoUrls() {
         print("downloading")
        
     FlickerNetworking().getImageFromFlickrBySearchWithPage(pin.location.latitude, long: pin.location.longitude){(success, picturesUrls: [String], errorString) in
        
        
        
            print(picturesUrls)
        
            for url in picturesUrls {
        
                            let photo = Photo(dictionary: url, context: self.sharedContext)
                            photo.pin = self.pin
                
                     }
        
                       CoreDataStackManager.sharedInstance().saveContext()
                        

        
        
        
        }
    }
    


    
    func appending() {

        
        var annotations = [MKPointAnnotation]()
        
            let coordinate = CLLocationCoordinate2D(latitude: pin.location.latitude, longitude: pin.location.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotations.append(annotation)
        
        self.mapKit.addAnnotations(annotations)
        
  
        
    }
    
    
    
    
    
    func fetchAllPins() -> [Pin] {
       
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
        } catch let error as NSError {
            print("Error in fetchAllPins(): \(error)")
            return [Pin]()
        }
    }
    
 

    
    
    
}





