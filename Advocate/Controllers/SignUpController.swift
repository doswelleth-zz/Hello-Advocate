//
//  SignUpController.swift
//  Advocate
//
//  Created by David Doswell on 9/20/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import UIKit
import Photos
import Firebase

private let alertTitle = "Error"
private let loginFailAlertTitle = "Error"
private let loginFailAlertMessageTitle = "Incorrect first name or password"
private let loginFailActionTitle = "Okay"
private let messageTitle = "Please enter all fields correctly"
private let actionTitle = "Okay"

class SignUpController: UIViewController {
    
    // MARK: - Set up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        hideKeyboardWhenTapped()
        
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else { return }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: - Properties
    
    var messagesController: MessagesController?

    let storage = Storage.storage()
    
    let backButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(Strings.backButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(backButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Preview")
        imageView.layer.cornerRadius = 75.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let usernameTextField : UITextField = {
        let textField = UITextField()
        textField.becomeFirstResponder()
        textField.textColor = .white
        textField.tintColor = .white
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.attributedPlaceholder = NSAttributedString(string: Strings.usernameTextFieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
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
        textField.attributedPlaceholder = NSAttributedString(string: Strings.passwordTextFieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
    
    @objc private func backButtonTap(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Methods
    
    @objc private func profileImageTapped(_ gesture: UITapGestureRecognizer) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return NSLog("Photo library unavailable")
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func signUpButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = usernameTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.user.uid else {
                return
            }
            
            //successfully authenticated user
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, err) in
                        if let err = err {
                            print(err)
                            return
                        }
                        
                        guard let url = url else { return }
                        let values = ["name": name, "email": email, "profileImageUrl": url.absoluteString]
                        
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    })
                    
                })
            }
        })
    }
    
    private func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            let user = User(dictionary: values)
            self.messagesController?.setupNavBarWithUser(user)
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    // MARK: - Create User Profile on Firebase
    
//    @objc private func signUpButtonTapped(_ sender: UIButton) {
//        guard let image = userImage.image else { return }
//        guard let username = usernameTextField.text else { return }
//        guard let email = emailTextField.text else { return }
//        guard let password = passwordTextField.text else { return }
//
//        if username.isEmpty || email.isEmpty || password.isEmpty {
//            presentErrorAlert()
//        } else {
//            Auth.auth().createUser(withEmail: email, password: password) { user, error in
//                if error == nil {
//                    DispatchQueue.main.async {
//                        Auth.auth().signIn(withEmail: email, password: password)
//                        self.uploadProfileImage(image) { url in
//
//                            guard let url = url else { return }
//
//                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//                            changeRequest?.displayName = username
//                            changeRequest?.photoURL = url
//
//                            changeRequest?.commitChanges(completion: { (error) in
//                                if let error = error {
//                                    NSLog("Error commiting user name change: \(error)")
//                                }
//                                self.createProfile(username: username, photoURL: url) { success in
//                                    if success {
//                                    } else {
//                                        NSLog("Error Uploading User Profile: \(String(describing: error))")
//                                    }
//                                }
//                            })
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    // MARK: - Upload User Profile
//
//    private func uploadProfileImage(_ image: UIImage, completion: @escaping ((_ url: URL?) ->())) {
//
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let storageRef = storage.reference().child("users/\(uid)")
//
//        guard let imageData = image.pngData() else { return }
//
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/png"
//
//        storageRef.putData(imageData, metadata: metaData) { (metadata, error) in
//            if error == nil {
//                storageRef.downloadURL(completion: { (url, error) in
//                    if error == nil {
//                        completion(url)
//                    } else {
//                        NSLog("Error downloading URL: \(String(describing: error))")
//                        completion(nil)
//                        return
//                    }
//                })
//            } else {
//                NSLog("Error uploading data to Firebase: \(String(describing: error))")
//                completion(nil)
//                return
//            }
//        }
//    }
//
//    // MARK: - Create User Profile
//
//    private func createProfile(username: String, photoURL: URL, completion: @escaping ((_ success: Bool) ->())) {
//
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let ref = Database.database().reference().child("user/profile/\(uid)")
//
//        let userObject = ["username": username, "photoURL": photoURL.absoluteString] as [String:Any]
//        ref.setValue(userObject) { error, ref in
//            if let error = error {
//                NSLog("User Profile could not be created: \(error)")
//            }
//            completion(error == nil)
//        }
//    }
    
    private func presentErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Please select an original image and fill out all fields correctly", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (action) in
            // dismiss alert view
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func presentEmptyFieldsAlert() {
        let alert = UIAlertController(title: alertTitle, message: messageTitle, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Constraints
    
    func setUpViews() {
        
        view.backgroundColor = .black
        
        view.addSubview(backButton)
        view.addSubview(profileImageView)
        view.addSubview(usernameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        
        let backButtonConstraints = [backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30.0), backButton.leftAnchor.constraint(equalTo: usernameTextField.leftAnchor)]
        
        let profileImageConstraints = [profileImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20.0), profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor), profileImageView.widthAnchor.constraint(equalToConstant: 150.0), profileImageView.heightAnchor.constraint(equalToConstant: 150.0)]
        
        let usernameTextFieldConstraints = [usernameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30.0), usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor), usernameTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50.0), usernameTextField.heightAnchor.constraint(equalToConstant: 27.0)]
        
        let emailTextFieldConstraints = [emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 30.0), emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor), emailTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50.0), emailTextField.heightAnchor.constraint(equalToConstant: 27.0)]
        
        let passwordTextFieldConstraints = [passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30.0), passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor), passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50.0), passwordTextField.heightAnchor.constraint(equalToConstant: 27.0)]
        
        let signUpButtonConstraints = [signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50.0), signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), signUpButton.widthAnchor.constraint(equalToConstant: 300.0), signUpButton.heightAnchor.constraint(equalToConstant: 50.0)]
        
        NSLayoutConstraint.activate(backButtonConstraints)
        NSLayoutConstraint.activate(profileImageConstraints)
        NSLayoutConstraint.activate(usernameTextFieldConstraints)
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        NSLayoutConstraint.activate(signUpButtonConstraints)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
