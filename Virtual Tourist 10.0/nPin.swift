//
//  Pin.swift
//  Virtual Tourist 10.0
//
//  Created by Cesar Ramirez on 11/25/15.
//  Copyright © 2015 Cesar Ramirez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class uPin : NSManagedObject {

    
    struct Keys {
        static let latitude = "latitude"
        static let longitude  = "longitude"
        static let photos = "photos"
    }
    
    @NSManaged var latitude : Double
    @NSManaged var longitude: Double
    @NSManaged var photos: [Photo]
    

    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
        init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {

            let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
    
            super.init(entity: entity,insertIntoManagedObjectContext: context)
    
            latitude = dictionary[Keys.latitude] as! Double
            
            longitude = dictionary[Keys.longitude] as! Double

        }

    
}
