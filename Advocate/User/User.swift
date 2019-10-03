//
//  User.swift
//  Advocate
//
//  Created by David Doswell on 9/25/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import UIKit

class User {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}
