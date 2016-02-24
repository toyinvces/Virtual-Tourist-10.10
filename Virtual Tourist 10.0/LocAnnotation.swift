//
//  LocAnnotation.swift
//  Virtual Tourist 10.0
//
//  Created by Cesar Ramirez on 12/17/15.
//  Copyright © 2015 Cesar Ramirez. All rights reserved.
//


import Foundation
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pin: Pin
    
    init(pin: Pin) {
        var lati = pin.location.latitude
        var long = pin.location.longitude
        
        self.coordinate = CLLocationCoordinate2DMake(lati,long)
        self.pin = pin
    }
}