//
//  AdditionalRecommendationViewController.swift
//  PetProject
//
//  Created by MAC  on 16.07.2022.
//

import UIKit

protocol NotificationTimeViewControllerDelegate {
    func refreshRecommendationList(recommendationName: String, indexPath: IndexPath?)
    
    func deleteCell(indexPath: IndexPath?)
}

extension NotificationTimeViewControllerDelegate {
    func deleteCell(indexPath: IndexPath?) {}
}

class AdditionalRecommendationViewController: UITableViewController {
    
    var defaultRecommendations = DataStorage().additionalNotificationsList
    var recommendationsList = StorageManager.shared.getAdditionalRecommendation()
    
    private let notifications = Notifications()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundViewColor()
        tableView.separatorColor = .white
        
        if recommendationsList == nil {
            StorageManager.shared.saveAdditionalRecommendation(list: defaultRecommendations)
            recommendationsList = StorageManager.shared.getAdditionalRecommendation()
        }
    }
    
    @IBAction func changedSwiftStatus(_ sender: UISwitch) {
        guard let indexPath = tableView.indexPath(
            for: sender.superview?.superview as! UITableViewCell) else { return }
        StorageManager.shared.save(switchStatus: sender.isOn, with: recommendationsList![indexPath.row])
        let sleepTime = StorageManager.shared.getDatesForDatePickers().sleepDate
       
        if sender.isOn == true {
           let timeInterval = StorageManager.shared.getNotificationTime(
            key: recommendationsList![indexPath.row] + "time") ?? 3600
            
            StorageManager.shared.saveAdditionalNotifications(
                notification: NotificationComponent(
                    text: recommendationsList![indexPath.row],
                    date: sleepTime,
                    timeInterval: Double(timeInterval)
                )
            )
            notifications.toCallAdditionalNotifications(sleepTime: sleepTime)
        } else {
            StorageManager.shared.deleteAdditionalNotifications(notificationName: recommendationsList![indexPath.row])
            notifications.deletePendingNotification(identifier: recommendationsList![indexPath.row])
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showNotificationTime", sender: nil)
    }
    
    private func getTimeFromSeconds(indexPath: IndexPath) -> String {
        let seconds = StorageManager.shared.getNotificationTime(key: recommendationsList![indexPath.row] + "time")!
        let hour = seconds / 3600
        let minute = seconds % 3600 / 60
        var hourInString = String(hour)
        var minuteInString = String(minute)
        
        if hour < 10 {
            hourInString = "0\(hour) ч"
        }
        
        if minute < 10 {
            minuteInString = "0\(minute) мин"
        }
        
        return hourInString + " " + minuteInString
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recommendationsList!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailRecommendationCell", for: indexPath) as! DetailsRecommendationTableViewCell
        
        cell.backgroundColor = .clear
        cell.recommendationSwitch.isOn = StorageManager.shared.getSwitchValue(
            key: recommendationsList![indexPath.row]
        )
        cell.addCustomDisclosureIndicator(
            symbolName: "chevron.right",
            width: 10,
            height: 15
        )
        
        if StorageManager.shared.getNotificationTime(key: recommendationsList![indexPath.row] + "time") != nil {
            cell.recommendationLabel.text = recommendationsList![indexPath.row] + " - Уведомление придет за \(getTimeFromSeconds(indexPath: indexPath)) до сна."
        } else {
            cell.recommendationLabel.text = recommendationsList![indexPath.row] + " - Уведомление придет за 01 ч 00 мин до сна."
        }
        cell.recommendationLabel.textColor = .white
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            self.recommendationsList!.remove(at: indexPath.row)
            StorageManager.shared.saveAdditionalRecommendation(list: self.recommendationsList!)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let notificationTimeVC = segue.destination as? NotificationTimeViewController else { return }
        
        notificationTimeVC.delegate = self
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        notificationTimeVC.key = recommendationsList![indexPath.row] + "time"
        notificationTimeVC.recommendation = recommendationsList![indexPath.row]
        notificationTimeVC.cellIndexPath = indexPath
        notificationTimeVC.defaultTime = "01:00"
    }
}

extension AdditionalRecommendationViewController: NotificationTimeViewControllerDelegate {
    func refreshRecommendationList(recommendationName: String, indexPath: IndexPath?) {
        
        if indexPath != nil {
            recommendationsList![indexPath!.row] = recommendationName
        } else {
            recommendationsList!.append(recommendationName)
        }
        
        StorageManager.shared.saveAdditionalRecommendation(list: recommendationsList!)
        tableView.reloadData()
    }
    
    func deleteCell(indexPath: IndexPath?) {
        recommendationsList!.remove(at: indexPath!.row)
        StorageManager.shared.saveAdditionalRecommendation(list: recommendationsList!)
        tableView.reloadData()
    }
}
