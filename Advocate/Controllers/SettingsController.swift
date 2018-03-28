//
//  SettingsController.swift
//  Advocate
//
//  Created by David Oliver Doswell on 3/16/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

private let backButtonTitle = "◀︎"
private let usernameTextFieldPlaceholder = "username"
private let saveButtonTitle = "Save"
private let privacyButtonTitle = "Privacy"
private let restoreButtonTitle = "Restore"

private let restoreAlertTitle = "Restore Membership"
private let restoreMessageTitle = "Restore your Membership today for $4.99 a month and enjoy access to unlimited file claims and a qualified attorney for free."
private let restoreActionTitle = "Restore"
private let dismissActionTitle = "Dismiss"

class SettingsController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let backButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(backButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    let usernameTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.tintColor = .black
        textField.textAlignment = .center
        textField.font = UIFont.boldSystemFont(ofSize: 25)
        textField.attributedPlaceholder = NSAttributedString(string: usernameTextFieldPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let saveButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(saveButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    let privacyButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(privacyButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(privacyButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    let restoreButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(restoreButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(restoreButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    @objc func backButtonTap(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonTap(sender: UIButton) {
        saveUserName()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func privacyButtonTap(sender: UIButton) {
            privacyButtonTap()
    }
    
    @objc func restoreButtonTap(sender: UIButton) {
        presentRestoreAlert()
        self.navigationController?.popViewController(animated: true)
    }
    
    func privacyButtonTap() {
        if let url = URL(string: PrivacyPolicy().string) {
            let configuration = SFSafariViewController.Configuration()
            configuration.barCollapsingEnabled = false
            
            let safariViewController = SFSafariViewController(url: url, configuration: configuration)
            safariViewController.preferredBarTintColor = .white
            safariViewController.preferredControlTintColor = .black
            present(safariViewController, animated: true)
        }
    }
    
    func saveUserName() {
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(usernameTextField.text!, forKey: "username")
        
        do {
            try context.save()
        } catch {
            print("Failed saving name")
        }
    }
    
    @objc private func presentRestoreAlert() {
        let alert = UIAlertController(title: restoreAlertTitle, message: restoreMessageTitle, preferredStyle: .alert)
        let restore = UIAlertAction(title: restoreActionTitle, style: .default) { (action) in
            IAPHelper.shared.restorePurchases()
            self.navigationController?.popViewController(animated: true)
        }
        let dismiss = UIAlertAction(title: dismissActionTitle, style: .default) { (action) in
        }
        alert.addAction(restore)
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let username = (result as AnyObject).value(forKey: "username") as? String {
                        usernameTextField.text = username
                    }
                }
            }
        } catch {
            let error = NSError()
            print(error.localizedDescription)
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(presentRestoreAlert), name: Notification.Name(Notif().name), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setUpViews() {
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        view.addSubview(usernameTextField)
        view.addSubview(saveButton)
        view.addSubview(privacyButton)
        view.addSubview(restoreButton)
        
        let margin = view.layoutMarginsGuide
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .left, multiplier: 1, constant: 10)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .top, multiplier: 1, constant: 30)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        
        view.addConstraints([NSLayoutConstraint(item: usernameTextField, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: usernameTextField, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .top, multiplier: 1, constant: 100)])
        
        view.addConstraints([NSLayoutConstraint(item: usernameTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: usernameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        
        
        view.addConstraints([NSLayoutConstraint(item: saveButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: saveButton, attribute: .bottom, relatedBy: .equal, toItem: usernameTextField, attribute: .bottom, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: saveButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)])
        
        view.addConstraints([NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        
        view.addConstraints([NSLayoutConstraint(item: privacyButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: privacyButton, attribute: .bottom, relatedBy: .equal, toItem: saveButton, attribute: .bottom, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: privacyButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)])
        
        view.addConstraints([NSLayoutConstraint(item: privacyButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        
        view.addConstraints([NSLayoutConstraint(item: restoreButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: restoreButton, attribute: .bottom, relatedBy: .equal, toItem: privacyButton, attribute: .bottom, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: restoreButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)])
        
        view.addConstraints([NSLayoutConstraint(item: restoreButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
