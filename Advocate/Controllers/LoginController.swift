//
//  LoginController.swift
//  Advocate
//
//  Created by David Doswell on 9/20/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase

private let backButtonTitle = "◀︎"
private let usernameTextFieldPlaceholder = "First Name"
private let passwordTextFieldPlaceholder = "Password"

private let alertTitle = "Error"
private let loginFailAlertTitle = "Error"
private let loginFailAlertMessageTitle = "Incorrect first name or password"
private let loginFailActionTitle = "Okay"
private let messageTitle = "Please enter all fields correctly"
private let actionTitle = "Okay"

class LoginController: UIViewController {
    
    // MARK: - Set up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        hideKeyboardWhenTapped()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: - Properties
    
    var messagesController: MessagesController?
    
    let backButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(backButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(backButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var userImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 75.0
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.becomeFirstResponder()
        textField.textColor = .white
        textField.tintColor = .white
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 20.0)
        textField.borderStyle = .none
        textField.autocapitalizationType = .none
        textField.attributedPlaceholder = NSAttributedString(string: Strings.emailPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.tintColor = .white
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.attributedPlaceholder = NSAttributedString(string: passwordTextFieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let loginButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(Strings.loginButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2.0
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Methods
    
    @objc private func backButtonTap(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        if email.isEmpty || password.isEmpty {
            presentErrorAlert()
        } else {
            DispatchQueue.main.async {
                Auth.auth().signIn(withEmail: email, password: password) { user, error in
                    if let error = error, user == nil {
                        let alert = UIAlertController(title: "Sign-in Error", message: "Check to make sure you've entered your values correctly", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Okay", style: .default) { action in
                            self.emailTextField.becomeFirstResponder()
                            NSLog("Sign-in Error: \(error)")
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            DispatchQueue.main.async {
                self.messagesController?.fetchUserAndSetupNavBarTitle()
            }
        }
    }
    
    private func presentErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill out all fields correctly", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { action in
            self.emailTextField.becomeFirstResponder()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func presentSignUpAlert() {
        let alert = UIAlertController(title: "Error", message: "Please sign up to create a free account", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { action in
            // dismiss alert view
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Constraints
    
    func setUpViews() {
        
        view.backgroundColor = .black
        
        view.addSubview(backButton)
        view.addSubview(userImage)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        let backButtonConstraints = [backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30.0), backButton.leftAnchor.constraint(equalTo: emailTextField.leftAnchor)]
        
        let userImageConstraints = [userImage.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20.0), userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor), userImage.widthAnchor.constraint(equalToConstant: 150.0), userImage.heightAnchor.constraint(equalToConstant: 150.0)]
        
        let emailTextFieldConstraints = [emailTextField.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 30.0), emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor), emailTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50.0), emailTextField.heightAnchor.constraint(equalToConstant: 27.0)]
        
        let passwordTextFieldConstraints = [passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30.0), passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor), passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50.0), passwordTextField.heightAnchor.constraint(equalToConstant: 27.0)]
        
        let signUpButtonConstraints = [loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50.0), loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), loginButton.widthAnchor.constraint(equalToConstant: 300.0), loginButton.heightAnchor.constraint(equalToConstant: 50.0)]
        
        NSLayoutConstraint.activate(backButtonConstraints)
        NSLayoutConstraint.activate(userImageConstraints)
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        NSLayoutConstraint.activate(signUpButtonConstraints)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
