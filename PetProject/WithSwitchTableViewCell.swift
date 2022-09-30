//
//  WithSwitchTableViewCell.swift
//  PetProject
//
//  Created by MAC  on 07.09.2022.
//

import UIKit

class WithSwitchTableViewCell: UITableViewCell {

    let cellID = "WithSwitchTableViewCell"
    
    @IBOutlet var label: UILabel!
    @IBOutlet var `switch`: UISwitch!
    
    func nib() -> UINib {
        UINib(nibName: cellID, bundle: nil)
    }
}
