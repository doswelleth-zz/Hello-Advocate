//
//  TabBarController.swift
//  Advocate
//
//  Created by David Doswell on 9/18/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lawyerController = LawyerController()
        let messagesController = MessagesController()
        let settingsController = SettingsController()
        
        let lawyerTab = UINavigationController(rootViewController: lawyerController)
        lawyerTab.tabBarItem.title = "Lawyers"
        lawyerTab.tabBarItem.image = UIImage(named: "Lawyers")
        lawyerTab.navigationBar.prefersLargeTitles = true
        
        let messagesTab = UINavigationController(rootViewController: messagesController)
        messagesTab.tabBarItem.title = "Messages"
        messagesTab.tabBarItem.image = UIImage(named: "Messages")
        messagesTab.navigationBar.prefersLargeTitles = true
        
        let settingsTab = UINavigationController(rootViewController: settingsController)
        settingsTab.tabBarItem.title = "Settings"
        settingsTab.tabBarItem.image = UIImage(named: "Settings")
        settingsTab.navigationBar.prefersLargeTitles = true
        
        viewControllers = [lawyerTab, messagesTab, settingsTab]
    }
}
