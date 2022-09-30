//
//  StorageManager.swift
//  PetProject
//
//  Created by MAC  on 05.07.2022.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let sleepDayKey = "sleepDays"
    private let sleepDatePickerKey = "sleepDatePicker"
    private let wakeUpDatePickerKey = "wakeUpDatePicker"
    private let recommendationsKey = "recommendationsKey"
    private let notificationsKey = "notificationsKey"
    private let alarmKey = "alarmKey"
    private let snoozeTimeKey = "snoozeTimeKey"
    private let userNameKey = "userNameKey"
    private let userAgeKey = "userAgeKey"
    private let notificationAuthorizationStatusKey = "notificationAuthorizationStatusKey"
    
    private init() {}
    
    func getNotificationAuthorizationStatus() -> Bool {
        userDefaults.value(forKey: notificationAuthorizationStatusKey) as? Bool ?? false
    }
    
    func saveNotificationAuthorizationStatus(areAllowed: Bool) {
        userDefaults.set(areAllowed, forKey: notificationAuthorizationStatusKey)
    }
    
    func getUserData() -> (name: String, age: String) {
        let name = userDefaults.value(forKey: userNameKey) as? String ?? ""
        let age = userDefaults.value(forKey: userAgeKey) as? String ?? ""
        return (name, age)
    }
    
    func saveUserData(name: String, age: String) {
        userDefaults.set(name, forKey: userNameKey)
        userDefaults.set(age, forKey: userAgeKey)
    }
    
    func getCurrentSnoozeTime() -> Int {
        userDefaults.value(forKey: snoozeTimeKey) as? Int ?? 300
    }
    
    func saveCurrentSnoozeTime(number: Int) {
        userDefaults.set(number, forKey: snoozeTimeKey)
    }
    
    func getAlarmMelody() -> String {
        userDefaults.value(forKey: alarmKey) as? String ?? "Радость.mp3"
    }
    
    func saveAlarmMelody(name: String) {
        userDefaults.set(name, forKey: alarmKey)
    }
    
    func deleteAdditionalNotifications(notificationName: String) {
        var notifications = fetchAdditionalNotifications()
        var index = 0
        for notification in notifications {
            if notification.text != notificationName {
                index += 1
            } else { break }
        }
        if index < notifications.count {
            notifications.remove(at: index)
        }
        guard let data = try? JSONEncoder().encode(notifications) else { return }
        userDefaults.set(data, forKey: notificationsKey)
    }
    
    func fetchAdditionalNotifications() -> [NotificationComponent] {
        guard let data = userDefaults.data(forKey: notificationsKey) else { return [] }
        guard let notifications = try? JSONDecoder().decode([(NotificationComponent)].self, from: data) else { return [] }
        return notifications
    }
    
    func saveAdditionalNotifications(notification: NotificationComponent) {
        var notifications = fetchAdditionalNotifications()
        notifications.append(notification)
        guard let data = try? JSONEncoder().encode(notifications) else { return }
        userDefaults.set(data, forKey: notificationsKey)
    }
    
    func getAdditionalRecommendation() -> [String]? {
        userDefaults.value(forKey: recommendationsKey) as? [String]
    }
    
    func saveAdditionalRecommendation(list: [String]) {
        userDefaults.set(list, forKey: recommendationsKey)
    }
    
    func getNotificationTime(key: String) -> Int? {
        userDefaults.value(forKey: key) as? Int
    }
    
    func saveNotificationTime(timeInterval: Int, key: String) {
        userDefaults.set(timeInterval, forKey: key)
    }
    
    func getDatesForDatePickers() -> (sleepDate: Date, wakeUpDate: Date) {
        let sleepDate = userDefaults.value(forKey: sleepDatePickerKey) as? Date ?? Date()
        let wakeUpDate = userDefaults.value(forKey: wakeUpDatePickerKey) as? Date ?? Date()
        return (sleepDate, wakeUpDate)
    }
    
    func saveDatesForDatePickers(sleepDate: Date, wakeUpDate: Date) {
        userDefaults.set(sleepDate, forKey: sleepDatePickerKey)
        userDefaults.set(wakeUpDate, forKey: wakeUpDatePickerKey)
    }
    
    func save(switchStatus: Bool, with key: String) {
        userDefaults.set(switchStatus, forKey: key)
    }
    
    func getSwitchValue(key: String) -> Bool {
        userDefaults.bool(forKey: key)
    }
    
    func deleteSleepDays() {
        let sleepDays: [SleepDay] = []
        userDefaults.set(sleepDays, forKey: sleepDayKey)
    }
    
    func save(sleepDay: SleepDay) {
        var sleepDays = fetchSleepDays()
        sleepDays.append(sleepDay)
        guard let data = try? JSONEncoder().encode(sleepDays) else { return }
        userDefaults.set(data, forKey: sleepDayKey)
    }
    
    func fetchSleepDays() -> [SleepDay] {
        guard let data = userDefaults.data(forKey: sleepDayKey) else { return [] }
        guard let sleepDays = try? JSONDecoder().decode([(SleepDay)].self, from: data) else { return [] }
        return sleepDays
    }
}
