//
//  WelcomeController.swift
//  Advocate
//
//  Created by David Doswell on 9/18/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }

    // MARK: - Properties
    
    let logoImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Logo")
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.logoLabelText
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let logoSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.logoSubtitleText
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let loginButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(Strings.loginButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2.0
        button.backgroundColor = .black
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(Strings.signUpButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2.0
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Methods
    
    @objc private func loginButtonTapped(_ sender: UIButton) {
        let destination = LoginController()
        navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc private func signUpButtonTapped(_ sender: UIButton) {
        let destination = SignUpController()
        navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: - Constraints
    
    func setUpViews() {
        
        view.backgroundColor = .black
        
        view.addSubview(logoImage)
        view.addSubview(logoLabel)
        view.addSubview(logoSubtitleLabel)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        
        let logoImageConstraints = [logoImage.bottomAnchor.constraint(equalTo: logoLabel.topAnchor, constant: -10.0), logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor), logoImage.widthAnchor.constraint(equalToConstant: 150.0), logoImage.heightAnchor.constraint(equalToConstant: 150.0)]
        
        let logoLabelConstraints = [logoLabel.bottomAnchor.constraint(equalTo: logoSubtitleLabel.topAnchor, constant: -30.0), logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        
        let logoSubtitleLabelConstraints = [logoSubtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), logoSubtitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        
        let loginButtonConstraints = [loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), loginButton.topAnchor.constraint(equalTo: logoSubtitleLabel.bottomAnchor, constant: 30.0), loginButton.widthAnchor.constraint(equalToConstant: 200.0), loginButton.heightAnchor.constraint(equalToConstant: 50.0)]
        
        let signUpButtonConstraints = [signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30.0), signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), signUpButton.widthAnchor.constraint(equalToConstant: 200.0), signUpButton.heightAnchor.constraint(equalToConstant: 50.0)]
        
        NSLayoutConstraint.activate(logoImageConstraints)
        NSLayoutConstraint.activate(logoLabelConstraints)
        NSLayoutConstraint.activate(logoSubtitleLabelConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
        NSLayoutConstraint.activate(signUpButtonConstraints)
    }

}
