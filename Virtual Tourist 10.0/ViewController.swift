//
//  ViewController.swift
//  Virtual Tourist 10.0
//
//  Created by Cesar Ramirez on 11/23/15.
//  Copyright © 2015 Cesar Ramirez. All rights reserved.
//


import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, MKMapViewDelegate {
    
    var long: Double!
    var lati: Double!
    
   // var actors = [Person]()
    
    var pins = [Pin]()

    struct MapRegionKeys {
        static let Latitude = "Latitude"
        static let Longitude = "Longitude"
        static let LatiDelta = "LatiDelta"
        static let LongDelta = "LongDelta"
    }

    
    var activityIndicator = UIActivityIndicatorView()

    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var temporaryContext: NSManagedObjectContext!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       appending()
        
      //  restoreMap(false)
        
        //if gestureRec
        let longPress = UILongPressGestureRecognizer(target: self, action: "action:")
        longPress.minimumPressDuration = 0.4
        mapView.addGestureRecognizer(longPress)
        
        
        let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
        
        temporaryContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        temporaryContext.persistentStoreCoordinator = sharedContext.persistentStoreCoordinator
        
    }
    

    
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        if gestureRecognizer.state == .Began{
            
            
            let touchCoord : CGPoint = gestureRecognizer.locationInView(mapView)
            
            let latilong = mapView.convertPoint(touchCoord, toCoordinateFromView: mapView)
            
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = latilong
            
            mapView.addAnnotation(newAnnotation)
            
            

            let pinToAdd = Pin(dictionary: latilong, context: sharedContext)
            
            
            self.pins.append(pinToAdd)
            CoreDataStackManager.sharedInstance().saveContext()
            
            
            
    



            

    }
    }
    
    
    
    
    
    
    
    var sharedContext: NSManagedObjectContext{
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
                let ant = view.annotation as! MKPointAnnotation
        
                var collectionView = storyboard?.instantiateViewControllerWithIdentifier("CollectionView") as! CollectionViewController
        
        
                let error:NSErrorPointer = nil
                let fetchRequest = NSFetchRequest(entityName: "Pin")
                let firstPredicate = NSPredicate(format: "latitude == %@", NSNumber(double: ant.coordinate.latitude))
                let SecondPredicate = NSPredicate(format: "longitude == %@",NSNumber(double: ant.coordinate.longitude))
                let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [firstPredicate, SecondPredicate])
                fetchRequest.predicate = predicate
        
                do {
                    let results = try sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
                    let pin = results as! [Pin]
        
                    collectionView.pin = pin[0]
        
                } catch let error as NSError {
                    print("Error in fetchAllPins(): \(error)")
                    return //[Pin]()
                }
                
                
                presentViewController(collectionView, animated: true, completion: nil)
        

    }
    
    
    
    func collection(){
        let ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CollectionView") as! CollectionViewController
        
        ViewController.lat = lati
        ViewController.lon = long
        
        self.presentViewController(ViewController, animated: true, completion: nil)
        }    

    
    
    func appending() {
        
        let coordinates = fetchAllPins()
        
        for dictionary in coordinates {
        
                Pin.Keys.longitude
                Pin.Keys.latitude
            
            
            let newAnotation =  MKPointAnnotation()

            
            newAnotation.coordinate.latitude = dictionary.location.latitude 
            newAnotation.coordinate.longitude = dictionary.location.longitude
            mapView.addAnnotation(newAnotation)
            
        }
        
    }
    
  

    
    func fetchAllPins() -> [Pin] {
        // Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
        
        // Execute the Fetch Request
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
        } catch let error as NSError {
            print("Error in fetchAllPins(): \(error)")
            return [Pin]()
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveMap()
    }
    
    func saveMap() {
    
       // print("saving")
        let dictionary = [
            MapRegionKeys.Latitude : mapView.region.center.latitude,
            MapRegionKeys.Longitude : mapView.region.center.longitude,
            MapRegionKeys.LatiDelta : mapView.region.span.latitudeDelta,
            MapRegionKeys.LongDelta : mapView.region.span.longitudeDelta
        ]
        
        NSKeyedArchiver.archiveRootObject(dictionary, toFile: mapRegion)
    }
    

    func restoreMap(animated: Bool) {
        
        print("restoring...")
        
        if let regionDictionary = NSKeyedUnarchiver.unarchiveObjectWithFile(mapRegion) as? [String : AnyObject] {
            
            let latitude = regionDictionary[MapRegionKeys.Latitude] as! CLLocationDegrees
            let longitude = regionDictionary[MapRegionKeys.Longitude] as! CLLocationDegrees
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let latitudeDelta = regionDictionary[MapRegionKeys.LatiDelta] as! CLLocationDegrees
            let longitudeDelta = regionDictionary[MapRegionKeys.LongDelta] as! CLLocationDegrees
            let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            
            let savedRegion = MKCoordinateRegion(center: center, span: span)
            
            
            mapView.setRegion(savedRegion, animated: animated)
        }
    }
    var mapRegion : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        return url.URLByAppendingPathComponent("mapRegion").path!
    }
    
}

