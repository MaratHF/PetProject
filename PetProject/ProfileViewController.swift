//
//  ProfileViewController.swift
//  PetProject
//
//  Created by MAC  on 08.09.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var changeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = StorageManager.shared.getUserData().name
        ageTextField.text = StorageManager.shared.getUserData().age
        
        changeButton.isEnabled = false
    }
    
    @IBAction func changeButtonPressed() {
        guard let name = nameTextField.text else { return }
        guard let age = ageTextField.text else { return }
        
        if name != "", age != "", let _ = Int(age) {
            StorageManager.shared.saveUserData(name: name, age: age)
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Не удалось изменить данные", message: "Вы не заполнили поля, либо ввели неверный формат данных", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
    @IBAction func textFieldChanged() {
        changeButton.isEnabled = true
    }
}
// MARK: - Keyboard
extension ProfileViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            ageTextField.becomeFirstResponder()
        } else {
            changeButtonPressed()
        }
        return true
    }
}
