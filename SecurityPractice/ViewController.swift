//
//  ViewController.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 7/31/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit
import Locksmith
import Lottie

extension UILabel {
    func copyLabel() -> UILabel {
        let label = UILabel()
        label.font = self.font
        label.frame = self.frame
        label.text = self.text
        label.textColor = self.textColor
        return label
    }
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    let containerView = UIView()
    let serviceField  = UITextField()
    let usernameField = UITextField()
    let passwordField = UITextField()
    let saveButton    = RoundButton()
    var animationView = AnimationView()
    
    let label = UILabel()
    let duration = 1.0
    let fontSizeSmall: CGFloat = 0.1
    let fontSizeBig: CGFloat = 35.0
    
    fileprivate func setupContainerView() {
        containerView.frame = view.frame
        view.addSubview(containerView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(AccountDefaults.accounts)
        
        view.backgroundColor = .lightGray
        setupContainerView()
        setupLabel()
        setupServiceTextfield()
        setupUsernameTextfield()
        setupPasswordTextField()
        setupSaveButton()
        setupHideKeyboardOnTap()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        enlargeWithCrossFade()
    }
    
    
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
    
    func accountDefaultsDoesContain(account: Account) -> Bool {
        let doesContain = AccountDefaults.accounts.contains(where: { (element) -> Bool in
            let areServicesEqual  = element.service == account.service
            let areUsernamesEqual = element.username == account.username
            let arePasswordsEqual = element.password == account.password
            return areServicesEqual && areUsernamesEqual && arePasswordsEqual
        })
        
        return doesContain
    }

    @objc func saveButtonTapped() {
        print("Save Button has been tapped!")
        
        shrinkWithCrossFade {
            self.setupCloudSecurityAnimation()
            self.animationView.play(fromFrame: 0, toFrame: 600, loopMode: .autoReverse)
        }
        
        // PRACTICE: maybe add an alert if they
        //           aren't all filled out!
        let service  = serviceField.text ?? "Gatech"
        let username = usernameField.text ?? "ncooke3"
        let password = passwordField.text ?? "smile123"
        
        // Lanyard/AddPasswordVC: Creates new account and stores in keychain + AccountDefaults
        let newAccount = Account(service: service, username: username, password: password)

        guard !accountDefaultsDoesContain(account: newAccount) else { return }
        
        newAccount.addToAccountsDefaults()
        newAccount.safelyStoreInKeychain()

    }
    
    fileprivate func printAccount(account: Account) {
        print("""
            Account
                Service:  \(account.service)
                Username: \(account.username)
                Password: \(account.password)
            
            """)
    }
    
    fileprivate func setupLabel() {
        label.text = "Add an Account!"
        label.font = label.font.withSize(fontSizeSmall)
        label.textColor = .white
        label.sizeToFit() // Important for enlargeWithCrossfade()
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.20),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }
    
    private func scaleTransform(from: CGSize, to: CGSize) -> CGAffineTransform {
        let scaleX = to.width / from.width
        let scaleY = to.height / from.height
        
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
    
    // NOTE: Removed copyLabel from original code.
    func enlargeWithCrossFade() {
        var biggerBounds = label.bounds
        
        label.font = UIFont.boldSystemFont(ofSize: fontSizeBig)
        biggerBounds.size = label.intrinsicContentSize

        label.transform = scaleTransform(from: biggerBounds.size, to: label.bounds.size)
        label.bounds = biggerBounds
        label.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: 0.5, usingSpringWithDamping: 0.4,
            initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                
            self.label.transform = .identity
        })
        
        UIView.animate(withDuration: duration / 2) {
            self.label.alpha = 1.0
        }
    }
    
    func shrinkWithCrossFade(completion: @escaping () -> ()) {
        let labelCopy = label.copyLabel()
        view.addSubview(labelCopy)
        
        var smallerBounds = label.bounds
        label.font = label.font.withSize(fontSizeSmall)
        smallerBounds.size = label.intrinsicContentSize
        
        label.transform = scaleTransform(from: smallerBounds.size, to: label.bounds.size)
        label.alpha = 0.0
        
        let shrinkTransform = scaleTransform(from: label.bounds.size, to: smallerBounds.size)
        
        let duration = 0.5
        UIView.animate(withDuration: duration, animations: {
            labelCopy.transform = shrinkTransform
            self.label.transform = .identity
        }, completion: { done in
            self.label.transform = .identity
            self.label.bounds = smallerBounds
        })
        
        let percUntilFade = 0.8
        UIView.animate(withDuration: duration - (duration * percUntilFade), delay: duration * percUntilFade, options: .curveLinear, animations: {
            labelCopy.alpha = 0
            self.label.alpha = 1
        }, completion: { done in
            labelCopy.removeFromSuperview()
            completion()
        })
    }
    
    fileprivate func setupCloudSecurityAnimation() {
        let animation = Animation.named("cloud-security")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        view.insertSubview(animationView, belowSubview: containerView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.22),
            animationView.widthAnchor.constraint(equalToConstant: view.frame.width),
            animationView.heightAnchor.constraint(equalToConstant: view.frame.width)
            ])
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
        
        containerView.addSubview(serviceField)
        
        NSLayoutConstraint.activate([
            serviceField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            serviceField.topAnchor.constraint(equalTo: view.topAnchor, constant: 290),
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
        
        containerView.addSubview(usernameField)
        
        NSLayoutConstraint.activate([
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.topAnchor.constraint(equalTo: serviceField.bottomAnchor, constant: 30),
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
        
        containerView.addSubview(passwordField)
        
        NSLayoutConstraint.activate([
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant:
                30),
            passwordField.widthAnchor.constraint(equalToConstant: 250),
            passwordField.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    fileprivate func setupSaveButton() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        saveButton.setTitle("Save Account", for: .normal)
        saveButton.backgroundColor = UIColor(red: 0.69, green: 0.82, blue: 0.87, alpha: 1.0)
        
        saveButton.sizeToFit()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20)
            ])
    }
    
}
