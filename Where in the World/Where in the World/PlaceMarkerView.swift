//
//  PlaceMarkerView.swift
//  Where in the World
//
//  Created by Susan on 2/11/20.
//  Copyright © 2020 Susan. All rights reserved.
//

import MapKit
import UIKit

class PlaceMarkerView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
          clusteringIdentifier = "Place"
          displayPriority = .defaultLow
          markerTintColor = .systemRed
          glyphImage = UIImage(systemName: "pin.fill")
          }
    }
    
    

}
