//
//  LocationNotification.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 4/21/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications

class LocationNotificationCenter: NSObject, UNUserNotificationCenterDelegate {
    var notificationsPermissions: Bool = false
    
    func requestLocationNotificationPermissions(callback: @escaping (Bool) -> Void) {
        guard CLLocationManager.locationServicesEnabled() else { return }
        UNUserNotificationCenter.current().requestAuthorization(options:
            [.alert, .sound, .badge],
            completionHandler: {(granted,error) in
                self.notificationsPermissions = granted
                callback(granted);
        })
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func sendNotification(title: String, body: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "entering_location_alert", content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
            if let error  = error {
                print(error)
            }
            else {
                print("notification successfully sent")
            }
        })
    }
}
