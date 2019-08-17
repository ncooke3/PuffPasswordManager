//
//  CompanyDefaults.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/17/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import Foundation

struct CompanyDefaults {
    static private let companiesKey = "companiesKey"
    
    static var companies: [String: Company] = {
        guard let data = UserDefaults.standard.data(forKey: companiesKey) else { return [:] }
        return try! JSONDecoder().decode([String: Company].self, from: data)
        
    }() {
        didSet {
            guard let data = try? JSONEncoder().encode(companies) else { return }
            UserDefaults.standard.set(data, forKey: companiesKey)
        }
    }
    
    static func deleteAllCompanies() {
        self.companies.removeAll()
    }
    
}
