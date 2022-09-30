//
//  Notifications.swift
//  PetProject
//
//  Created by MAC  on 01.07.2022.
//

import UserNotifications
import AVFoundation

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            
            if granted {
                StorageManager.shared.saveNotificationAuthorizationStatus(areAllowed: true)
            } else {
                StorageManager.shared.saveNotificationAuthorizationStatus(areAllowed: false)
            }
        }
    }
    
//    func getNotificationSettings() {
//        notificationCenter.getNotificationSettings { (settings) in
//            
//        }
//    }
    
    func scheduleNotification(text: String, date: Date, timeInterval: Double) {
        
        let content = UNMutableNotificationContent()
        let userAction = "User Action"
        
        content.title = "Пора готовиться ко сну!"
        content.body = text
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = userAction
        content.badge = 0
        
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: date - timeInterval)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        let identifier = text
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleAlarm(date: Date, repeats: Bool) {
        let content = UNMutableNotificationContent()
        let userAction = "Alarm"
        
        content.title = "Будильник"
        content.sound = UNNotificationSound(
            named: UNNotificationSoundName(rawValue: StorageManager.shared.getAlarmMelody())
        )
        content.categoryIdentifier = userAction
        
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: repeats)
        
        let identifier = "Alarm"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Отложить", options: [])
        let stopAction = UNNotificationAction(identifier: "Stop", title: "Отключить", options: [.destructive])
        let category = UNNotificationCategory(
            identifier: userAction,
            actions: [snoozeAction, stopAction],
            intentIdentifiers: [],
            options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    func deletePendingNotification(identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

            completionHandler([.banner, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {

        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("default")
        case "Snooze":
            scheduleAlarm(
                date: StorageManager.shared.getDatesForDatePickers().wakeUpDate
                + TimeInterval(StorageManager.shared.getCurrentSnoozeTime()),
                repeats: false
            )
        default:
            break
        }

        completionHandler()
    }
    
    func toCallAdditionalNotifications(sleepTime: Date) {
        let notifications = StorageManager.shared.fetchAdditionalNotifications()
        for notification in notifications {
            scheduleNotification(
                text: notification.text,
                date: sleepTime,
                timeInterval: notification.timeInterval
            )
        }
    }
}
