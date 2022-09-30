//
//  ForAlalarmSettingsViewController.swift
//  PetProject
//
//  Created by MAC  on 02.09.2022.
//

import UIKit
import AVFoundation

class ForAlarmSettingsViewController: UITableViewController {
    
    private let melodies = [
        "Радость.mp3",
        "Бодрость.mp3",
        "Вдохновение.mp3",
        "Наслаждение.mp3",
        "Аннигиляция.mp3",
        "Задор.mp3"
    ]
    private let timeInterval = ["5 минут", "7 минут", "10 минут", "15 минут"]
    private let typeOfView: String
    private let cellID = "ForAlarmSettingsViewController"
    private let alarmMelodyVC = AlarmMelodyTableViewCell()
    private var isButtonTapped = false
    private var player = AVAudioPlayer()
    private var delegate: NotificationTimeViewControllerDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.register(alarmMelodyVC.nib(), forCellReuseIdentifier: alarmMelodyVC.cellID)
        tableView.separatorColor = .white
        
        if typeOfView == "melodies" {
            title = "Выберете мелодию"
        } else {
            title = "Выберете промежуток повтора"
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBackgroundViewColor()
    }
    
    init(typeOfView: String, viewController: NotificationTimeViewControllerDelegate) {
        self.typeOfView = typeOfView
        self.delegate = viewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func playSound(melodyName: String) {
        guard let url = Bundle.main.url(
            forResource: melodyName.components(separatedBy: ".").first!,
            withExtension: melodyName.components(separatedBy: ".").last!
        ) else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("Error: \(error)")
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            print("Error: \(error)")
        }
        
        player.play()
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
    
    private func stopSound() {
        player.stop()
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func didButtonPressed(sender: UIButton) {
        guard let indexPath = tableView.indexPath(
            for: sender.superview?.superview as! AlarmMelodyTableViewCell) else { return }
        if isButtonTapped {
            stopSound()
            isButtonTapped.toggle()
        } else {
            playSound(melodyName: melodies[indexPath.row])
            isButtonTapped.toggle()
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = typeOfView == "melodies" ? melodies.count : timeInterval.count
        return num
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if typeOfView == "melodies" {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: alarmMelodyVC.cellID, for: indexPath) as! AlarmMelodyTableViewCell
            cell.backgroundColor = .clear
            cell.configure(text: melodies[indexPath.row].components(separatedBy: ".").first!)
            cell.label.textColor = .white
            cell.button.addTarget(self, action: #selector(didButtonPressed(sender:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            cell.backgroundColor = #colorLiteral(red: 0.07180167317, green: 0.2742417609, blue: 0.3542792116, alpha: 1)
            var content = cell.defaultContentConfiguration()
            content.text = timeInterval[indexPath.row]
            content.textProperties.color = .white
            cell.contentConfiguration = content
            return cell
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if typeOfView == "melodies" {
            StorageManager.shared.saveAlarmMelody(name: melodies[indexPath.row])
        } else {
            let str = String(timeInterval[indexPath.row].first!)
            let num = Int(str)! * 60
            StorageManager.shared.saveCurrentSnoozeTime(number: num)
        }
        
        Notifications().scheduleAlarm(
            date: StorageManager.shared.getDatesForDatePickers().wakeUpDate,
            repeats: true
        )
        
        delegate.refreshRecommendationList(recommendationName: "", indexPath: nil)
        dismiss(animated: true)
    }
}
