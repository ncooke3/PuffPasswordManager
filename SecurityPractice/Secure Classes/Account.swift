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
    
    func safelyStoreInKeychain() {
        do {
            try self.createInSecureStore()
            print("✅ Safely Stored")
        } catch {
            print("❌ Couldn't store new account in keychain: \(error)")
        }
        
        // After storing password in keychain, let's clear password!
        self.password = ""
    }
    
    func safelyDeleteFromKeychain() {
        do {
            try self.deleteFromSecureStore()
            print("✅ Safely Deleted!")
        } catch {
            print("❌ Couldn't delete account in keychain: \(error)")
        }
    }
    
    func addToAccountsDefaults() {
        AccountDefaults.accounts.append(self)
    }
    
    // TODO: This probabaly doesnt need to be an instance method of Account
    func removeFromAccountDefaults(at index: Int) {
        AccountDefaults.accounts.remove(at: index)
    }
    
    // Lanyard/DetailVC: Load password to populate passwordTextField
    func getPasswordFromStore() -> String? {
        if let keychainData = self.readFromSecureStore() {
            if let dictionary = keychainData.data {
                if let password = dictionary["password"] as? String {
                    print("The password for \(self.service) is: \(password).")
                    return password
                }
            }
        }
        return nil
    }
    
    func setPasswordInStore(newPassword: String) {
        self.password = newPassword
        do {
            try self.updateInSecureStore()
        } catch {
            print("❌ Error: \(error)")
        }
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
