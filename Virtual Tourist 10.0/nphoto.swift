//
//  photo.swift
//  Virtual Tourist 10.0
//
//  Created by Cesar Ramirez on 11/23/15.
//  Copyright © 2015 Cesar Ramirez. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class  uPhoto : NSManagedObject {
    
    struct keys {

    static let title = "title"
    static let flickerPath = "flickerPath"

    }
    
    @NSManaged var title: String
    @NSManaged var flickerPath: String?
    @NSManaged var pin: Pin?

    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
            init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
    
                // Core Data
                let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
                super.init(entity: entity, insertIntoManagedObjectContext: context)
    
                // Dictionary
                title = dictionary[keys.title] as! String
                flickerPath = dictionary[keys.flickerPath] as? String

            }
    
            var posterImage: UIImage? {
    
                get {
                   // return TheMovieDB.Caches.imageCache.imageWithIdentifier(posterPath)
                    
                    return FlickerNetworking.Caches.imageCache.imageWithIdentifier(flickerPath)
                }
    
                set {
                    FlickerNetworking.Caches.imageCache.storeImage(newValue, withIdentifier: flickerPath!)
                }
            }
    
//    init ( photo: UIImage){
//        self.photo = photo
//    }
    
    
}

