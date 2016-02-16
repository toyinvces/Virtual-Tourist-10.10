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
    
 //   var imageURL:UIImageView!
    
    var pin: Pin!
    
   // var pins = [Pin]()

    var photos = [Photo]()

    
   // var photos = [Photo]()
    
    
    @IBOutlet weak var testImage: UIImageView!
    
    
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func test(sender: AnyObject) {
        if photos.isEmpty {
            
            print("is still empty")
            
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appending()
        
     //    let pin = pins[0]
        
        testImage.image = ImageCache().imageWithIdentifier("DSC05363")
        
        print(pin.coordinate.latitude)
        print(pin.coordinate.longitude)

      //  self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let methodArguments = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "bbox": createBoundingBoxString(),
            "safe_search": SAFE_SEARCH,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        
        
         self.photos = pin?.photos?.array as! [Photo]
        
    //  if ((pin.photos?.array.isEmpty) != nil) {
        
        if photos.isEmpty {
        
       // if pin.photos.isEmpty {
            
            print("Photos is empty")
            
            FlickerNetworking().getImageFromFlickrBySearchWithPage(methodArguments, pageNumber: 1){(success, JSONResult,  errorString) in
                
                if success == true {
                    
                   let photosDictionary = JSONResult!["photos"] as? NSDictionary
                    
                    let photosArray = photosDictionary!["photo"] as? [[String: AnyObject]]

  for index in 1...10 {
           
                    let randomPhotoIndex = Int(arc4random_uniform(UInt32(photosArray!.count)))
    
                    let photoDictionary = photosArray![randomPhotoIndex] as [String: AnyObject]
    
                    let imageUrlString = photoDictionary["url_m"] as? String
    
                    let imageTitle = photoDictionary["title"] as? String

                    print(imageUrlString)
                    print(imageTitle)
        
                    let imageURL = NSURL(string: imageUrlString!)

        
                    if let imageData = NSData(contentsOfURL: imageURL!) {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                                let finalImage = UIImage(data: imageData)
                    
                            ImageCache().storeImage(finalImage, withIdentifier: imageTitle!)
                            
                            let dictionary: [String: AnyObject] = [
                                
                
                                Photo.keys.title: imageTitle!
                                
                            ]
                            
                            let pic = Photo(dictionary: dictionary, context: self.sharedContext)
                            
                         
                            
                            self.photos.append(pic)
                            
                            
                            
                            self.saveContext()
                
                    
                            })
            
                    } else {
                        print("Image does not exist at \(imageURL)")
                    }
    
                    }
            
               }
                
            }
            
        }
    
    }
        
    
    
    
 

    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()

    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }




    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // print (self.photos.count)
      //  return self.photos.count
        
     //    let pin = pins[0]
        
        print("PHOTOS")
        print(pin.photos!.count)
        return pin.photos!.count
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
    
    
    
    
    
    
    
    
  
    func downloadImages(){
 

        
        
        
    }
    
    
    func createBoundingBoxString() -> String {
        
        let latitude = 41.6143230474317
        let longitude = -87.5337431087246
        
        let bottom_left_lon = (longitude - 0.02)
        let bottom_left_lat = (latitude - 0.02)
        let top_right_lon = (longitude + 0.02)
        let top_right_lat = (latitude + 0.02)
        
        return "\(bottom_left_lon),\(bottom_left_lat),\(top_right_lon),\(top_right_lat)"
    }

    
    func appending() {

        
        var annotations = [MKPointAnnotation]()
        
            let coordinate = CLLocationCoordinate2D(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
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



