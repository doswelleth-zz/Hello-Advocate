//
//  LawyerController.swift
//  Advocate
//
//  Created by David Doswell on 9/20/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

private let reuseIdentifier = "reuseIdentifier"
private let navigationBarTitle = Strings.lawyerControllerNavigationTitle

class LawyerController: UITableViewController, UISearchBarDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchLawyers()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.tabBarController?.delegate = self
        
        self.navigationController?.navigationBar.isHidden = false
        self.title = navigationBarTitle
    
        // MARK: - Search Controller
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .black
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200.0
        
        tableView.register(LawyerCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        fetchLawyers()
    }
    
    // MARK: - Properties
    
    var lawyer: Lawyer!
    
    var lawyers: [Lawyer] = []
    var filteredLawyers: [Lawyer] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Search Methods
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterLawyers(with searchText: String) {
        filteredLawyers = lawyers.filter { lawyer in
            guard let name = lawyer.username.name?.lowercased() else {
                return false
            }
            return name.contains(searchText.lowercased())
            
        }
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - Methods
        
    private func fetchLawyers() {
        
        let lawyerRef = Database.database().reference().child("lawyers")
        let queryRef = lawyerRef.queryOrdered(byChild: "timestamp").queryLimited(toLast: 5)
        queryRef.observe(.value, with: { snapshot in
            
            var temporaryLawyers = [Lawyer]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dictionary = childSnapshot.value as? [String:Any],
                    
                    let user = dictionary["user"] as? [String:Any],
                    let name = user["name"] as? String,
                    let profileImageUrl = user["profileImageUrl"] as? String,
                    
                    let practice = dictionary["practice"] as? String,
                    let lawSchool = dictionary["lawSchool"] as? String,
                    let location = dictionary["location"] as? String,
                    let biography = dictionary["biography"] as? String,
                    let timestamp = dictionary["timestamp"] as? Double {
                    
                    let dict: [String:Any] = [
                        "name": name,
                        "profileImageUrl": profileImageUrl
                    ]

                    let _user = User(dictionary: dict)
                                        
                    let lawyer = Lawyer(id: childSnapshot.key, username: _user, practice: practice, lawSchool: lawSchool, location: location, biography: biography, timestamp: timestamp)
                    
                    DispatchQueue.main.async {
                        temporaryLawyers.insert(lawyer, at: 0)
                        self.lawyers = temporaryLawyers
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
    // MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredLawyers.count
        } else {
            return lawyers.count
        }
    }
    
    var user: User?
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LawyerCell
        
        if isFiltering() {
            cell.lawyer = filteredLawyers[indexPath.row]
        } else {
            cell.lawyer = lawyers[indexPath.row]
        }
        
        if let profileImageUrl = cell.lawyer?.username.profileImageUrl {
            cell.profileImageView.loadImageUsingCache(with: profileImageUrl)
        }
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lawyer: Lawyer
        
        if self.isFiltering() {
            lawyer = self.filteredLawyers[indexPath.row]
            
            let destination = LawyerDetailController()
            destination.lawyer = lawyer
            self.navigationController?.pushViewController(destination, animated: true)
            
        } else {
            lawyer = self.lawyers[indexPath.row]
            
            let destination = LawyerDetailController()
            destination.lawyer = lawyer
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
}

// MARK: - Extensions

extension LawyerController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterLawyers(with: searchController.searchBar.text!)
    }
}

extension LawyerController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
