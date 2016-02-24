//
//  Pin.swift
//  Virtual Tourist 10.0
//
//  Created by Cesar Ramirez on 11/30/15.
//  Copyright © 2015 Cesar Ramirez. All rights reserved.
//




//
//class Pin: NSManagedObject ,MKAnnotation {
//
//    struct Keys {
//        static let latitude = "latitude"
//        static let longitude  = "longitude"
//        static let photos = "photos"
//    }
//    
//        @NSManaged var latitude: NSNumber?
//        @NSManaged var longitude: NSNumber?
//        @NSManaged var photos: NSOrderedSet?
//      //  @NSManaged var photos: [Photo]
//
//
//    
//    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
//        super.init(entity: entity, insertIntoManagedObjectContext: context)
//    }
//    
//    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
//        
//        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
//        
//        super.init(entity: entity,insertIntoManagedObjectContext: context)
//        
//        latitude = dictionary[Keys.latitude] as! Double
//        longitude = dictionary[Keys.longitude] as! Double
//        
//    }
//
//    var coordinate: CLLocationCoordinate2D {
//        return CLLocationCoordinate2D(latitude: latitude! as Double, longitude: longitude! as Double)
//    }
//
//}




import MapKit
import CoreData

@objc(Pin)


class Pin : NSManagedObject {
    

//    struct Constants {
//        static let EntityName = "Pin"
//    }
    
   
    struct Keys {
        static let latitude = "latitude"
        static let longitude  = "longitude"
        static let photos = "photos"
    }
    
    @NSManaged private var latitude : Double
    @NSManaged private var longitude : Double
    @NSManaged var photos : [Photo]
    
    // Standard Core Data init method
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    /**
     * Two argument Init method:
     *  - insert the new Pin into a Core Data Managed Object Context
     *  - initialize the Pin's properties from a dictionary
     */
    
    init(dictionary: CLLocationCoordinate2D, context: NSManagedObjectContext) {
        
        // Get the entity associated with the "Pin" type
        // This is an object that contains the information from the VirtualTourist.xcdatamodeld file
        //let entity =  NSEntityDescription.entityForName(Pin.Constants.EntityName, inManagedObjectContext: context)!
        
         let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        
        // Now we can call an init method that we have inherited from NSManagedObject. Remember that
        // the Pin class is a subclass of NSManagedObject. This inherited init method does the
        // work of "inserting" our object into the context that was passed in as a parameter
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        
        // After the Core Data work has been taken care of we can init the properties from the dictionary
        latitude = dictionary.latitude
        longitude = dictionary.longitude
    }
    
    var location : CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
   
    

    
}

