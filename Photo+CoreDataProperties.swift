//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist 10.0
//
//  Created by Cesar Ramirez on 1/11/16.
//  Copyright © 2016 Cesar Ramirez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var flickerPath: String?
    @NSManaged var title: String?
    @NSManaged var filePath: String?
    @NSManaged var pins: NSOrderedSet?

}
