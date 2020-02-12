//
//  LocationNotificationInfo.swift
//  Where in the World
//
//  Created by Susan on 2/12/20.
//  Copyright © 2020 Susan. All rights reserved.
//https://medium.com/@jonathan2457/location-triggered-notifications-on-ios-24033919fb9a

import CoreLocation

struct LocationNotificationInfo {
    
    // Identifiers
    let notificationId: String
    let locationId: String
    
    // Location
    let radius: Double
    let latitude: Double
    let longitude: Double
    
    // Notification
    let title: String
    let body: String
    let data: [String: Any]?
    
    /// CLLocation Coordinates
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
