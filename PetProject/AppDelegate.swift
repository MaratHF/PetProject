//
//  AppDelegate.swift
//  PetProject
//
//  Created by MAC  on 01.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let notifications = Notifications()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
            ]
            navigationBarAppearance.backgroundColor = #colorLiteral(red: 0.0923477529, green: 0.1613951182, blue: 0.3891475176, alpha: 1)
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = #colorLiteral(red: 0.1546722437, green: 0.02495219428, blue: 0.2035871579, alpha: 1)
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        
        notifications.requestAuthorization()
        notifications.notificationCenter.delegate = notifications
        return true
    }
}

