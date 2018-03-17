//
//  SignInController.swift
//  Advocate
//
//  Created by David Oliver Doswell on 3/16/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import CoreData

struct KeychainConfiguration {
    static let serviceName = "Advocate"
    static let accessGroup: String? = nil
}

private let backButtonTitle = "◀︎"
private let firstnameTextFieldPlaceholder = "First Name"
private let passwordTextFieldPlaceholder = "Password"

private let alertTitle = "Error"
private let loginFailAlertTitle = "Error"
private let loginFailAlertMessageTitle = "Incorrect first name or password"
private let loginFailActionTitle = "Okay"
private let messageTitle = "Please enter all fields correctly"
private let actionTitle = "Okay"

class SignInController: UIViewController {
    
    var context: NSManagedObjectContext?
    
    var passwordItems: [KeychainPasswordItem] = []
    let createLoginButtonTag = 0
    let signInButtonTag = 1
    
    let backButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(backButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(backButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    let firstNameTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.tintColor = .black
        textField.textAlignment = .left
        textField.font = UIFont.boldSystemFont(ofSize: 25)
        textField.attributedPlaceholder = NSAttributedString(string: firstnameTextFieldPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.tintColor = .black
        textField.textAlignment = .left
        textField.font = UIFont.boldSystemFont(ofSize: 25)
        textField.attributedPlaceholder = NSAttributedString(string: passwordTextFieldPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let signInButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func backButtonTap(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
        
        if hasLogin {
            signInButton.setTitle("Sign In", for: .normal)
            signInButton.tag = signInButtonTag
        } else {
            signInButton.setTitle("Create", for: .normal)
            signInButton.tag = createLoginButtonTag
        }
        
        if let firstName = UserDefaults.standard.value(forKey: "firstName") as? String {
            firstNameTextField.text = firstName
        }
        
        signInButton.addTarget(self, action: #selector(signInButtonTap(sender:)), for: .touchUpInside)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func signInButtonTap(sender: UIButton) {
        guard let newAccountName =  firstNameTextField.text,
            let newPassword = passwordTextField.text, !newAccountName.isEmpty,
            !newPassword.isEmpty else {
                showLoginFailedAlert()
                return
        }
        firstNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if sender.tag == createLoginButtonTag {
            let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
            
            if !hasLoginKey && (firstNameTextField.hasText) {
                UserDefaults.standard.setValue(firstNameTextField.text, forKey: "username")
            }
            do {
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                        account: newAccountName,
                                                        accessGroup: KeychainConfiguration.accessGroup)
                try passwordItem.savePassword(newPassword)
            } catch let error {
                print("Error saving password:\(error.localizedDescription)")
            }
            
            UserDefaults.standard.set(true, forKey: "hasLoginKey")
            signInButton.tag = signInButtonTag
            presentProfileController()
        } else if sender.tag == signInButtonTag {
            if checkLogin(username: newAccountName, password: newPassword) {
                presentProfileController()
            } else {
                showLoginFailedAlert()
            }
        }
        saveUserCredentials()
    }
    
    private func checkLogin(username: String, password: String) -> Bool {
        guard username == UserDefaults.standard.value(forKey: "username") as? String else {
            return false
        }
        
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
        } catch let error {
            print("Error reading password from keychain\(error.localizedDescription)")
        }
        return true
    }
    
    private func showLoginFailedAlert() {
        let alertView = UIAlertController(title: loginFailAlertTitle, message: loginFailAlertMessageTitle, preferredStyle:. alert)
        let okAction = UIAlertAction(title: loginFailActionTitle, style: .default)
        alertView.addAction(okAction)
        present(alertView, animated: true)
    }
    
    private func presentProfileController() {
        let layout = UICollectionViewFlowLayout()
        let destination = ProfileController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    private func presentEmptyFieldsAlert() {
        let alert = UIAlertController(title: alertTitle, message: messageTitle, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func saveUserCredentials() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(firstNameTextField.text!, forKey: "username")
        newUser.setValue(passwordTextField.text!, forKey: "password")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setUpViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        view.addSubview(firstNameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        
        let margin = view.layoutMarginsGuide
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .left, multiplier: 1, constant: 10)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .top, multiplier: 1, constant: 30)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 31)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 31)])
        
        
        view.addConstraints([NSLayoutConstraint(item: firstNameTextField, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .left, multiplier: 1, constant: 10)])
        
        view.addConstraints([NSLayoutConstraint(item: firstNameTextField, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .top, multiplier: 1, constant: 100)])
        
        view.addConstraints([NSLayoutConstraint(item: firstNameTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: firstNameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        
        view.addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .left, multiplier: 1, constant: 10)])
        
        view.addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .bottom, relatedBy: .equal, toItem: firstNameTextField, attribute: .bottom, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        
        view.addConstraints([NSLayoutConstraint(item: signInButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: signInButton, attribute: .bottom, relatedBy: .equal, toItem: passwordTextField, attribute: .bottom, multiplier: 1, constant: 100)])
        
        view.addConstraints([NSLayoutConstraint(item: signInButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)])
        
        view.addConstraints([NSLayoutConstraint(item: signInButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
