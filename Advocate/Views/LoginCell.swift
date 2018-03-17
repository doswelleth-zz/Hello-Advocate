//
//  LoginCell.swift
//  Advocate
//
//  Created by David Oliver Doswell on 3/16/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit

private let signInButtonTitle = "Sign In"
private let orLabelTitle = "or"
private let touchIDButtonTitle = "Touch ID"

class LoginCell: UICollectionViewCell {
    
    var page: Page? {
        didSet {
            guard let loginPage = page else { return }
            
            logoImage.image = UIImage(named: loginPage.logo)
            
            let attributedText = NSMutableAttributedString(string: loginPage.title, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17)])
            
            attributedText.append(NSAttributedString(string: "\n\n\n \(loginPage.subtitle)", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.gray]))
            
            titlesTextView.attributedText = attributedText
            titlesTextView.textAlignment = .center
        }
    }
    
    let logoImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Logo")
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let titlesTextView : UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.allowsEditingTextAttributes = false
        textView.textAlignment = .justified
        textView.isUserInteractionEnabled = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let signInButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(signInButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let orLabel : UILabel = {
        let label = UILabel()
        label.text = orLabelTitle
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let touchIDButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(touchIDButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func setUpViews() {
        
        backgroundColor = .white
        
        addSubview(logoImage)
        addSubview(titlesTextView)
        addSubview(signInButton)
        addSubview(orLabel)
        addSubview(touchIDButton)
        
        let margin = layoutMarginsGuide
        
        addConstraints([NSLayoutConstraint(item: logoImage, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        addConstraints([NSLayoutConstraint(item: logoImage, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .top, multiplier: 1, constant: 20)])
        
        addConstraints([NSLayoutConstraint(item: logoImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)])
        
        addConstraints([NSLayoutConstraint(item: logoImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)])
        
        
        addConstraints([NSLayoutConstraint(item: titlesTextView, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        addConstraints([NSLayoutConstraint(item: titlesTextView, attribute: .bottom, relatedBy: .equal, toItem: logoImage, attribute: .bottom, multiplier: 1, constant: 100)])
        
        addConstraints([NSLayoutConstraint(item: titlesTextView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        addConstraints([NSLayoutConstraint(item: titlesTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)])
        
        
        addConstraints([NSLayoutConstraint(item: signInButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        addConstraints([NSLayoutConstraint(item: signInButton, attribute: .bottom, relatedBy: .equal, toItem: titlesTextView, attribute: .bottom, multiplier: 1, constant: 75)])
        
        addConstraints([NSLayoutConstraint(item: signInButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)])
        
        addConstraints([NSLayoutConstraint(item: signInButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        
        addConstraints([NSLayoutConstraint(item: orLabel, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        addConstraints([NSLayoutConstraint(item: orLabel, attribute: .bottom, relatedBy: .equal, toItem: signInButton, attribute: .bottom, multiplier: 1, constant: 30)])
        
        addConstraints([NSLayoutConstraint(item: orLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)])
        
        addConstraints([NSLayoutConstraint(item: orLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        
        
        addConstraints([NSLayoutConstraint(item: touchIDButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        addConstraints([NSLayoutConstraint(item: touchIDButton, attribute: .bottom, relatedBy: .equal, toItem: orLabel, attribute: .bottom, multiplier: 1, constant: 50)])
        
        addConstraints([NSLayoutConstraint(item: touchIDButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)])
        
        addConstraints([NSLayoutConstraint(item: touchIDButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
    }
    
}
