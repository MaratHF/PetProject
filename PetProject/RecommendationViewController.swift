//
//  RecommendationViewController.swift
//  PetProject
//
//  Created by MAC  on 14.07.2022.
//

import UIKit

class RecommendationViewController: UICollectionViewController {
    
    private let cellNames = [
        "Уведомления перед сном",
        "Общие рекомендации",
        "Полезные источники",
        "Дыхательная гимнастика перед сном"
    ]
    
    private let imageNames = ["reedingGuy", "sleepingGirl", "cat", "balance"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundViewColor()
    }
    
    private func setBackgroundViewColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.0923477529, green: 0.1613951182, blue: 0.3891475176, alpha: 1).cgColor, #colorLiteral(red: 0.1546722437, green: 0.02495219428, blue: 0.2035871579, alpha: 1).cgColor]
//        gradientLayer.locations = [NSNumber(value: 0.0), NSNumber(value: 1.0)]
        
        gradientLayer.frame = collectionView.bounds
        let backgroundView = UIView(frame: collectionView.bounds)
        backgroundView.layer.addSublayer(gradientLayer)
        collectionView.backgroundView = backgroundView
    }

    // MARK: - Table view data source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! RecommendationCollectionViewCell
        
        cell.configure(image: imageNames[indexPath.item], text: cellNames[indexPath.item])
        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
        case 0:
            performSegue(withIdentifier: "showNotificationsRec", sender: nil)
        case 1:
            navigationController?.pushViewController(GeneralRecommendationViewController(), animated: true)
        default:
            break
        }
    }
}
