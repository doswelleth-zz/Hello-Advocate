//
//  AppDelegate.swift
//  Advocate
//
//  Created by David Oliver Doswell on 3/16/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import CoreData
import StoreKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // MARK: - Application Set up
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
                
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
                
        IAPHelper.shared.getProducts()
        
        Appearance.setUp()
        
        let welcomeController = WelcomeController()
                        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.window?.rootViewController = TabBarController()
                self.window?.makeKeyAndVisible()
            } else {
                let navigationController = UINavigationController(rootViewController: welcomeController)
                
                navigationController.navigationBar.isHidden = true
                navigationController.navigationBar.prefersLargeTitles = true
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
            }
        }
        return true
    }
}
