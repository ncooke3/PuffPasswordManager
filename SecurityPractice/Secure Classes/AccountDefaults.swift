//
//  AccountDefaults.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 7/31/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import Foundation

struct AccountDefaults {

    static private let accountsKey = "accountsKey"

    static var accounts: [Account] = {

        guard let data = UserDefaults.standard.data(forKey: accountsKey) else { return [] }
        return try! JSONDecoder().decode([Account].self, from: data)
        }() {
        didSet {
            guard let data = try? JSONEncoder().encode(accounts) else { return }
            UserDefaults.standard.set(data, forKey: accountsKey)
        }
    }
}
