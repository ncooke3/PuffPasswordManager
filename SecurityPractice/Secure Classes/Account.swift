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
                GenericPasswordSecureStorable,
                Codable {
    
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

    private enum CodingKeys: String, CodingKey {
        case service
        case username
        // DOUBT: will account property still return
        //        username if account is not stored
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        service = try values.decode(String.self, forKey: .service)
        username = try values.decode(String.self, forKey: .username)
        password = "" // will this work?
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(service, forKey: .service)
        try container.encode(username, forKey: .username)
    }
    
}
