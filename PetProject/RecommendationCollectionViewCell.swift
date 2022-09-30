//
//  CollectionViewCell.swift
//  PetProject
//
//  Created by MAC  on 28.09.2022.
//

import UIKit

class RecommendationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var recommendationImage: UIImageView!
    @IBOutlet var recommendationText: UILabel!
    
    func configure(image: String, text: String) {
        recommendationText.text = text
        recommendationImage.image = UIImage(named: image)!
    }
}
