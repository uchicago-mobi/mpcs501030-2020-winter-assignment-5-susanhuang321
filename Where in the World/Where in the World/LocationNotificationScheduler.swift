//
//  LocationNotificationScheduler.swift
//  Where in the World
//
//  Created by Susan on 2/12/20.
//  Copyright © 2020 Susan. All rights reserved.
//https://medium.com/@jonathan2457/location-triggered-notifications-on-ios-24033919fb9a

import UserNotifications

protocol LocationNotificationSchedulerDelegate: UNUserNotificationCenterDelegate {
    
    func notificationPermissionDenied()
    
    func locationPermissionDenied()
    
    func notificationScheduled(error: Error?)
}
