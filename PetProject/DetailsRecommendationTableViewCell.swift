//
//  DetailsRecommendationTableViewCell.swift
//  PetProject
//
//  Created by MAC  on 16.07.2022.
//

import UIKit

class DetailsRecommendationTableViewCell: UITableViewCell {
    
    let cellID = "detailRecommendationCell"
    
    @IBOutlet var recommendationSwitch: UISwitch!
    @IBOutlet var recommendationLabel: UILabel!
    
    func configure(with text: String) {
        recommendationLabel.text = text
    }
}
