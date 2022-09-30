//
//  SetupViewController.swift
//  PetProject
//
//  Created by MAC  on 04.07.2022.
//

import UIKit

class SetupViewController: UIViewController {
    
    private let age = 20
    private var recommendation = "В вашем возрасте рекомендуется спать"
    private var sleepRange = 0.0...0.0
    private let notifications = Notifications()
    private var minutesCount = 0
    private var hoursCount: Int {
        setupHoursCount()
    }
    
    private var relativeValueOfHours: Double {
        round((Double(hoursCount) + Double(minutesCount)/60) * 100) / 100
    }
    
    @IBOutlet var sleepTime: UIDatePicker!
    @IBOutlet var wakeUpTime: UIDatePicker!
    @IBOutlet var recommendationLabel: UILabel!
    @IBOutlet var colorIndicator: UIView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var indicatorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        
        saveButton.isEnabled = false
        
        sleepTime.date = StorageManager.shared.getDatesForDatePickers().sleepDate
        wakeUpTime.date = StorageManager.shared.getDatesForDatePickers().wakeUpDate
        
        sleepTime.overrideUserInterfaceStyle = .dark
        wakeUpTime.overrideUserInterfaceStyle = .dark
        
        changeValueForSubviews()
        
        switch age {
        case 0...13:
            sleepRange = 9...11
            recommendationLabel.text = recommendation + " 9 - 11 часов."
        case 14...17:
            sleepRange = 8...10
            recommendationLabel.text = recommendation + " 8 - 10 часов."
        case 18...64:
            sleepRange = 7...9
            recommendationLabel.text = recommendation + " 7 - 9 часов."
        default:
            sleepRange = 7...8
            recommendationLabel.text = recommendation + " 7 - 8 часов."
        }
    }
    
    @IBAction func datePickersChanged() {
        changeValueForSubviews()
        saveButton.isEnabled = relativeValueOfHours == 0 ? false : true
    }
    
    private func changeValueForSubviews() {
        if sleepRange.contains(relativeValueOfHours) {
            colorIndicator.backgroundColor = #colorLiteral(red: 0.01606260887, green: 0.5, blue: 1.665334537e-16, alpha: 1)
            indicatorLabel.text = "Длительность сна в пределах нормы."
        } else {
            colorIndicator.backgroundColor = #colorLiteral(red: 0.5740699383, green: 0.005374302427, blue: 0, alpha: 1)
            indicatorLabel.text = "Длительность сна не соответствует норме!"
        }
    }
    
    @IBAction func saveButtonPressed() {
        StorageManager.shared.saveDatesForDatePickers(sleepDate: sleepTime.date, wakeUpDate: wakeUpTime.date)
        
        notifications.toCallAdditionalNotifications(sleepTime: sleepTime.date)
        notifications.scheduleAlarm(date: wakeUpTime.date, repeats: true)
        
        let sleepDay = SleepDay(date: Date(), hour: hoursCount, minute: minutesCount)
        StorageManager.shared.save(sleepDay: sleepDay)
        StorageManager.shared.save(switchStatus: true, with: "alarmSwitch")
        sleepTime.setDate(sleepTime.date, animated: true)
        saveButton.isEnabled = false
    }
    
    private func getHoursAndMinutes(fromDate date: Date) -> (Int, Int) {
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        return (hours, minutes)
    }
    
    private func setupHoursCount() -> Int {
        var count = 0
        
        let timeValueForSleepTime = getHoursAndMinutes(fromDate: sleepTime.date)
        let timeValueForWakeUpTime = getHoursAndMinutes(fromDate: wakeUpTime.date)
        let hoursOfSleepTime = timeValueForSleepTime.0
        let minutesOfSleepTime = timeValueForSleepTime.1
        let hoursOfWakeUpTime = timeValueForWakeUpTime.0
        let minutesOfWakeUpTime = timeValueForWakeUpTime.1
        
        if hoursOfWakeUpTime < hoursOfSleepTime {
            count = 24 - hoursOfSleepTime + hoursOfWakeUpTime
        } else {
            count = hoursOfWakeUpTime - hoursOfSleepTime
        }
        
        let minutesDifference = minutesOfWakeUpTime - minutesOfSleepTime
        
        if minutesDifference >= 0 {
            minutesCount = minutesDifference
        } else {
            minutesCount = 60 + minutesDifference
            count -= 1
        }
            
        return count
    }
}
 
