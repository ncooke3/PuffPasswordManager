//
//  ViewController.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 7/31/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit
import Locksmith

class ViewController: UIViewController, UITextFieldDelegate {
    
    let serviceField  = UITextField()
    let usernameField = UITextField()
    let passwordField = UITextField()
    let saveButton    = RoundButton()
    
    func changeUsernameFor( account: inout Account, newUsername: String) {
        // 1 Temp store password
        guard let oldPassword = account.getPasswordFromStore() else { return }
        
        // 2 Delete Curr Keychain
        account.safelyDeleteFromKeychain()
        
        // 3 Make new Account
        account = Account(service: account.service, username: newUsername, password: oldPassword)
        
        // 4 Replace oldAccount in AccountDefaults with newAccount
        AccountDefaults.accounts[0] = account
        account = AccountDefaults.accounts[0]
        
        // 5 Save new account into Keychain
        account.safelyStoreInKeychain()
        account.password = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        setupHideKeyboardOnTap()
        setupServiceTextfield()
        setupUsernameTextfield()
        setupPasswordTextField()
        setupSaveButton()
    }

    @objc func saveButtonTapped() {
        print("Save Button has been tapped!")
        
        // PRACTICE: maybe add an alert if they
        //           aren't all filled out!
        let service  = serviceField.text ?? "Gatech"
        let username = usernameField.text ?? "ncooke3"
        let password = passwordField.text ?? "smile123"
        
        // Lanyard/AddPasswordVC: Creates new account and stores in keychain + AccountDefaults
        let newAccount = Account(service: service, username: username, password: password)
        newAccount.safelyStoreInKeychain()
        newAccount.addToAccountsDefaults()
    }
    
    fileprivate func printAccount(account: Account) {
        print("""
            Account
                Service:  \(account.service)
                Username: \(account.username)
                Password: \(account.password)
            
            """)
    }

    fileprivate func setupServiceTextfield() {
        serviceField.delegate = self
        serviceField.placeholder = "Service"
        serviceField.translatesAutoresizingMaskIntoConstraints = false
        serviceField.backgroundColor = .white
        serviceField.setLeftAndRightPadding(amount: 20)
        
        serviceField.layer.cornerRadius = 7.0
        serviceField.layer.borderColor = UIColor.white.cgColor
        serviceField.layer.borderWidth = 1.0
        
        view.addSubview(serviceField)
        
        NSLayoutConstraint.activate([
            serviceField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            serviceField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -250),
            serviceField.widthAnchor.constraint(equalToConstant: 250),
            serviceField.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    fileprivate func setupUsernameTextfield() {
        usernameField.delegate = self
        usernameField.placeholder = "Username"
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.backgroundColor = .white
        usernameField.setLeftAndRightPadding(amount: 20)
        
        usernameField.layer.cornerRadius = 7.0
        usernameField.layer.borderColor = UIColor.white.cgColor
        usernameField.layer.borderWidth = 1.0
        
        view.addSubview(usernameField)
        
        NSLayoutConstraint.activate([
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -175),
            usernameField.widthAnchor.constraint(equalToConstant: 250),
            usernameField.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    fileprivate func setupPasswordTextField() {
        passwordField.delegate = self
        passwordField.placeholder = "Password"
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.backgroundColor = .white
        passwordField.setLeftAndRightPadding(amount: 20)
        
        passwordField.layer.cornerRadius = 7.0
        passwordField.layer.borderColor = UIColor.white.cgColor
        passwordField.layer.borderWidth = 1.0
        
        view.addSubview(passwordField)
        
        NSLayoutConstraint.activate([
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:
                -100),
            passwordField.widthAnchor.constraint(equalToConstant: 250),
            passwordField.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    fileprivate func setupSaveButton() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        saveButton.setTitle("Save Account", for: .normal)
        saveButton.backgroundColor = UIColor(red: 0.45, green: 0.73, blue: 1.00, alpha: 1.0)
        
        saveButton.sizeToFit()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    
}
