//
//  Development.swift
//  Locksmith
//
//  Created by Nicholas Cooke on 8/15/19.
//

import Foundation

struct Development {
    
    static func printAccount(account: Account) {
        print("""
            Account
            Service:  \(account.service)
            Username: \(account.username)
            Password: \(account.password)
            
            """)
    }
    
    static func printAllAccounts() {
        for index in 0..<AccountDefaults.accounts.count {
            print("Index: \(index)")
            Development.printAccount(account: AccountDefaults.accounts[index])
            let password = AccountDefaults.accounts[index].getPasswordFromStore()
            print("The password is", password!)
        }
    }
    
    static func printAllCompanies() {
        print("\nCompanies")
        for key in CompanyDefaults.companies.keys {
            print("\(key) : \(CompanyDefaults.companies[key]!)")
        }
    }
}
