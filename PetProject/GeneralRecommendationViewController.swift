//
//  GeneralRecommendationTableViewController.swift
//  PetProject
//
//  Created by MAC  on 16.07.2022.
//

import UIKit

class GeneralRecommendationViewController: UITableViewController {
    
    private var sections = DataStorage().sections
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "generalCell")
        tableView.separatorColor = .white
        title = "Общие рекомендации"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBackgroundViewColor()
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
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section].isOpened {
            return 2
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "generalCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if indexPath.row == 0 {
            content.text = sections[indexPath.section].title
            content.textProperties.font = UIFont.boldSystemFont(ofSize: 20)
            
            if sections[indexPath.section].isOpened {
                cell.addCustomDisclosureIndicator(
                    symbolName: "chevron.up",
                    width: 20,
                    height: 10
                )
            } else {
                cell.addCustomDisclosureIndicator(
                    symbolName: "chevron.down",
                    width: 20,
                    height: 10
                )
            }
        } else {
            content.text = sections[indexPath.section].subtitle
            content.textProperties.font = UIFont.systemFont(ofSize: 18)
            cell.accessoryView = .none
        }
        
        content.textProperties.color = .white
        cell.contentConfiguration = content
        cell.backgroundColor = .clear

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened.toggle()
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
}
