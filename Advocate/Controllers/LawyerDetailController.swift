//
//  LawyerDetailController.swift
//  Advocate
//
//  Created by David Doswell on 9/18/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase

class LawyerDetailController: UIViewController {
        
    // MARK: - Set up
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let profileImageUrl = lawyer?.username.profileImageUrl {
            profileImageView.loadImageUsingCache(with: profileImageUrl)
        }
        
        usernameLabel.text = lawyer?.username.name
        practiceLabel.text = lawyer?.practice
        lawSchoolLabel.text = lawyer?.lawSchool
        biographyLabel.text = lawyer?.biography
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
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
        view.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
        return view
    }()
    
    // MARK: - Properties
    
    var lawyer: Lawyer?
    
    lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 75.0
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.sizeToFit()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let practiceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.sizeToFit()
        label.layoutIfNeeded()
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lawSchoolLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.sizeToFit()
        label.layoutIfNeeded()
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let biographyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        label.layoutIfNeeded()
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separatorLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.separatorLabelText
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.layoutIfNeeded()
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    // MARK: - Methods
    
    @objc private func chatButtonTapped(sender: UIButton) {
        let layout = UICollectionViewFlowLayout()
        let destination = ChatLogController(collectionViewLayout: layout)
        self.navigationController?.modalPresentationStyle = .overCurrentContext
        present(destination, animated: true, completion: nil)
    }
    
    // MARK: - Constraints

    private func setUpViews() {
        view.backgroundColor = .black
        view.addSubview(scrollView)
        
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(practiceLabel)
        scrollView.addSubview(lawSchoolLabel)
        scrollView.addSubview(biographyLabel)
        scrollView.addSubview(separatorLabel)
        
        let scrollViewConstraints = [scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor), scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor), scrollView.widthAnchor.constraint(equalToConstant: view.frame.size.width), scrollView.heightAnchor.constraint(equalToConstant: 600.0)]
        
        let userImageConstraints = [profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30.0), profileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor), profileImageView.widthAnchor.constraint(equalToConstant: 150.0), profileImageView.heightAnchor.constraint(equalToConstant: 150.0)]
        
        let usernameLabelConstraints = [usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20.0), usernameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)]
                
        let practiceLabelConstraints = [practiceLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10.0), practiceLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)]
        
        let lawSchoolConstraints = [lawSchoolLabel.topAnchor.constraint(equalTo: practiceLabel.bottomAnchor, constant: 10.0), lawSchoolLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)]
        
        let biographyLabelConstraints = [biographyLabel.topAnchor.constraint(equalTo: lawSchoolLabel.bottomAnchor, constant: 30.0), biographyLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30.0), biographyLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50.0)]
        
        let separatorLabelConstraints = [separatorLabel.topAnchor.constraint(equalTo: biographyLabel.bottomAnchor, constant: 30.0), separatorLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(userImageConstraints)
        NSLayoutConstraint.activate(usernameLabelConstraints)
        NSLayoutConstraint.activate(practiceLabelConstraints)
        NSLayoutConstraint.activate(lawSchoolConstraints)
        NSLayoutConstraint.activate(biographyLabelConstraints)
        NSLayoutConstraint.activate(separatorLabelConstraints)
    }
}
