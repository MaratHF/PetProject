//
//  SplashViewController.swift
//  PetProject
//
//  Created by MAC  on 24.09.2022.
//

import UIKit

class SplashViewController: UIViewController {
    
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        timer = Timer.scheduledTimer(
            timeInterval: 2,
            target: self,
            selector: #selector(nextControllerDefinition),
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc private func nextControllerDefinition() {
        if StorageManager.shared.getUserData().name != "" {
            if StorageManager.shared.getNotificationAuthorizationStatus() == false {
                guard let noticeVC = UIStoryboard(
                    name: "Main",
                    bundle: nil).instantiateViewController(withIdentifier: "noticeViewController") as? NoticeViewController else { return }
                present(noticeVC, animated: true)
            } else {
                guard let mainVC = UIStoryboard(
                    name: "Main",
                    bundle: nil).instantiateViewController(withIdentifier: "mainViewController"
                    ) as? UITabBarController else { return }
                present(mainVC, animated: true)
            }
        } else {
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController")
            present(loginVC, animated: true)
        }
    }

}
