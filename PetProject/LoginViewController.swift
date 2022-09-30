//
//  LoginViewController.swift
//  PetProject
//
//  Created by MAC  on 12.09.2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    
    @IBAction func nextButtonPressed() {
        guard let name = nameTextField.text else { return }
        guard let age = ageTextField.text else { return }
        
        if name != "", age != "", let _ = Int(age) {
            StorageManager.shared.saveUserData(name: name, age: age)
        } else {
            let alert = UIAlertController(title: "Не удалось создать профиль", message: "Вы не заполнили поля, либо ввели неверный формат данных", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
        
        if StorageManager.shared.getNotificationAuthorizationStatus() {
            performSegue(withIdentifier: "loginSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "notificationAdmissionSegue", sender: nil)
        }
    }
}
