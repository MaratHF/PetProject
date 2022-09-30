//
//  SettingsViewController.swift
//  PetProject
//
//  Created by MAC  on 21.08.2022.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    private let settingsList = [["Будильник", "Профайл"], ["Удалить данные о снах"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundViewColor()
        tableView.separatorColor = .white
    }
    
    private func setBackgroundViewColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.0923477529, green: 0.1613951182, blue: 0.3891475176, alpha: 1).cgColor, #colorLiteral(red: 0.1546722437, green: 0.02495219428, blue: 0.2035871579, alpha: 1).cgColor]
//        gradientLayer.locations = [NSNumber(value: 0.0), NSNumber(value: 1.0)]
        
        gradientLayer.frame = tableView.bounds
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.addSublayer(gradientLayer)
        tableView.backgroundView = backgroundView
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingsList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.07103329152, green: 0.2764123976, blue: 0.3522424996, alpha: 1)
        
        var content = cell.defaultContentConfiguration()
        content.text = settingsList[indexPath.section][indexPath.row]
        content.textProperties.color = .white
        cell.contentConfiguration = content

        return cell
    }
    // MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                navigationController?.pushViewController(AlarmSettingsViewController(), animated: true)
            default:
                performSegue(withIdentifier: "profileSegue", sender: nil)
            }
        } else {
            let alert = UIAlertController(title: "Удаление данных", message: "Вы действительно хотите удалить все данные о снах?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                StorageManager.shared.deleteSleepDays()
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            present(alert, animated: true)
        }
    }
}
