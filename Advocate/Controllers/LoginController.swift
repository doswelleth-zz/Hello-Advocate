//
//  LoginController.swift
//  Advocate
//
//  Created by David Oliver Doswell on 3/16/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
private let touchIDAlertTitle = "Error"
private let touchIDActionTitle = "Okay"

class LoginController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let touch = BiometricIDAuth()
    
    let page : Page? = nil
    
    let pages = Titles().info
    
    var loginCell = LoginCell()
    
    var profileController : ProfileController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        collectionView?.register(LoginCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        loginCell.touchIDButton.isHidden = !touch.canEvaluatePolicy()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LoginCell
        
        let page = pages[indexPath.item]
        cell.page = page
        
        cell.signInButton.addTarget(self, action: #selector(signInButtonTap(sender:)), for: .touchUpInside)
        
        cell.touchIDButton.addTarget(self, action: #selector(touchIDButtonTap(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func signInButtonTap(sender: UIButton) {
        let signInController = SignInController()
        self.navigationController?.pushViewController(signInController, animated: true)
    }
    
    @objc private func touchIDButtonTap(sender: UIButton) {
        touch.authenticateUser() { [weak self] message in
            if let message = message {
                let alert = UIAlertController(title: touchIDAlertTitle, message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: touchIDActionTitle, style: .default)
                alert.addAction(action)
                self?.present(alert, animated: true)
            } else {
                self?.presentProfileController()
            }
        }
    }
    
    @objc private func privacyButtonTap(sender: UIButton) {
        let privacyController = PrivacyController()
        self.navigationController?.pushViewController(privacyController, animated: true)
    }
    
    private func presentProfileController() {
        let layout = UICollectionViewFlowLayout()
        let destination = ProfileController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

