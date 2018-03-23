//
//  ProfileController.swift
//  Advocate
//
//  Created by David Oliver Doswell on 3/16/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import CoreData
import StoreKit

private let reuseIdentifier = "reuseIdentifier"
private let logOutButtonTitle = "◀︎"
private let getStartedButtonTitle = "Get Started"
private let learnMoreButtonTitle = "Learn more"
private let settingsButtonTitle = "Settings"
private let fileClaimButtonTitle = "File a claim"

private let alertTitle = "Confirm"
private let messageTitle = "Log out?"
private let yes = "Yes"
private let no = "No"

class ProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let logOutButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(logOutButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logOutButtonTap), for: .touchUpInside)
        return button
    }()
    
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let getStartedButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(getStartedButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(getStartedButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    let learnMoreButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(learnMoreButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(learnMoreButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    let settingsButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(settingsButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    let fileClaimButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(fileClaimButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(fileClaimButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        collectionView?.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        fileClaimButton.isHidden = true
        
        collectionView?.backgroundColor = .white
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let username = (result as AnyObject).value(forKey: "username") as? String {
                        usernameLabel.text = username
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
        self.navigationController?.navigationBar.isHidden = true
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(makeFileClaimButtonVisible), name: Notification.Name(Notif().name), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func logOutButtonTap(sender: UIButton) {
        presentLogOutAlert()
    }
    
    @objc private func getStartedButtonTap(sender: UIButton) {
        let subscribeController = SubscribeController()
        self.navigationController?.pushViewController(subscribeController, animated: true)
    }
    
    @objc func learnMoreButtonTap(sender: UIButton) {
        let destination = LearnMoreController()
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc func settingsButtonTap(sender: UIButton) {
        let destination = SettingsController()
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc func fileClaimButtonTap(sender: UIButton) {
        let destination = FileClaimController()
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc private func makeFileClaimButtonVisible() {
        fileClaimButton.isHidden = false
        print("NEW SUBSCRIBER 🎉")
    }
    
    private func presentLogOutAlert() {
        let alert = UIAlertController(title: alertTitle, message: messageTitle, preferredStyle: .alert)
        let logout = UIAlertAction(title: yes, style: .default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        let forget = UIAlertAction(title: no, style: .default) { (action) in
        }
        alert.addAction(logout)
        alert.addAction(forget)
        present(alert, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func setUpViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(logOutButton)
        view.addSubview(usernameLabel)
        view.addSubview(getStartedButton)
        view.addSubview(learnMoreButton)
        view.addSubview(settingsButton)
        view.addSubview(fileClaimButton)
        
        let margin = view.layoutMarginsGuide
        
        view.addConstraints([NSLayoutConstraint(item: logOutButton, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .left, multiplier: 1, constant: 10)])
        
        view.addConstraints([NSLayoutConstraint(item: logOutButton, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .top, multiplier: 1, constant: 30)])
        
        view.addConstraints([NSLayoutConstraint(item: logOutButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 31)])
        
        view.addConstraints([NSLayoutConstraint(item: logOutButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 31)])
        
        
        view.addConstraints([NSLayoutConstraint(item: usernameLabel, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: usernameLabel, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .top, multiplier: 1, constant: 100)])
        
        view.addConstraints([NSLayoutConstraint(item: usernameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: usernameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        
        
        view.addConstraints([NSLayoutConstraint(item: getStartedButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: getStartedButton, attribute: .bottom, relatedBy: .equal, toItem: usernameLabel, attribute: .bottom, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: getStartedButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)])
        
        view.addConstraints([NSLayoutConstraint(item: getStartedButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        
        view.addConstraints([NSLayoutConstraint(item: learnMoreButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: learnMoreButton, attribute: .bottom, relatedBy: .equal, toItem: getStartedButton, attribute: .bottom, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: learnMoreButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)])
        
        view.addConstraints([NSLayoutConstraint(item: learnMoreButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        
        view.addConstraints([NSLayoutConstraint(item: settingsButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: settingsButton, attribute: .bottom, relatedBy: .equal, toItem: learnMoreButton, attribute: .bottom, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: settingsButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)])
        
        view.addConstraints([NSLayoutConstraint(item: settingsButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        
        view.addConstraints([NSLayoutConstraint(item: fileClaimButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: fileClaimButton, attribute: .bottom, relatedBy: .equal, toItem: settingsButton, attribute: .bottom, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: fileClaimButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)])
        
        view.addConstraints([NSLayoutConstraint(item: fileClaimButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
