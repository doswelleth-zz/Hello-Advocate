//
//  SubscribeController.swift
//  Advocate
//
//  Created by David Oliver Doswell on 3/17/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit

private let touchIDAlertTitle = "Error"
private let touchIDActionTitle = "Okay"

class SubscribeController: UIViewController {
    
    // MARK: - Set up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        navigationController?.navigationBar.isHidden = false
        self.title = Strings.navigationTitle
        navigationItem.largeTitleDisplayMode = .never
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
        view.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
        return view
    }()
    
    // MARK: - Properties
    
    let touch = BiometricIDAuth()
    var settings: SettingsController?
    
    let containerView : UITextView = {
        let contView = UITextView()
        contView.isScrollEnabled = true
        contView.isEditable = false
        contView.showsVerticalScrollIndicator = false
        contView.backgroundColor = .clear
        contView.translatesAutoresizingMaskIntoConstraints = false
        return contView
    }()
    
    let subscribeButton : UIButton = {
        let button = UIButton()
        button.setTitle(Strings.subscribeButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 5.0
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(subscribeMonthlyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let subscribeAnnualButton : UIButton = {
        let button = UIButton()
        button.setTitle(Strings.subscribeAnnualButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 5.0
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(subscribeAnnuallyButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    let unlimitedMessagesImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Message")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let unlimitedMessagesLabel : UILabel = {
        let label = UILabel()
        label.text = Strings.unlimitedMessagesLabelTitle
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.backgroundColor = .black
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let freeMatchMakingImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Match")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let freeMatchingMakingLabel : UILabel = {
        let label = UILabel()
        label.text = Strings.freeMatchMakingLabelTitle
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.backgroundColor = .black
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let communitySupportImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Community")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let customerSupportLabel : UILabel = {
        let label = UILabel()
        label.text = Strings.communitySupportLabelTitle
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.backgroundColor = .black
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let autoRenewMessageLabel : UILabel = {
        let label = UILabel()
        label.text = Strings.subscription
        label.font = UIFont.systemFont(ofSize: 15)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .black
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let termsOfServiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Strings.termsOfServiceButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(termsOfServiceButtonTapped(_:)), for: .touchUpInside)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let privacyPolicyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Strings.privacyPolicyButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(privacyPolicyButtonTapped(_:)), for: .touchUpInside)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Methods
    
    @objc private func subscribeMonthlyButtonTapped(sender: UIButton) {
        touch.authenticateUser() { [weak self] message in
            if let message = message {
                let alert = UIAlertController(title: touchIDAlertTitle, message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: touchIDActionTitle, style: .default)
                alert.addAction(action)
                self?.present(alert, animated: true)
            } else {
                guard let self = self else { return }
                
                IAPHelper.shared.purchase(product: .monthlyRenewingSubscription)
               
                NotificationCenter.default.addObserver(self, selector: #selector(self.monthlySubscriptionPurchased(_:)), name: NSNotification.Name(rawValue: Strings.subscriptionPurchased), object: nil)
            }
        }
    }
    
    @objc private func subscribeAnnuallyButtonTapped(sender: UIButton) {
        touch.authenticateUser() { [weak self] message in
        if let message = message {
            let alert = UIAlertController(title: touchIDAlertTitle, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: touchIDActionTitle, style: .default)
            alert.addAction(action)
            self?.present(alert, animated: true)
        } else {
            guard let self = self else { return }
            
            IAPHelper.shared.purchase(product: .annualRenewingSubscription)
                   
            NotificationCenter.default.addObserver(self, selector: #selector(self.annualSubscriptionPurchased(_:)), name: NSNotification.Name(rawValue: Strings.subscriptionPurchased), object: nil)
            }
        }
    }
        
    @objc private func monthlySubscriptionPurchased(_ notification: Notification) {
        settings?.createProfileButton.isHidden = false
        self.navigationController?.popViewController(animated: true)
        NSLog("Monthly Subscription Purchased 🎉")
    }
    
    @objc private func annualSubscriptionPurchased(_ notification: Notification) {
        settings?.createProfileButton.isHidden = false
        self.navigationController?.popViewController(animated: true)
        NSLog("Annual Subscription Purchased 🎉")
    }

    
    @objc private func termsOfServiceButtonTapped(_ sender: UIButton) {
        let destination = TermsViewController()
        navigationController?.modalPresentationStyle = .overCurrentContext
        present(destination, animated: true, completion: nil)
    }
    
    @objc private func privacyPolicyButtonTapped(_ sender: UIButton) {
        let destination = PrivacyController()
        navigationController?.modalPresentationStyle = .overCurrentContext
        present(destination, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Constraints

    private func setUpViews() {
        
        view.backgroundColor = .black
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        scrollView.addSubview(subscribeButton)
        scrollView.addSubview(subscribeAnnualButton)
        scrollView.addSubview(unlimitedMessagesImage)
        scrollView.addSubview(unlimitedMessagesLabel)
        scrollView.addSubview(freeMatchMakingImage)
        scrollView.addSubview(freeMatchingMakingLabel)
        scrollView.addSubview(communitySupportImage)
        scrollView.addSubview(customerSupportLabel)
        scrollView.addSubview(autoRenewMessageLabel)
        scrollView.addSubview(termsOfServiceButton)
        scrollView.addSubview(privacyPolicyButton)
        
        let scrollViewConstraints = [scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor), scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor), scrollView.widthAnchor.constraint(equalToConstant: view.frame.size.width), scrollView.heightAnchor.constraint(equalToConstant: 600.0)]
        
        let subscribeButtonConstraints = [subscribeButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30.0), subscribeButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor), subscribeButton.widthAnchor.constraint(equalToConstant: 300.0), subscribeButton.heightAnchor.constraint(equalToConstant: 50.0)]
        
        let subscribeAnnualButtonConstraints = [subscribeAnnualButton.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 30.0), subscribeAnnualButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor), subscribeAnnualButton.widthAnchor.constraint(equalToConstant: 300.0), subscribeAnnualButton.heightAnchor.constraint(equalToConstant: 50.0)]
        
        let unlimitedMessagesImageConstraints = [unlimitedMessagesImage.topAnchor.constraint(equalTo: subscribeAnnualButton.bottomAnchor, constant: 30.0), unlimitedMessagesImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor), unlimitedMessagesImage.widthAnchor.constraint(equalToConstant: 44.0), unlimitedMessagesImage.heightAnchor.constraint(equalToConstant: 44.0)]
        
        let unlimitedMessagesLabelConstraints = [unlimitedMessagesLabel.topAnchor.constraint(equalTo: unlimitedMessagesImage.bottomAnchor, constant: 30.0), unlimitedMessagesLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor), unlimitedMessagesLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 5.0)]
        
        let freeMatchMakingImageConstraints = [freeMatchMakingImage.topAnchor.constraint(equalTo: unlimitedMessagesLabel.bottomAnchor, constant: 30.0), freeMatchMakingImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor), freeMatchMakingImage.widthAnchor.constraint(equalToConstant: 44.0), freeMatchMakingImage.heightAnchor.constraint(equalToConstant: 44.0)]
        
        let freeMatchMakingLabelConstraints = [freeMatchingMakingLabel.topAnchor.constraint(equalTo: freeMatchMakingImage.bottomAnchor, constant: 30.0), freeMatchingMakingLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor), freeMatchingMakingLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 5.0)]
        
        let customerSupportImageConstraints = [communitySupportImage.topAnchor.constraint(equalTo: freeMatchingMakingLabel.bottomAnchor, constant: 30.0), communitySupportImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor), communitySupportImage.widthAnchor.constraint(equalToConstant: 44.0), communitySupportImage.heightAnchor.constraint(equalToConstant: 44.0)]
        
        let customerSupportLabelConstraints = [customerSupportLabel.topAnchor.constraint(equalTo: communitySupportImage.bottomAnchor, constant: 30.0), customerSupportLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor), customerSupportLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 5.0)]
        
         let autoRenewingLabelConstraints = [autoRenewMessageLabel.topAnchor.constraint(equalTo: customerSupportLabel.bottomAnchor, constant: 30.0), autoRenewMessageLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor), autoRenewMessageLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width), autoRenewMessageLabel.heightAnchor.constraint(equalToConstant: 330.0)]
        
        let termsOfServiceButtonConstraints = [termsOfServiceButton.topAnchor.constraint(equalTo: autoRenewMessageLabel.bottomAnchor, constant: 20.0), termsOfServiceButton.leftAnchor.constraint(equalTo: autoRenewMessageLabel.leftAnchor, constant: 25.0)]
        
        let privacyPolicyButtonConstraints = [privacyPolicyButton.topAnchor.constraint(equalTo: autoRenewMessageLabel.bottomAnchor, constant: 20.0), privacyPolicyButton .rightAnchor.constraint(equalTo: autoRenewMessageLabel.rightAnchor, constant: -25.0)]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(subscribeButtonConstraints)
        NSLayoutConstraint.activate(subscribeAnnualButtonConstraints)
        NSLayoutConstraint.activate(unlimitedMessagesImageConstraints)
        NSLayoutConstraint.activate(unlimitedMessagesLabelConstraints)
        NSLayoutConstraint.activate(freeMatchMakingImageConstraints)
        NSLayoutConstraint.activate(freeMatchMakingLabelConstraints)
        NSLayoutConstraint.activate(customerSupportImageConstraints)
        NSLayoutConstraint.activate(customerSupportLabelConstraints)
        NSLayoutConstraint.activate(autoRenewingLabelConstraints)
        NSLayoutConstraint.activate(termsOfServiceButtonConstraints)
        NSLayoutConstraint.activate(privacyPolicyButtonConstraints)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
