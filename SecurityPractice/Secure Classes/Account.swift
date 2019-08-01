//
//  Account.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 7/31/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import Foundation

class Account {
    var service : String
    var username: String
    var password: String
    
    init(service: String, username: String, password: String) {
        self.service = service
        self.username = username
        self.password = password
    }
}
