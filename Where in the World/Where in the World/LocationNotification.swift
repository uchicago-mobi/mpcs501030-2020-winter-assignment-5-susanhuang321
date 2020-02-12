//
//  locationNotification.swift
//  Where in the World
//
//  Created by Susan on 2/12/20.
//  Copyright © 2020 Susan. All rights reserved.
//https://medium.com/@jonathan2457/location-triggered-notifications-on-ios-24033919fb9a

import CoreLocation
import UserNotifications

class LocationNotification: NSObject {
    
    
    weak var delegate: LocationNotificationSchedulerDelegate? {
        didSet {
            UNUserNotificationCenter.current().delegate = delegate
        }
    }
    
    
    private let locationManager = CLLocationManager()
    
    
    func requestNotification(with notificationInfo: LocationNotificationInfo) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
            locationManager.requestAlwaysAuthorization()
            askForNotificationPermissions(notificationInfo: notificationInfo)
        case .restricted, .denied:
            delegate?.locationPermissionDenied()
            break
        @unknown default:
            fatalError()
        }
    }
}

private extension LocationNotification {
    
    func askForNotificationPermissions(notificationInfo: LocationNotificationInfo) {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { [weak self] granted, _ in
                guard granted else {
                    self?.delegate?.notificationPermissionDenied()
                    return
                }
                self?.requestNotification(notificationInfo: notificationInfo)
        })
    }
    
    func requestNotification(notificationInfo: LocationNotificationInfo) {
        let notification = notificationContent(notificationInfo: notificationInfo)
        let destRegion = destinationRegion(notificationInfo: notificationInfo)
        let trigger = UNLocationNotificationTrigger(region: destRegion, repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationInfo.notificationId, content: notification, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { [weak self] (error) in
            DispatchQueue.main.async {
                self?.delegate?.notificationScheduled(error: error)
            }
        }
    }
    
    func notificationContent(notificationInfo: LocationNotificationInfo) -> UNMutableNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.title = notificationInfo.title
        notification.body = notificationInfo.body
        notification.sound = UNNotificationSound.default
        
        if let data = notificationInfo.data {
            notification.userInfo = data
        }
        return notification
    }
    
    func destinationRegion(notificationInfo: LocationNotificationInfo) -> CLCircularRegion {
        let destRegion = CLCircularRegion(center: notificationInfo.coordinates,
                                          radius: notificationInfo.radius,
                                          identifier: notificationInfo.locationId)
        destRegion.notifyOnEntry = true
        destRegion.notifyOnExit = false
        return destRegion
    }
}
