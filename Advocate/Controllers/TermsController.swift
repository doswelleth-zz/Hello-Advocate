//
//  TermsController.swift
//  Advocate
//
//  Created by David Doswell on 9/2/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import UIKit

private let termsOfServiceText = "Terms of Service"

class TermsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        swipeDown()
    }
    
    let termsOfServiceLabel : UILabel = {
        let label = UILabel()
        label.text = termsOfServiceText
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let termsOfServiceTextView : UITextView = {
        let textView = UITextView()
        textView.text = Terms().ofService
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
        
        view.addSubview(termsOfServiceLabel)
        view.addSubview(termsOfServiceTextView)
        
        let termsOfServiceLabelConstraints = [termsOfServiceLabel.bottomAnchor.constraint(equalTo: termsOfServiceTextView.topAnchor, constant: -10.0), termsOfServiceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        
        let termsOfServiceTextViewConstraints = [termsOfServiceTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor), termsOfServiceTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor), termsOfServiceTextView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 10.0), termsOfServiceTextView.heightAnchor.constraint(equalToConstant: 400.0)]
        
        NSLayoutConstraint.activate(termsOfServiceLabelConstraints)
        NSLayoutConstraint.activate(termsOfServiceTextViewConstraints)
        
    }
}
