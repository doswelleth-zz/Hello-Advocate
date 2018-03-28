//
//  FileClaimController.swift
//  Advocate
//
//  Created by David Oliver Doswell on 3/16/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import CloudKit

private let backButtonTitle = "◀︎"
private let namePlaceholder = "First name"
private let emailPlaceholder = "Email"
private let workPlaceHolder = "Employer"
private let locationPlaceHolder = "City and State"
private let describeIncidentLabelTitle = "Be straightforward"
private let characterLimit = 300
private let submitButtonTitle = "Submit"

class FileClaimController: UIViewController, UITextViewDelegate {
   
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

    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.textAlignment = .left
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.tintColor = .black
        textField.font = UIFont.boldSystemFont(ofSize: 25)
        textField.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let workTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.textAlignment = .left
        textField.tintColor = .black
        textField.font = UIFont.boldSystemFont(ofSize: 25)
        textField.attributedPlaceholder = NSAttributedString(string: workPlaceHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
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
        textField.attributedPlaceholder = NSAttributedString(string: locationPlaceHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
 
    let describeIncidentLabel : UILabel = {
        let label = UILabel()
        label.text = describeIncidentLabelTitle
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let characterCounterLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let incidentTextView : UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.textAlignment = .justified
        textView.tintColor = .black
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.isUserInteractionEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
        if incidentTextView.text.count > 100 {
            self.sufficientCharacterCountAlert()
        } else {
            self.insufficientCharacterCountAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incidentTextView.delegate = self
        updateCharacterCount()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        setUpViews()
    }
    
    @objc func keyboardNotification(notification: Notification) {
        if let info = notification.userInfo {
            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue.size
            let keyboardWillShow = notification.name == NSNotification.Name.UIKeyboardWillShow
            if keyboardWillShow {
                self.incidentTextView.contentInset.bottom = keyboardSize.height.distance(to: 50)
            }
        }
    }
    
    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return incidentTextView.text.count + (text.count - range.length) <= characterLimit
    }
    
    internal func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    private func updateCharacterCount() {
        characterCounterLabel.text = "\((300) - self.incidentTextView.text.count)"
    }
    
    private func sufficientCharacterCountAlert() {
        let alert = UIAlertController(title: FileTextStrings().sufficientTitle, message:  FileTextStrings().sufficientMessageTitle, preferredStyle: .alert)
        let yes = UIAlertAction(title: FileTextStrings().sufficientYesTitle, style: .default) { (action) in
            self.saveClaim()
        }
        let edit = UIAlertAction(title: FileTextStrings().sufficientEditTitle, style: .cancel) { (action) in
        }
        alert.addAction(yes)
        alert.addAction(edit)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func insufficientCharacterCountAlert() {
        let otherAlert = UIAlertController(title:  FileTextStrings().insufficientTitle, message:  FileTextStrings().insufficientMessageTitle, preferredStyle: .alert)
        let otherAction = UIAlertAction(title:  FileTextStrings().insufficientActionTitle, style: .default) { (action) in
        }
        otherAlert.addAction(otherAction)
        self.present(otherAlert, animated: true, completion: nil)
    }
    
    private func saveClaim() {
        let alert = UIAlertController(title:  FileTextStrings().savedTitle, message:  FileTextStrings().savedMessageTitle, preferredStyle: .alert)
        let great = UIAlertAction(title:  FileTextStrings().savedAction, style: .default) { (action) in
            let viewControllers = self.navigationController!.viewControllers as [UIViewController]
            for aViewController in viewControllers {
                if aViewController.isKind(of: ProfileController.self) {
                    _ = self.navigationController?.popToViewController(aViewController, animated: true)
                }
            }
            self.saveClaimToCloud()
        }
        alert.addAction(great)
        present(alert, animated: true, completion: nil)
    }
    
    private func saveClaimToCloud() {
        let claim = CKRecord(recordType: "Claim")
        claim.setValue(firstnameTextField.text, forKeyPath: "firstname")
        claim.setValue(emailTextField.text, forKeyPath: "email")
        claim.setValue(workTextField.text, forKey: "work")
        claim.setValue(locationTextField.text, forKey: "location")
        claim.setValue(incidentTextView.text, forKeyPath: "incident")
        
        CloudKit.init().database.save(claim) { (record, error) in
            guard record != nil else { return }
            print("Error: \(error?.localizedDescription as Any)")
        }
    }

    let scrollView = UIScrollView(frame: UIScreen.main.bounds)

    private func setUpViews() {
        
        view.backgroundColor = .white
        
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceVertical = true
        scrollView.isUserInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
        self.view.addSubview(scrollView)

        scrollView.addSubview(backButton)
        scrollView.addSubview(firstnameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(workTextField)
        scrollView.addSubview(locationTextField)
        scrollView.addSubview(describeIncidentLabel)
        scrollView.addSubview(characterCounterLabel)
        scrollView.addSubview(incidentTextView)
        scrollView.addSubview(submitButton)

        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 20)])

        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 30)])

        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 31)])

        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 31)])


        view.addConstraints([NSLayoutConstraint(item: firstnameTextField, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 20)])

        view.addConstraints([NSLayoutConstraint(item: firstnameTextField, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 100)])

        view.addConstraints([NSLayoutConstraint(item: firstnameTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])

        view.addConstraints([NSLayoutConstraint(item: firstnameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])


        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 20)])

        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .bottom, relatedBy: .equal, toItem: firstnameTextField, attribute: .bottom, multiplier: 1, constant: 50)])

        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])

        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        
        
        view.addConstraints([NSLayoutConstraint(item: workTextField, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 20)])
        
        view.addConstraints([NSLayoutConstraint(item: workTextField, attribute: .bottom, relatedBy: .equal, toItem: emailTextField, attribute: .bottom, multiplier: 1, constant: 50)])
        
        view.addConstraints([NSLayoutConstraint(item: workTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: workTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        
        
        view.addConstraints([NSLayoutConstraint(item: locationTextField, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 20)])
        
        view.addConstraints([NSLayoutConstraint(item: locationTextField, attribute: .bottom, relatedBy: .equal, toItem: workTextField, attribute: .bottom, multiplier: 1, constant: 50)])
        
        view.addConstraints([NSLayoutConstraint(item: locationTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: locationTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])


        view.addConstraints([NSLayoutConstraint(item: describeIncidentLabel, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0)])

        view.addConstraints([NSLayoutConstraint(item: describeIncidentLabel, attribute: .top, relatedBy: .equal, toItem: locationTextField, attribute: .top, multiplier: 1, constant: 100)])

        view.addConstraints([NSLayoutConstraint(item: describeIncidentLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])

        view.addConstraints([NSLayoutConstraint(item: describeIncidentLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])


        view.addConstraints([NSLayoutConstraint(item: characterCounterLabel, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0)])

        view.addConstraints([NSLayoutConstraint(item: characterCounterLabel, attribute: .top, relatedBy: .equal, toItem: describeIncidentLabel, attribute: .top, multiplier: 1, constant: 40)])

        view.addConstraints([NSLayoutConstraint(item: characterCounterLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)])

        view.addConstraints([NSLayoutConstraint(item: characterCounterLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)])


        view.addConstraints([NSLayoutConstraint(item: incidentTextView, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0)])

        view.addConstraints([NSLayoutConstraint(item: incidentTextView, attribute: .top, relatedBy: .equal, toItem: characterCounterLabel, attribute: .top, multiplier: 1, constant: 50)])

        view.addConstraints([NSLayoutConstraint(item: incidentTextView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])

        view.addConstraints([NSLayoutConstraint(item: incidentTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)])


        view.addConstraints([NSLayoutConstraint(item: submitButton, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0)])

        view.addConstraints([NSLayoutConstraint(item: submitButton, attribute: .bottom, relatedBy: .equal, toItem: incidentTextView, attribute: .bottom, multiplier: 1, constant: 75)])

        view.addConstraints([NSLayoutConstraint(item: submitButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)])

        view.addConstraints([NSLayoutConstraint(item: submitButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { self.view.endEditing(true) }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
