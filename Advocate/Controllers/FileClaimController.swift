//
//  FileClaimController.swift
//  Advocate
//
//  Created by David Oliver Doswell on 3/16/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit

private let backButtonTitle = "◀︎"
private let claimBeginTitle = "***CLAIM FILED BEGIN***"
private let namePlaceholder = "First name"
private let datePlaceholder = "Today's Date"
private let emailPlaceholder = "Email"
private let placeOfWorkPlaceholder = "Place of Work"
private let locationPlaceholder = "City and State"
private let submitButtonTitle = "Submit"

private let alertTitle = "Confirm"
private let messageTitle = "Please review your application"
private let reviewTitle = "Review"
private let continueTitle = "Continue"

class FileClaimController: UIViewController {
    
    let backButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(backButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        return button
    }()
    
    let firstnameTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.textAlignment = .left
        textField.tintColor = .black
        textField.font = UIFont.boldSystemFont(ofSize: 25)
        textField.attributedPlaceholder = NSAttributedString(string: namePlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let dateTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.textAlignment = .left
        textField.tintColor = .black
        textField.font = UIFont.boldSystemFont(ofSize: 25)
        textField.attributedPlaceholder = NSAttributedString(string: datePlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.textAlignment = .left
        textField.tintColor = .black
        textField.font = UIFont.boldSystemFont(ofSize: 25)
        textField.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let placeOfWorkTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.textAlignment = .left
        textField.tintColor = .black
        textField.font = UIFont.boldSystemFont(ofSize: 25)
        textField.attributedPlaceholder = NSAttributedString(string: placeOfWorkPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let locationTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.textAlignment = .left
        textField.tintColor = .black
        textField.font = UIFont.boldSystemFont(ofSize: 25)
        textField.attributedPlaceholder = NSAttributedString(string: locationPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let submitButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(submitButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    @objc private func backButtonTap(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func submitButton(sender: UIButton) {
        presentFileTextAlert()
        printClaimApplication()
    }
    
    private func presentFileTextAlert() {
        let alert = UIAlertController(title: alertTitle, message: messageTitle, preferredStyle: .alert)
        let review = UIAlertAction(title: reviewTitle, style: .default) { (action) in
        }
        let next = UIAlertAction(title: continueTitle, style: .default) { (action) in
            self.presentFileClaimTextController()
        }
        alert.addAction(review)
        alert.addAction(next)
        present(alert, animated: true, completion: nil)
    }
    
    private func presentFileClaimTextController() {
        let destination = FileClaimTextController()
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    private func printClaimApplication() {
        print(claimBeginTitle)
        print("FIRST NAME: \(firstnameTextField.text!)")
        print("TODAY'S DATE: \(dateTextField.text!)")
        print("EMAIL: \(emailTextField.text!)")
        print("PLACE OF WORK: \(placeOfWorkTextField.text!)")
        print("CITY AND STATE: \(locationTextField.text!)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setUpViews() {
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        view.addSubview(firstnameTextField)
        view.addSubview(dateTextField)
        view.addSubview(emailTextField)
        view.addSubview(placeOfWorkTextField)
        view.addSubview(locationTextField)
        view.addSubview(submitButton)
        
        let margin = view.layoutMarginsGuide
        
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .left, multiplier: 1, constant: 10)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .top, multiplier: 1, constant: 30)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 31)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 31)])
        
        
        view.addConstraints([NSLayoutConstraint(item: firstnameTextField, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .left, multiplier: 1, constant: 10)])
        
        view.addConstraints([NSLayoutConstraint(item: firstnameTextField, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .top, multiplier: 1, constant: 100)])
        
        view.addConstraints([NSLayoutConstraint(item: firstnameTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: firstnameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        
        
        view.addConstraints([NSLayoutConstraint(item: dateTextField, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .left, multiplier: 1, constant: 10)])
        
        view.addConstraints([NSLayoutConstraint(item: dateTextField, attribute: .bottom, relatedBy: .equal, toItem: firstnameTextField, attribute: .bottom, multiplier: 1, constant: 50)])
        
        view.addConstraints([NSLayoutConstraint(item: dateTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: dateTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        
        
        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .left, multiplier: 1, constant: 10)])
        
        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .bottom, relatedBy: .equal, toItem: dateTextField, attribute: .bottom, multiplier: 1, constant: 50)])
        
        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        
        
        view.addConstraints([NSLayoutConstraint(item: placeOfWorkTextField, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .left, multiplier: 1, constant: 10)])
        
        view.addConstraints([NSLayoutConstraint(item: placeOfWorkTextField, attribute: .bottom, relatedBy: .equal, toItem: emailTextField, attribute: .bottom, multiplier: 1, constant: 50)])
        
        view.addConstraints([NSLayoutConstraint(item: placeOfWorkTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: placeOfWorkTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        
        
        view.addConstraints([NSLayoutConstraint(item: locationTextField, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .left, multiplier: 1, constant: 10)])
        
        view.addConstraints([NSLayoutConstraint(item: locationTextField, attribute: .bottom, relatedBy: .equal, toItem: placeOfWorkTextField, attribute: .bottom, multiplier: 1, constant: 50)])
        
        view.addConstraints([NSLayoutConstraint(item: locationTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: locationTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        
        
        view.addConstraints([NSLayoutConstraint(item: submitButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: submitButton, attribute: .bottom, relatedBy: .equal, toItem: locationTextField, attribute: .bottom, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: submitButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)])
        
        view.addConstraints([NSLayoutConstraint(item: submitButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
