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
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
        
    // MARK: - Application Set up
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
                
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Database.database().isPersistenceEnabled = true
                
        IAPHelper.shared.getProducts()
        
        Appearance.setUp()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (authorized: Bool, error: Error?) in
            if !authorized {
                guard let error = error as? String else { return }
                NSLog(error)
            }
        }

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
          }
        }
        
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
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Firebase registration token: \(fcmToken)")

      let dataDict:[String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
