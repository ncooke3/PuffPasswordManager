//
//  Account.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 7/31/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import Foundation
import Locksmith

class Account:  ReadableSecureStorable,
                CreateableSecureStorable,
                DeleteableSecureStorable,
                GenericPasswordSecureStorable {
    
    //var service : String
    var username: String
    var password: String
    
    //Required by GenericPasswordSecureStorable
    let service: String
    var account: String { return username }
    
    //Required by CreateableSecureStorable
    var data: [String: Any] {
        return ["password": password]
    }
    
    init(service: String, username: String, password: String) {
        self.service = service
        self.username = username
        self.password = password
    }
    
}
