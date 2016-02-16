//
//  Pin.swift
//  Virtual Tourist 10.0
//
//  Created by Cesar Ramirez on 11/30/15.
//  Copyright © 2015 Cesar Ramirez. All rights reserved.
//

import Foundation
import CoreData
import MapKit



class Pin: NSManagedObject ,MKAnnotation {

    struct Keys {
        static let latitude = "latitude"
        static let longitude  = "longitude"
        static let photos = "photos"
    }
    
        @NSManaged var latitude: NSNumber?
        @NSManaged var longitude: NSNumber?
        @NSManaged var photos: NSOrderedSet?
      //  @NSManaged var photos: [Photo]


    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        
        latitude = dictionary[Keys.latitude] as! Double
        longitude = dictionary[Keys.longitude] as! Double
        
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude! as Double, longitude: longitude! as Double)
    }

}
