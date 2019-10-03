//
//  SettingsController.swift
//  Advocate
//
//  Created by David Doswell on 9/30/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SafariServices

private let restoreMonthlyActionTitle = "Restore"
private let restoreMonthlyAlertTitle = "Restore Monthly Membership"
private let restoreMonthlyMessageTitle = "Restore your Membership today for $9.99 a month and enjoy access to unlimited file claims and a qualified attorney for free."

private let restoreAnnualButtonTitle = "Restore"
private let restoreAnnualAlertTitle = "Restore Annual Membership"
private let restoreAnnualMessageTitle = "Restore your Membership today for $99.99 a month and enjoy access to unlimited file claims and a qualified attorney for free."
private let restoreAnnualActionTitle = "Restore"

private let dismissActionTitle = "Dismiss"


class SettingsController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        let restoreNotification = NotificationCenter.default
        restoreNotification.addObserver(self, selector: #selector(presentRestoreMonthlyAlert), name: Notification.Name(Strings.name), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Strings.settings
        
        setUpViews()
        fetchUser()
        
        SVProgressHUD.setBackgroundColor(.black)
        SVProgressHUD.setForegroundColor(.white)
        
        createProfileButton.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - Scroll View
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.backgroundColor = .black
        view.alwaysBounceVertical = true
        view.isUserInteractionEnabled = true
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
        return view
    }()
  
    // MARK: - Properties
    
    let createProfileButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(Strings.createAProfileButton, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .black
        button.isUserInteractionEnabled = true
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createAProfileTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 25.0
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let getStartedLabel : UILabel = {
        let label = UILabel()
        label.text = Strings.getStartedLabelTitle
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let getStartedButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(Strings.getStartedButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .black
        button.isUserInteractionEnabled = true
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(getStartedButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let restoreMonthlyLabel : UILabel = {
        let label = UILabel()
        label.text = Strings.restoreMonthlyLabelTitle
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let restoreMonthlyButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(Strings.restoreMonthlyButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .black
        button.isUserInteractionEnabled = true
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(restoreMonthlyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let restoreAnnualLabel : UILabel = {
        let label = UILabel()
        label.text = Strings.restoreAnnualLabelTitle
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let restoreAnnualButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(Strings.restoreAnnualButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .black
        button.isUserInteractionEnabled = true
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(restoreAnnualButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let learnMoreLabel : UILabel = {
        let label = UILabel()
        label.text = Strings.learnMoreLabelTitle
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let learnMoreButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(Strings.learnMoreButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .black
        button.isUserInteractionEnabled = true
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(learnMoreButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let logOutLabel : UILabel = {
        let label = UILabel()
        label.text = Strings.logOutLabelTitle
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let logOutButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(Strings.logOutButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .black
        button.isUserInteractionEnabled = true
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
        usernameLabel.text = user.name
    }
    
    @objc private func createAProfileTapped(sender: UIButton) {
        let destination = NewLawyerController()
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc private func getStartedButtonTapped(sender: UIButton) {
        let destination = SubscribeController()
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc func restoreMonthlyButtonTapped(sender: UIButton) {
        presentRestoreMonthlyAlert()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func restoreAnnualButtonTapped(sender: UIButton) {
        presentRestoreAnnualAlert()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func learnMoreButtonTapped(sender: UIButton) {
        if let url = URL(string: Strings.learn) {
            let configuration = SFSafariViewController.Configuration()
            configuration.barCollapsingEnabled = false
            
            let safariViewController = SFSafariViewController(url: url, configuration: configuration)
            safariViewController.preferredBarTintColor = .black
            safariViewController.preferredControlTintColor = .white
            present(safariViewController, animated: true)
        }
    }
    
    @objc private func presentRestoreMonthlyAlert() {
        let alert = UIAlertController(title: restoreMonthlyAlertTitle, message: restoreMonthlyMessageTitle, preferredStyle: .alert)
        let restore = UIAlertAction(title: restoreMonthlyActionTitle, style: .default) { (action) in
            IAPHelper.shared.restorePurchases()
            self.navigationController?.popViewController(animated: true)
        }
        let dismiss = UIAlertAction(title: dismissActionTitle, style: .default) { (action) in
        }
        alert.addAction(restore)
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func presentRestoreAnnualAlert() {
        let alert = UIAlertController(title: restoreAnnualAlertTitle, message: restoreAnnualMessageTitle, preferredStyle: .alert)
        let restore = UIAlertAction(title: restoreAnnualActionTitle, style: .default) { (action) in
            IAPHelper.shared.restorePurchases()
            self.navigationController?.popViewController(animated: true)
        }
        let dismiss = UIAlertAction(title: dismissActionTitle, style: .default) { (action) in
        }
        alert.addAction(restore)
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func logOutButtonTapped(sender: UIButton) {
        presentLogOutAlert()
    }
    
    private func presentLogOutAlert() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
        }
        let logOut = UIAlertAction(title: "Log out", style: .default) { (logOut) in
            SVProgressHUD.show()
            
            DispatchQueue.main.async {
                // Sign Out User
                do {
                    try Auth.auth().signOut()
                } catch (let error) {
                    NSLog("Auth sign out failed: \(error)")
                }
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                let destination = WelcomeController()
                self.navigationController?.modalPresentationStyle = .overFullScreen
                self.present(destination, animated: true, completion: nil)
            }
        }
        alert.addAction(cancel)
        alert.addAction(logOut)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Constraints
    
    private func setUpViews() {
        
        view.backgroundColor = .black
        view.addSubview(scrollView)
        
        scrollView.addSubview(createProfileButton)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(getStartedLabel)
        scrollView.addSubview(getStartedButton)
        scrollView.addSubview(restoreMonthlyLabel)
        scrollView.addSubview(restoreMonthlyButton)
        scrollView.addSubview(restoreAnnualLabel)
        scrollView.addSubview(restoreAnnualButton)
        scrollView.addSubview(learnMoreLabel)
        scrollView.addSubview(learnMoreButton)
        scrollView.addSubview(logOutLabel)
        scrollView.addSubview(logOutButton)
        
        let scrollViewConstraints = [scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor), scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor), scrollView.widthAnchor.constraint(equalToConstant: view.frame.size.width), scrollView.heightAnchor.constraint(equalToConstant: 600.0)]
        
        let createProfileButtonConstraints = [createProfileButton.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5.0), createProfileButton.leftAnchor.constraint(equalTo: usernameLabel.leftAnchor), createProfileButton.widthAnchor.constraint(equalToConstant: 200.0), createProfileButton.heightAnchor.constraint(equalToConstant: 19.0)]
        
        let profileImageViewConstraints = [profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50.0), profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30.0), profileImageView.widthAnchor.constraint(equalToConstant: 50.0), profileImageView.heightAnchor.constraint(equalToConstant: 50.0)]
            
        let usernameLabelConstraints = [usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor), usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10.0)]
        
        let getStartedLabelConstraints = [getStartedLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30.0), getStartedLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: 10.0)]
            
        let getStartedButtonConstraints = [getStartedButton.topAnchor.constraint(equalTo: getStartedLabel.bottomAnchor), getStartedButton.leftAnchor.constraint(equalTo: getStartedLabel.leftAnchor), getStartedButton.widthAnchor.constraint(equalToConstant: view.frame.size.width), getStartedButton.heightAnchor.constraint(equalToConstant: 50.0)]
        
        let restoreMonthlyLabelConstraints = [restoreMonthlyLabel.topAnchor.constraint(equalTo: getStartedButton.bottomAnchor, constant: 30.0), restoreMonthlyLabel.leftAnchor.constraint(equalTo: getStartedLabel.leftAnchor)]
            
        let restoreMonthlyButtonConstraints = [restoreMonthlyButton.topAnchor.constraint(equalTo: restoreMonthlyLabel.bottomAnchor), restoreMonthlyButton.leftAnchor.constraint(equalTo: restoreMonthlyLabel.leftAnchor), restoreMonthlyButton.widthAnchor.constraint(equalToConstant: view.frame.size.width), restoreMonthlyButton.heightAnchor.constraint(equalToConstant: 50.0)]
    
        let restoreAnnualLabelConstraints = [restoreAnnualLabel.topAnchor.constraint(equalTo: restoreMonthlyButton.bottomAnchor, constant: 30.0), restoreMonthlyLabel.leftAnchor.constraint(equalTo: restoreAnnualLabel.leftAnchor)]
        
        let restoreAnnualButtonConstraints = [restoreAnnualButton.topAnchor.constraint(equalTo: restoreAnnualLabel.bottomAnchor), restoreAnnualButton.leftAnchor.constraint(equalTo: restoreAnnualLabel.leftAnchor), restoreAnnualButton.widthAnchor.constraint(equalToConstant: view.frame.size.width), restoreAnnualButton.heightAnchor.constraint(equalToConstant: 50.0)]
        
        let learnMoreLabelConstraints = [learnMoreLabel.topAnchor.constraint(equalTo: restoreAnnualButton.bottomAnchor, constant: 30.0), learnMoreLabel.leftAnchor.constraint(equalTo: restoreAnnualLabel.leftAnchor)]
            
        let learnMoreButtonConstraints = [learnMoreButton.topAnchor.constraint(equalTo: learnMoreLabel.bottomAnchor), learnMoreButton.leftAnchor.constraint(equalTo: learnMoreLabel.leftAnchor), learnMoreButton.widthAnchor.constraint(equalToConstant: view.frame.size.width), learnMoreButton.heightAnchor.constraint(equalToConstant: 50.0)]
        
        let logOutLabelConstraints = [logOutLabel.topAnchor.constraint(equalTo: learnMoreButton.bottomAnchor, constant: 30.0), logOutLabel.leftAnchor.constraint(equalTo: learnMoreLabel.leftAnchor)]
            
        let logOutButtonConstraints = [logOutButton.topAnchor.constraint(equalTo: logOutLabel.bottomAnchor), logOutButton.leftAnchor.constraint(equalTo: logOutLabel.leftAnchor), logOutButton.widthAnchor.constraint(equalToConstant: view.frame.size.width), logOutButton.heightAnchor.constraint(equalToConstant: 50.0)]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(createProfileButtonConstraints)
        NSLayoutConstraint.activate(profileImageViewConstraints)
        NSLayoutConstraint.activate(usernameLabelConstraints)
        NSLayoutConstraint.activate(getStartedLabelConstraints)
        NSLayoutConstraint.activate(getStartedButtonConstraints)
        NSLayoutConstraint.activate(restoreMonthlyLabelConstraints)
        NSLayoutConstraint.activate(restoreMonthlyButtonConstraints)
        NSLayoutConstraint.activate(restoreAnnualLabelConstraints)
        NSLayoutConstraint.activate(restoreAnnualButtonConstraints)
        NSLayoutConstraint.activate(learnMoreLabelConstraints)
        NSLayoutConstraint.activate(learnMoreButtonConstraints)
        NSLayoutConstraint.activate(logOutLabelConstraints)
        NSLayoutConstraint.activate(logOutButtonConstraints)
    }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
    }
    
}
