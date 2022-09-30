//
//  NotificationTimeViewController.swift
//  PetProject
//
//  Created by MAC  on 26.07.2022.
//

import UIKit

class NotificationTimeViewController: UIViewController {
    
    var recommendation = ""
    var key = ""
    var date = Date()
    var delegate: NotificationTimeViewControllerDelegate!
    var cellIndexPath: IndexPath?
    var viewControllerIndex = 1
    var defaultTime = "00:30"
    
    private let notifications = Notifications()
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var notificationName: UITextField!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.overrideUserInterfaceStyle = .dark
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        date = dateFormatter.date(from: defaultTime)!
        
        notificationName.text = recommendation
        if viewControllerIndex == 0 {
            notificationName.isUserInteractionEnabled = false
        }
        
        if notificationName.text == "" {
            saveButton.isEnabled = false
        }
        
        if key == "" || viewControllerIndex == 0 {
            deleteButton.isEnabled = false
        }
        
        if StorageManager.shared.getNotificationTime(key: key) != nil {
            datePicker.date = getDateFromSeconds()
        } else {
            datePicker.date = date
        }
    }
    
    @IBAction func textFieldChanged() {
        guard let notificationName = notificationName.text else { return }
        saveButton.isEnabled = !notificationName.isEmpty
    }
    
    @IBAction func cancel() {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed() {
        StorageManager.shared.saveNotificationTime(timeInterval: getSecondsFromDate(), key: notificationName.text! + "time")
        let sleepTime = StorageManager.shared.getDatesForDatePickers().sleepDate
        
        StorageManager.shared.save(switchStatus: true, with: notificationName.text!)
        StorageManager.shared.saveAdditionalNotifications(
            notification: NotificationComponent(
                text: notificationName.text!,
                date: sleepTime,
                timeInterval: Double(getSecondsFromDate())
            )
        )
        notifications.toCallAdditionalNotifications(sleepTime: sleepTime)
        
        if recommendation != notificationName.text! {
            StorageManager.shared.deleteAdditionalNotifications(notificationName: recommendation)
            notifications.deletePendingNotification(identifier: recommendation)
        }
        
        delegate.refreshRecommendationList(recommendationName: notificationName.text!, indexPath: cellIndexPath)
        dismiss(animated: true)
    }
    
    @IBAction func deleteRecommendation() {
        delegate.deleteCell(indexPath: cellIndexPath)
        StorageManager.shared.deleteAdditionalNotifications(notificationName: recommendation)
        notifications.deletePendingNotification(identifier: recommendation)
        dismiss(animated: true)
    }
    
    private func getSecondsFromDate() -> Int {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: datePicker.date)
        let minute = calendar.component(.minute, from: datePicker.date)
        
        return hour * 3600 + minute * 60
    }
    
    private func getDateFromSeconds() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let seconds = StorageManager.shared.getNotificationTime(key: key)!
        let hour = seconds / 3600
        let minute = (seconds % 3600) / 60
        
        guard let time = dateFormatter.date(from: "\(hour):\(minute)") else { return Date() }
        
        return time
    }
}

// MARK: - Keyboard
extension NotificationTimeViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
