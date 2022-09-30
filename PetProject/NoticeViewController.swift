//
//  NoticeViewController.swift
//  PetProject
//
//  Created by MAC  on 18.09.2022.
//

import UIKit

class NoticeViewController: UIViewController {
    
    @IBAction func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
    
    @IBAction func nextButtonPressed() {
        if StorageManager.shared.getNotificationAuthorizationStatus() {
            performSegue(withIdentifier: "notificationAllowedSegue", sender: nil)
        } else {
            let alert = UIAlertController(
                title: "Уведомления запрещены",
                message: "Пожалуйста, разрешите приложению отправлять уведомления.",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
}
