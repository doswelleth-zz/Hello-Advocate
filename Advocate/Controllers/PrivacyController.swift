//
//  PrivacyController.swift
//  Advocate
//
//  Created by David Doswell on 9/2/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import UIKit

private let privacyPolicyText = "Privacy Policy"

class PrivacyController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        swipeDown()
    }
    
    let privacyPolicyLabel : UILabel = {
        let label = UILabel()
        label.text = privacyPolicyText
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let privacyPolicyTextView : UITextView = {
        let textView = UITextView()
        textView.text = Privacy().policy
        textView.textColor = .white
        textView.allowsEditingTextAttributes = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textAlignment = .justified
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.backgroundColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    func setUpViews() {
        
        view.backgroundColor = .black
        
        view.addSubview(privacyPolicyLabel)
        view.addSubview(privacyPolicyTextView)
        
        let privacyPolicyLabelConstraints = [privacyPolicyLabel.bottomAnchor.constraint(equalTo: privacyPolicyTextView.topAnchor, constant: -10.0), privacyPolicyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        
        let privacyPolicyTextViewConstraints = [privacyPolicyTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor), privacyPolicyTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor), privacyPolicyTextView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 10.0), privacyPolicyTextView.heightAnchor.constraint(equalToConstant: 400.0)]
        
        NSLayoutConstraint.activate(privacyPolicyLabelConstraints)
        NSLayoutConstraint.activate(privacyPolicyTextViewConstraints)
        
    }


}
