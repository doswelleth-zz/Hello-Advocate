//
//  ChatMessageCell.swift
//  Advocate
//
//  Created by David Doswell on 9/22/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    // MARK: - Set up
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    var message: Message?
    
    var chatLogController: ChatLogController?
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
        textView.textColor = .white
        textView.isEditable = false
        return textView
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return imageView
    }()
    
    // MARK: - Methods
    
    @objc func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            self.chatLogController?.performZoomInForStartingImageView(imageView)
        }
    }
    
    // MARK: - Constraints
    
    private func setUpViews() {
        backgroundColor = .black
               
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(userImage)
       
        bubbleView.addSubview(messageImageView)
        
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
       
        userImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        userImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
               
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
           
        bubbleViewRightAnchor?.isActive = true
       
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 8)
       
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
       
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
       
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
       
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
}
