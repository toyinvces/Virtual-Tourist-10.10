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

    

 //   var pins = [Pin]()
    

    
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
        
        let touchPoint = gestureRecognizer.locationInView(self.mapView)
        let newCoord:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        
        
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        
        appDelegate.lat = newCoord.latitude
        appDelegate.long = newCoord.longitude
        
        lati = newCoord.latitude
        long = newCoord.longitude
        
        let dictionary: [String: AnyObject] = [
            Pin.Keys.longitude: long,
            Pin.Keys.latitude: lati,
            
        ]
  
        let pinToAdd = Pin(dictionary: dictionary, context: self.sharedContext)
            
            
            
        self.pins.append(pinToAdd)
            
            let newAnotation = LocationAnnotation(pin: pinToAdd)
            
            newAnotation.coordinate = newCoord
            mapView.addAnnotation(newAnotation)
            
            
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

            
            newAnotation.coordinate.latitude = dictionary.latitude as! Double
            newAnotation.coordinate.longitude = dictionary.longitude as! Double
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
    

    
}

