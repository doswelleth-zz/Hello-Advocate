//
//  Appearance.swift
//  Advocate
//
//  Created by David Doswell on 9/2/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import UIKit

struct Appearance {
    static let customColor = UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)
    
    static let titleViewColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1)
    
    static func setUp() {
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
         UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        UISearchBar.appearance().tintColor = .white
        UISearchBar.appearance().barStyle = .black
        
        UITextField.appearance().tintColor = .white
        UITextField.appearance().textColor = .white
        
        UILabel.appearance().textColor = .white
    }
}
