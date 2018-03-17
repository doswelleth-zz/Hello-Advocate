//
//  SignInCell.swift
//  Advocate
//
//  Created by David Oliver Doswell on 3/16/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit

private let firstnameTextFieldPlaceholder = "First Name"
private let passwordTextFieldPlaceholder = "Password"

class SignInCell : UICollectionViewCell {
    
    let firstNameTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.attributedPlaceholder = NSAttributedString(string: firstnameTextFieldPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.attributedPlaceholder = NSAttributedString(string: passwordTextFieldPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let signInButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func setUpViews() {
        
        backgroundColor = .white
        
        addSubview(firstNameTextField)
        addSubview(passwordTextField)
        addSubview(signInButton)
        
        let margin = layoutMarginsGuide
        
        addConstraints([NSLayoutConstraint(item: firstNameTextField, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        addConstraints([NSLayoutConstraint(item: firstNameTextField, attribute: .bottom, relatedBy: .equal, toItem: margin, attribute: .bottom, multiplier: 1, constant: 100)])
        
        addConstraints([NSLayoutConstraint(item: firstNameTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        addConstraints([NSLayoutConstraint(item: firstNameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        
        addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .bottom, relatedBy: .equal, toItem: firstNameTextField, attribute: .bottom, multiplier: 1, constant: 50)])
        
        addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        
        addConstraints([NSLayoutConstraint(item: signInButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        addConstraints([NSLayoutConstraint(item: signInButton, attribute: .bottom, relatedBy: .equal, toItem: passwordTextField, attribute: .bottom, multiplier: 1, constant: 75)])
        
        addConstraints([NSLayoutConstraint(item: signInButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)])
        
        addConstraints([NSLayoutConstraint(item: signInButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
    }
    
}
