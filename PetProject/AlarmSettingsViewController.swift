//
//  AlarmSettingsViewController.swift
//  PetProject
//
//  Created by MAC  on 22.08.2022.
//

import UIKit

class AlarmSettingsViewController: UITableViewController {

    private let settings = [
        ["Вкл/выкл"],
        ["Мелодия", "Повтор через"],
        ["""
Для корректной работы будильника необходимо отключить беззвучный режим на телефоне.
Чтобы отложить сигнал будильника зажмите уведомление и выберете "Отложить".
"""]
    ]
    
    private let withSwitchVC = WithSwitchTableViewCell()
    private let switchKey = "alarmSwitch"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.register(withSwitchVC.nib(), forCellReuseIdentifier: withSwitchVC.cellID)
        tableView.register(AlarmSettingsTableViewCell.self, forCellReuseIdentifier: "alarmSettings")
        tableView.separatorColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBackgroundViewColor()
    }
    
    @objc private func changeSwitchStatus(sender: UISwitch) {
        if sender.isOn == true {
            StorageManager.shared.save(switchStatus: true, with: switchKey)
            Notifications().scheduleAlarm(
                date: StorageManager.shared.getDatesForDatePickers().wakeUpDate,
                repeats: true
            )
        } else {
            StorageManager.shared.save(switchStatus: false, with: switchKey)
            Notifications().deletePendingNotification(identifier: "Alarm")
        }
    }
    
    private func setBackgroundViewColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.0923477529, green: 0.1613951182, blue: 0.3891475176, alpha: 1).cgColor, #colorLiteral(red: 0.1546722437, green: 0.02495219428, blue: 0.2035871579, alpha: 1).cgColor]
//        gradientLayer.locations = [NSNumber(value: 0.0), NSNumber(value: 1.0)]
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height)
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.addSublayer(gradientLayer)
        tableView.backgroundView = backgroundView
    }
    // MARK: - TableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        settings.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmSettings", for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.07103329152, green: 0.2764123976, blue: 0.3522424996, alpha: 1)
        var content = cell.defaultContentConfiguration()
        content.text = settings[indexPath.section][indexPath.row]
        content.textProperties.color = .white

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: withSwitchVC.cellID, for: indexPath) as! WithSwitchTableViewCell
            cell.backgroundColor = #colorLiteral(red: 0.07103329152, green: 0.2764123976, blue: 0.3522424996, alpha: 1)
            cell.label.text = settings[indexPath.section][indexPath.row]
            cell.label.textColor = .white
            cell.switch.isOn = StorageManager.shared.getSwitchValue(key: switchKey)
            cell.switch.addTarget(self, action: #selector(changeSwitchStatus(sender:)), for: .valueChanged)
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                content.secondaryText = StorageManager.shared.getAlarmMelody().components(separatedBy: ".").first!
            } else if indexPath.row == 1 {
                content.secondaryText = "\(StorageManager.shared.getCurrentSnoozeTime()/60) минут"
            }
            content.secondaryTextProperties.color = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.addCustomDisclosureIndicator(
                symbolName: "chevron.right",
                width: 10,
                height: 15
            )
        } else {
            cell.selectionStyle = .none
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let navVC = UINavigationController(
                    rootViewController: ForAlarmSettingsViewController(
                        typeOfView: "melodies",
                        viewController: self
                    )
                )
                present(navVC, animated: true)
            } else if indexPath.row == 1 {
                let navVC = UINavigationController(
                    rootViewController: ForAlarmSettingsViewController(
                        typeOfView: "timeInterval",
                        viewController: self
                    )
                )
                present(navVC, animated: true)
            }
        }
    }
}

// MARK: - Protocol

extension AlarmSettingsViewController: NotificationTimeViewControllerDelegate {
    func refreshRecommendationList(recommendationName: String, indexPath: IndexPath?) {
        tableView.reloadData()
    }
}

// MARK: - UITableViewCell

class AlarmSettingsTableViewCell: UITableViewCell {
    private let cellID = "alarmSettings"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: cellID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Extension tableViewCell
extension UITableViewCell {
    func addCustomDisclosureIndicator(symbolName: String, width: Int, height: Int) {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .large)
        let symbolImage = UIImage(systemName: symbolName,
                                  withConfiguration: symbolConfig)
        button.setImage(symbolImage?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.tintColor = .white
        self.accessoryView = button
    }
}
