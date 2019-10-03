//
//  NewLawyerController.swift
//  Advocate
//
//  Created by David Doswell on 9/20/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

private let alertTitle = "Error"
private let loginFailAlertTitle = "Error"
private let loginFailAlertMessageTitle = "Incorrect first name or password"
private let loginFailActionTitle = "Okay"
private let messageTitle = "Please enter all fields correctly"
private let actionTitle = "Okay"

private let formColor = UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1)


class NewLawyerController: UIViewController, UITextViewDelegate {
    
    // MARK: - Set up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        fetchUser()
        
        hideKeyboardWhenTapped()
        
        self.title = Strings.newLawyerNavigationBarTitle
        navigationItem.largeTitleDisplayMode = .never
        
        biographyTextView.delegate = self
        biographyTextView.text = Strings.personalBioTextViewPlaceholder
        biographyTextView.textColor = UIColor.lightGray
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        SVProgressHUD.setBackgroundColor(.black)
        SVProgressHUD.setForegroundColor(.white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: - Properties
    
    let storage = Storage.storage()
    
    var lawyer: Lawyer?
    let lawyerRef = Database.database().reference().child("lawyers").childByAutoId()
    
    let welcomeToMembershipLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.welcomeToMembershipLabelTitle
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight(rawValue: 1.0))
        label.sizeToFit()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Preview")
        image.layer.cornerRadius = 25.0
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped)))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let formContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        view.backgroundColor = formColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.tintColor = .white
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.attributedPlaceholder = NSAttributedString(string: Strings._usernameTextFieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.sizeToFit()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let practiceTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.tintColor = .white
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.attributedPlaceholder = NSAttributedString(string: Strings.practiceTextFieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.sizeToFit()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let lawSchoolTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.tintColor = .white
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.attributedPlaceholder = NSAttributedString(string: Strings.lawSchoolTextFieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.sizeToFit()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let locationTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.tintColor = .white
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.attributedPlaceholder = NSAttributedString(string: Strings.locationTextFieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.sizeToFit()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let biographyTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.textColor = .white
        textView.tintColor = .white
        textView.layer.cornerRadius = 10.0
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = formColor
        textView.sizeToFit()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Strings.createButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2.0
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                self.setupProfileWithUser(user)
            }
        }, withCancel: nil)
    }
    
    func setupProfileWithUser(_ user: User) {
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCache(with:
                profileImageUrl)
        }
        usernameTextField.text = user.name
    }
    
    @objc private func backButtonTap(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func profileImageViewTapped(_ gesture: UITapGestureRecognizer) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return NSLog("Photo library unavailable")
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func createButtonTapped(_ sender: UIButton) {
        if biographyTextView.text.count > 25 {
            self.presentSufficientCharacterCount()
        } else {
            self.presentInsufficientCharacterCount()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 4.0
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: - Editor Placeholder
    
    func textViewDidBeginEditing(_ personalBioTextView: UITextView) {
        if personalBioTextView.textColor == UIColor.lightGray {
            personalBioTextView.text = ""
            personalBioTextView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ personalBioTextView: UITextView) {
        if personalBioTextView.text.isEmpty {
            personalBioTextView.text = Strings.personalBioTextViewPlaceholder
            personalBioTextView.textColor = UIColor.lightGray
        }
    }
    
    private func presentSufficientCharacterCount() {
        let alert = UIAlertController(title: "Double Check", message: "Create your profile, now?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            self.createNewLawyer()
        }
        let edit = UIAlertAction(title: "Edit", style: .cancel) { (action) in
        }
        alert.addAction(yes)
        alert.addAction(edit)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func presentInsufficientCharacterCount() {
        let otherAlert = UIAlertController(title: "Error", message: "Enter a minimum of 25 characters", preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "Okay", style: .default) { (action) in
        }
        otherAlert.addAction(otherAction)
        self.present(otherAlert, animated: true, completion: nil)
    }
    
    private func createNewLawyer() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:
                AnyObject] {
                
                let user = User(dictionary: dictionary)
                
                guard
                    let practice = self.practiceTextField.text,
                    let lawSchool = self.lawSchoolTextField.text,
                    let location = self.locationTextField.text,
                    let biography = self.biographyTextView.text else { return }
                
                let newLawyer = [
                    "user": [
                        "id": user.id,
                        "name": user.name,
                        "email": user.email,
                        "profileImageUrl": user.profileImageUrl,
                    ],
                    "practice": practice,
                    "lawSchool": lawSchool,
                    "location": location,
                    "biography": biography,
                    "timestamp": [".sv":"timestamp"]
                    ] as [String:Any]
                
                if practice.isEmpty || location.isEmpty || biography.isEmpty {
                    self.presentErrorAlert()
                } else {
                    self.lawyerRef.setValue(newLawyer) { error, ref in
                        if error == nil {
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                            }
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            NSLog("Error Creating New Lawyer: \(String(describing: error))")
                        }
                    }
                }
            }
        })
    }
    
    @objc private func presentProfileComingSoon(_ gesture: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Welcome", message: "We are working hard to successfully implement user profiles. Stay tuned.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func presentErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill out all fields correctly", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (action) in
            // dismiss alert controller
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func setUpViews() {
        view.backgroundColor = .black
        
        view.addSubview(welcomeToMembershipLabel)
        view.addSubview(profileImageView)
        view.addSubview(formContainerView)
        view.addSubview(usernameTextField)
        view.addSubview(lawSchoolTextField)
        view.addSubview(locationTextField)
        view.addSubview(practiceTextField)
        view.addSubview(biographyTextView)
        view.addSubview(createButton)
        
        let welcomeToMembershipLabelConstraints = [welcomeToMembershipLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor), welcomeToMembershipLabel.rightAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: -10.0)]
        
        let profileImageViewConstraints = [profileImageView.bottomAnchor.constraint(equalTo: formContainerView.topAnchor, constant: -10.0), profileImageView.rightAnchor.constraint(equalTo: formContainerView.rightAnchor, constant: -5.0), profileImageView.widthAnchor.constraint(equalToConstant: 50.0), profileImageView.heightAnchor.constraint(equalToConstant: 50.0)]
        
        let formContainerViewConstraints = [formContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor), formContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor), formContainerView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50.0), formContainerView.heightAnchor.constraint(equalToConstant: 400.0)]
        
        let usernameTextFieldConstraints = [usernameTextField.topAnchor.constraint(equalTo: formContainerView.topAnchor, constant: 20.0), usernameTextField.leftAnchor.constraint(equalTo: formContainerView.leftAnchor, constant: 20.0)]
        
        let practiceTextFieldConstraints = [practiceTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20.0), practiceTextField.leftAnchor.constraint(equalTo: formContainerView.leftAnchor, constant: 20.0), practiceTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 120.0)]
        
        let lawSchoolTextFieldConstraints = [lawSchoolTextField.topAnchor.constraint(equalTo: practiceTextField.bottomAnchor, constant: 20.0), lawSchoolTextField.leftAnchor.constraint(equalTo: formContainerView.leftAnchor, constant: 20.0)]
        
        let locationTextFieldConstraints = [locationTextField.topAnchor.constraint(equalTo: lawSchoolTextField.bottomAnchor, constant: 20.0), locationTextField.leftAnchor.constraint(equalTo: formContainerView.leftAnchor, constant: 20.0)]
        
        let biographyTextViewConstraints = [biographyTextView.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 20.0), biographyTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor), biographyTextView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 80.0), biographyTextView.heightAnchor.constraint(equalToConstant: 200.0)]
        
        let createButtonConstraints = [createButton.topAnchor.constraint(equalTo: formContainerView.bottomAnchor, constant: 10.0), createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), createButton.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50.0), createButton.heightAnchor.constraint(equalToConstant: 50.0)]
        
        NSLayoutConstraint.activate(welcomeToMembershipLabelConstraints)
        NSLayoutConstraint.activate(profileImageViewConstraints)
        NSLayoutConstraint.activate(formContainerViewConstraints)
        NSLayoutConstraint.activate(usernameTextFieldConstraints)
        NSLayoutConstraint.activate(lawSchoolTextFieldConstraints)
        NSLayoutConstraint.activate(locationTextFieldConstraints)
        NSLayoutConstraint.activate(practiceTextFieldConstraints)
        NSLayoutConstraint.activate(biographyTextViewConstraints)
        NSLayoutConstraint.activate(createButtonConstraints)
    }
    
}

extension NewLawyerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            self.profileImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.profileImageView.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
