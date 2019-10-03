//
//  LawyerCell.swift
//  Advocate
//
//  Created by David Doswell on 9/18/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import UIKit

class LawyerCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
        
    lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 22.0
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
    
    let locationLabel: UILabel = {
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
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    var lawyer: Lawyer? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Methods
    
    private func updateViews() {
        guard let lawyer = lawyer else { return }
        usernameLabel.text = lawyer.username.name
        practiceLabel.text = lawyer.practice
        locationLabel.text = lawyer.location
        dateLabel.text = "Member since \(lawyer.createdAt.calenderTimeSinceNow())"
    }
    
    private func setUpViews() {
        backgroundColor = .black
        isUserInteractionEnabled = true
        selectionStyle = .none
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(practiceLabel)
        addSubview(locationLabel)
        addSubview(dateLabel)
        
        let profileImageViewConstraints = [profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20.0), profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20.0), profileImageView.widthAnchor.constraint(equalToConstant: 44.0), profileImageView.heightAnchor.constraint(equalToConstant: 44.0)]
        
        let usernameLabelConstraints = [usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor), usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10.0)]
        
        let practiceLabelConstraints = [practiceLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5.0), practiceLabel.leftAnchor.constraint(equalTo: usernameLabel.leftAnchor)]
        
        let locationLabelConstraints = [locationLabel.topAnchor.constraint(equalTo: practiceLabel.bottomAnchor, constant: 5.0), locationLabel.leftAnchor.constraint(equalTo: usernameLabel.leftAnchor), locationLabel.rightAnchor.constraint(equalTo: dateLabel.rightAnchor), locationLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -20.0)]
        
        let dateLabelConstraints = [dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0), dateLabel.leftAnchor.constraint(equalTo: locationLabel.leftAnchor)]
        
        NSLayoutConstraint.activate(profileImageViewConstraints)
        NSLayoutConstraint.activate(usernameLabelConstraints)
        NSLayoutConstraint.activate(practiceLabelConstraints)
        NSLayoutConstraint.activate(locationLabelConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
    }
    
}
