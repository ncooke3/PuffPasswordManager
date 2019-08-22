//
//  Requests.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/16/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import Foundation
import UIKit

extension URLSession {
    
    func dataTask(with url: URL, result: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                let badStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 404
                let error = NSError(domain: "Invalid Response: \(badStatusCode)", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "Could not get response and/or data", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            
            result(.success(data))
        }
    }
    
}

class Requests {
    func fetchCompanyInformation(with url: URL, completion: @escaping ([String: String]?) -> Void) {
        URLSession.shared.dataTask(with: url) { result in
            switch result {
            case .success(let data):
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: [])
                        as? [[String: String]] else {
                            print("🚨 Could not convert data to JSON.")
                            return
                    }
                    
                    guard let company = json.first else {
                        print("🚨 Could not get todo title from JSON")
                        return
                    }
                    
                    completion(company)
                    
                } catch  {
                    print("🚨 Could not convert data to JSON.")
                    return
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
                break
            }
            
            }.resume()
    }

}

