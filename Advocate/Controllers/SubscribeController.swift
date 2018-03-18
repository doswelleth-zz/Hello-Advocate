//
//  SubscribeController.swift
//  Advocate
//
//  Created by David Oliver Doswell on 3/17/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import SafariServices

private let backButtonTitle = "◀︎"
private let subscriptionLabelTitle = "Welcome to Membership"
private let subscribeButtonTitle = "Subscribe"
private let privacyButtonTitle = "Privacy Policy"
private let privacyLink = "https://github.com/davidoliverdoswell/Advocate"

class SubscribeController: UIViewController {
    
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
    
    let privacyPolicyButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(privacyButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(privacyButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    let subscriptionLabel : UILabel = {
        let label = UILabel()
        label.text = subscriptionLabelTitle
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subscriptionTextView : UITextView = {
        let textView = UITextView()
        textView.text = SubscriptionText().strings
        textView.textColor = .black
        textView.tintColor = .black
        textView.textAlignment = .justified
        textView.font = UIFont.boldSystemFont(ofSize: 17)
        textView.isScrollEnabled = true
        textView.allowsEditingTextAttributes = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let subscribeButton : UIButton = {
        let button = UIButton()
        button.setTitle(subscribeButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(subscribeButtonTap(sender:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
    }
    
    @objc private func backButtonTap(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func subscribeButtonTap(sender: UIButton) {
        IAPHelper.shared.purchase(product: .autoRenewingSubscription)
    }
    
    @objc private func privacyButtonTap(sender: UIButton) {
        privacyPolicyLink()
    }
    
    func privacyPolicyLink() {
        if let url = URL(string: PrivacyPolicy().string) {
            let configuration = SFSafariViewController.Configuration()
            configuration.barCollapsingEnabled = false
            
            let safariViewController = SFSafariViewController(url: url, configuration: configuration)
            safariViewController.preferredBarTintColor = .white
            safariViewController.preferredControlTintColor = .black
            present(safariViewController, animated: true)
        }
    }
    
    private func setUpViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        view.addSubview(privacyPolicyButton)
        view.addSubview(subscriptionLabel)
        view.addSubview(subscriptionTextView)
        view.addSubview(subscribeButton)
        
        let margin = view.layoutMarginsGuide
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .left, multiplier: 1, constant: 10)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .top, multiplier: 1, constant: 30)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 31)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 31)])
        
        
        view.addConstraints([NSLayoutConstraint(item: privacyPolicyButton, attribute: .right, relatedBy: .equal, toItem: margin, attribute: .right, multiplier: 1, constant: -10)])
        
        view.addConstraints([NSLayoutConstraint(item: privacyPolicyButton, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .top, multiplier: 1, constant: 30)])
        
        view.addConstraints([NSLayoutConstraint(item: privacyPolicyButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)])
        
        view.addConstraints([NSLayoutConstraint(item: privacyPolicyButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 31)])
        
        
        view.addConstraints([NSLayoutConstraint(item: subscriptionLabel, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: subscriptionLabel, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .top, multiplier: 1, constant: 100)])
        
        view.addConstraints([NSLayoutConstraint(item: subscriptionLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.frame.width)])
        
        view.addConstraints([NSLayoutConstraint(item: subscriptionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 27)])
        
        
        view.addConstraints([NSLayoutConstraint(item: subscriptionTextView, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: subscriptionTextView, attribute: .top, relatedBy: .equal, toItem: subscriptionLabel, attribute: .top, multiplier: 1, constant: 50)])
        
        view.addConstraints([NSLayoutConstraint(item: subscriptionTextView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: subscriptionTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 225)])
     
        
        view.addConstraints([NSLayoutConstraint(item: subscribeButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: subscribeButton, attribute: .bottom, relatedBy: .equal, toItem: subscriptionTextView, attribute: .bottom, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: subscribeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)])
        
        view.addConstraints([NSLayoutConstraint(item: subscribeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
