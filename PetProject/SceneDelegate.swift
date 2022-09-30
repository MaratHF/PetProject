//
//  SceneDelegate.swift
//  PetProject
//
//  Created by MAC  on 01.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var rootViewController = ""
    private let notifications = Notifications()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        checkingPastSleepDays()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        notifications.requestAuthorization()
        checkingPastSleepDays()
    }
    
    func checkingPastSleepDays() {
        guard let lastSleepDay = StorageManager.shared.fetchSleepDays().last else { return }
        
        let timeInterval = Date().timeIntervalSince1970 - lastSleepDay.date.timeIntervalSince1970
        
        let days = Int(timeInterval / 86400)
        
        if days > 0 {
            for x in 1...days {
                let sleepDay = SleepDay(
                    date: Date() + TimeInterval(86400 * x),
                    hour: lastSleepDay.hour,
                    minute: lastSleepDay.minute
                )
                StorageManager.shared.save(sleepDay: sleepDay)
            }
        }
    }
}

