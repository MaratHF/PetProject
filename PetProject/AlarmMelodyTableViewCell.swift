//
//  AlarmMelodyTableViewCell.swift
//  PetProject
//
//  Created by MAC  on 06.09.2022.
//

import UIKit

class AlarmMelodyTableViewCell: UITableViewCell {

    let cellID = "AlarmMelodyTableViewCell"
    
    @IBOutlet var label: UILabel!
    @IBOutlet var button: UIButton!
    
    func nib() -> UINib {
        UINib(nibName: cellID, bundle: nil)
    }
    
    func configure(text: String) {
        label.text = text
    }
}
