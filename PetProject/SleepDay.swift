//
//  SleepDay.swift
//  PetProject
//
//  Created by MAC  on 05.07.2022.
//

import Foundation

struct SleepDay: Codable {
    let date: Date
    let hour: Int
    let minute: Int
    
    var relativeValueOfHours: Double {
        Double(hour) + Double(minute)/60
    }
}

struct NotificationComponent: Codable {
    let text: String
    let date: Date
    let timeInterval: Double
}

struct Section {
    let title: String
    let subtitle: String
    var isOpened = false
}

