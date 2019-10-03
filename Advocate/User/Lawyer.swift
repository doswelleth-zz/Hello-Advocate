//
//  Lawyer.swift
//  Advocate
//
//  Created by David Doswell on 9/18/19.
//  Copyright © 2019 David Oliver Doswell. All rights reserved.
//

import Foundation

struct Lawyer {
    let id: String
    let username: User
    let practice: String
    let lawSchool: String
    let location: String
    let biography: String
    let createdAt: Date
    
    init(id: String, username: User, practice: String, lawSchool: String, location: String, biography: String, timestamp: Double) {
        self.id = id
        self.username = username
        self.practice = practice
        self.lawSchool = lawSchool
        self.location = location
        self.biography = biography
        self.createdAt = Date(timeIntervalSince1970: timestamp / 1000)
    }
}
