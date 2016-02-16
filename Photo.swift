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


class Photo: NSManagedObject {

    struct keys {
        
        static let title = "title"
        static let filePath = "filePath"
       static let flickerPath = "flickerPath"
        
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Core Data
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        
        title = dictionary[keys.title] as? String
        filePath = dictionary[keys.filePath] as? String
        flickerPath = dictionary[keys.flickerPath] as? String
        
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
