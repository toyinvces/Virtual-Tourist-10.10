//
//  Photo.swift
//  Virtual Tourist 10.0
//
//  Created by Cesar Ramirez on 11/30/15.
//  Copyright © 2015 Cesar Ramirez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc(Photo)

class Photo: NSManagedObject {

    struct keys {
        
        static let title = "title"
        static let filePath = "filePath"
       static let flickerPath = "flickerPath"
        
    }
    
            @NSManaged var filePath: String?
            @NSManaged var flickerPath: String?
            @NSManaged var title: String?
            @NSManaged var pin: Pin?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    
    }
    init(dictionary: String, context: NSManagedObjectContext) {
        
        // Core Data
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        flickerPath = dictionary
        filePath = dictionary
        
//        title = dictionary[keys.title] as? String
//        filePath = dictionary[keys.filePath] as? String
//        flickerPath = dictionary[keys.flickerPath] as? String
        
    }
    
    var posterImage: UIImage? {
        
        get {
            
            return FlickerNetworking.Caches.imageCache.imageWithIdentifier(filePath)
        }
        
        set {
            FlickerNetworking.Caches.imageCache.storeImage(newValue, withIdentifier: filePath!)
        }
    }
    


}



