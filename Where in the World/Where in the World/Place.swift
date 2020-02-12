//
//  Place.swift
//  Where in the World
//
//  Created by Susan on 2/11/20.
//  Copyright © 2020 Susan. All rights reserved.
//

import UIKit
import MapKit

class Place: MKPointAnnotation {
    var name: String?
    var longDescription: String?
    init(lat: Double, long: Double){
        super.init()
        
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
