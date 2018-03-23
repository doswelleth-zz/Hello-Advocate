//
//  SubscribeController.swift
//  Advocate
//
//  Created by David Oliver Doswell on 3/17/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import SafariServices

private let navigationTitle = "Membership"
private let navigationItemTitle = "◀︎"
private let subscribeButtonTitle = "Subscribe $4.99/mo."
private let termsOfServiceTitle = "Terms of Service"
private let privacyButtonTitle = "Privacy Policy"

class SubscribeController: UIViewController {
    
    let containerView : UITextView = {
        let contView = UITextView()
        contView.isScrollEnabled = true
        contView.showsVerticalScrollIndicator = false
        contView.backgroundColor = .clear
        contView.translatesAutoresizingMaskIntoConstraints = false
        return contView
    }()
    
    let subscribeButton : UIButton = {
        let button = UIButton()
        button.setTitle(subscribeButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 10
        button.backgroundColor = .black
        button.isUserInteractionEnabled = true
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(subscribeButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    let unlimitedFileClaimImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Claim")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let unlimitedFileClaimLabel : UILabel = {
        let label = UILabel()
        label.text = "File unlimited claim applications to Advocate"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let freeLegalServicesImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Legal")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let freeLegalServicesLabel : UILabel = {
        let label = UILabel()
        label.text = "Free legal services for all accepted filed claims"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let communityRatingsImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Community")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let communityRatingsLabel : UILabel = {
        let label = UILabel()
        label.text = "Join a financially-supported crowdsourced community"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let autoRenewMessageLabel : UILabel = {
        let label = UILabel()
        label.text = """
        
        Payment will be charged to the user's iTunes account at confirmation of purchase. Subscription to Membership automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period. Auto-renewal may be turned off by going to the user's Account Settings after purchase. No cancellation of the current subscription is allowed during the active subscription period. Any unused portion of a free trial period, if offered, will be forfeited when a user purchases a subscription to that publication, where applicable.

"""
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let termsOfService : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(termsOfServiceTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(termsOfServiceButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    let privacyButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(privacyButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(privacyButtonTap(sender:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.title = navigationTitle
        
        let left = UIButton(type: .custom)
        
        left.setTitle(navigationItemTitle, for: .normal)
        left.setTitleColor(.black, for: .normal)
        left.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        left.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        left.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        left.layer.masksToBounds = true
        left.contentMode = .scaleAspectFill
        left.addTarget(self, action: #selector(leftBarButtonTap(sender:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: left)
        
        navigationController?.hidesBarsOnTap = false
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc func leftBarButtonTap(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func subscribeButtonTap(sender: UIButton) {
         IAPHelper.shared.purchase(product: .autoRenewingSubscription)
    }
    
    @objc private func termsOfServiceButtonTap(sender: UIButton) {
        termsOfServiceTap()
    }
    
    @objc private func privacyButtonTap(sender: UIButton) {
        privacyButtonTap()
    }
    
    func privacyButtonTap() {
        if let url = URL(string: PrivacyPolicy().string) {
            let configuration = SFSafariViewController.Configuration()
            configuration.barCollapsingEnabled = false
            
            let safariViewController = SFSafariViewController(url: url, configuration: configuration)
            safariViewController.preferredBarTintColor = .white
            safariViewController.preferredControlTintColor = .black
            present(safariViewController, animated: true)
        }
    }
    
    func termsOfServiceTap() {
        if let url = URL(string: TermsOfService().string) {
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
        
        view.addSubview(containerView)
        view.addSubview(subscribeButton)
        view.addSubview(unlimitedFileClaimImage)
        view.addSubview(unlimitedFileClaimLabel)
        view.addSubview(freeLegalServicesImage)
        view.addSubview(freeLegalServicesLabel)
        view.addSubview(communityRatingsImage)
        view.addSubview(communityRatingsLabel)
        view.addSubview(autoRenewMessageLabel)
//        view.addSubview(termsOfService)
//        view.addSubview(privacyButton)
//
        let margin = view.layoutMarginsGuide
        
        view.addConstraints([NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: margin, attribute: .centerY, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.frame.width)])
        
        view.addConstraints([NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.frame.height)])
        
        
        view.addConstraints([NSLayoutConstraint(item: subscribeButton, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: subscribeButton, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 40)])
        
        view.addConstraints([NSLayoutConstraint(item: subscribeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)])
        
        view.addConstraints([NSLayoutConstraint(item: subscribeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        
        view.addConstraints([NSLayoutConstraint(item: unlimitedFileClaimImage, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: unlimitedFileClaimImage, attribute: .top, relatedBy: .equal, toItem: subscribeButton, attribute: .top, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: unlimitedFileClaimImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24)])
        
        view.addConstraints([NSLayoutConstraint(item: unlimitedFileClaimImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24)])
        
        
        view.addConstraints([NSLayoutConstraint(item: unlimitedFileClaimLabel, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: unlimitedFileClaimLabel, attribute: .top, relatedBy: .equal, toItem: unlimitedFileClaimImage, attribute: .top, multiplier: 1, constant: 30)])
        
        view.addConstraints([NSLayoutConstraint(item: unlimitedFileClaimLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: unlimitedFileClaimLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])

        
        view.addConstraints([NSLayoutConstraint(item: freeLegalServicesImage, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: freeLegalServicesImage, attribute: .top, relatedBy: .equal, toItem: unlimitedFileClaimLabel, attribute: .top, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: freeLegalServicesImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24)])
        
        view.addConstraints([NSLayoutConstraint(item: freeLegalServicesImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24)])
        
        
        view.addConstraints([NSLayoutConstraint(item: freeLegalServicesLabel, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: freeLegalServicesLabel, attribute: .top, relatedBy: .equal, toItem: freeLegalServicesImage, attribute: .top, multiplier: 1, constant: 30)])
        
        view.addConstraints([NSLayoutConstraint(item: freeLegalServicesLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: freeLegalServicesLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        
        view.addConstraints([NSLayoutConstraint(item: communityRatingsImage, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: communityRatingsImage, attribute: .top, relatedBy: .equal, toItem: freeLegalServicesLabel, attribute: .top, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: communityRatingsImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24)])
        
        view.addConstraints([NSLayoutConstraint(item: communityRatingsImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24)])
        
        
        view.addConstraints([NSLayoutConstraint(item: communityRatingsLabel, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: communityRatingsLabel, attribute: .top, relatedBy: .equal, toItem: communityRatingsImage, attribute: .top, multiplier: 1, constant: 30)])
        
        view.addConstraints([NSLayoutConstraint(item: communityRatingsLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: communityRatingsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        
        view.addConstraints([NSLayoutConstraint(item: autoRenewMessageLabel, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: autoRenewMessageLabel, attribute: .top, relatedBy: .equal, toItem: communityRatingsLabel, attribute: .top, multiplier: 1, constant: 50)])
        
        view.addConstraints([NSLayoutConstraint(item: autoRenewMessageLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.frame.width)])
        
        view.addConstraints([NSLayoutConstraint(item: autoRenewMessageLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)])
        
        
//        view.addConstraints([NSLayoutConstraint(item: termsOfService, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 10)])
//
//        view.addConstraints([NSLayoutConstraint(item: termsOfService, attribute: .bottom, relatedBy: .equal, toItem: autoRenewMessageLabel, attribute: .bottom, multiplier: 1, constant: 40)])
//
//        view.addConstraints([NSLayoutConstraint(item: termsOfService, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)])
//
//        view.addConstraints([NSLayoutConstraint(item: termsOfService, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18)])
//
//
//        view.addConstraints([NSLayoutConstraint(item: privacyButton, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: -10)])
//
//        view.addConstraints([NSLayoutConstraint(item: privacyButton, attribute: .bottom, relatedBy: .equal, toItem: autoRenewMessageLabel, attribute: .bottom, multiplier: 1, constant: 40)])
//
//        view.addConstraints([NSLayoutConstraint(item: privacyButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)])
//
//        view.addConstraints([NSLayoutConstraint(item: privacyButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
