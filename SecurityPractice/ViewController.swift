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

class ViewController: UIViewController, UITextFieldDelegate {
    
    let blurView = UIVisualEffectView()
    
    var ghostPopupView: GhostPopupView!
    
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
        
        view.backgroundColor = Color.darkBackground.value
        setupContainerView()
        setupServiceTextfield()
        setupUsernameTextfield()
        setupPasswordTextField()
        setupSaveButton()
        setupHideKeyboardOnTap()
        setupCloudSecurityAnimation()
        animationView.play(fromFrame: 0, toFrame: 600, loopMode: .autoReverse)

        Development.printAllAccounts()
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
    
    // 🐞: This doesnt work? da fuq
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
        
        let service  = serviceField.text!
        let username = usernameField.text!
        let password = passwordField.text!
        
        guard service != "" else {
            self.handlePopupAndBlurView()
            return
        }
        
        guard username != "" else {
            self.handlePopupAndBlurView()
            return
        }
        
        guard password != "" else {
            self.handlePopupAndBlurView()
            return
        }
        
        // Lanyard/AddPasswordVC: Creates new account and stores in keychain + AccountDefaults
        
        /*
        let newAccount = Account(service: service, username: username, password: password)
        */
        
        //print(accountDefaultsDoesContain(account: newAccount))

        //guard !accountDefaultsDoesContain(account: newAccount) else { return }
        
        /*
        newAccount.addToAccountsDefaults()
        newAccount.safelyStoreInKeychain()
        */
    }
    
    func setupBlurView() {
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        blurView.effect = nil
    }
    
    func setupGhostPopupView() {
        ghostPopupView = GhostPopupView(frame: view.frame)
        view.addSubview(ghostPopupView)
        ghostPopupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ghostPopupView.topAnchor.constraint(equalTo: view.topAnchor),
            ghostPopupView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ghostPopupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ghostPopupView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        ghostPopupView.animateGhostHover()
    }

    func animatePopupAndBlurViewIn() {
        ghostPopupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        ghostPopupView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.blurView.effect = UIBlurEffect(style: .dark)
            self.ghostPopupView.alpha = 1
            self.ghostPopupView.transform = CGAffineTransform.identity
        }
    }
    
    func animatePopupAndBlurViewOut(after delay: Double = 0.0) {
        UIView.animate(withDuration: 0.3, delay: delay, animations: {
            self.ghostPopupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.ghostPopupView.alpha = 0
            self.blurView.effect = nil
            
        }) { (success: Bool) in
            self.blurView.removeFromSuperview()
            self.ghostPopupView.removeConstraints(self.ghostPopupView.constraints)
            self.ghostPopupView.removeFromSuperview()
        }
    }
    
    func handlePopupAndBlurView() {
        setupBlurView()
        setupGhostPopupView()
        animatePopupAndBlurViewIn()
        animatePopupAndBlurViewOut(after: 3.0)
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
    
    fileprivate func setupCloudSecurityAnimation() {
        let animation = Animation.named("clouds")
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
        serviceField.tintColor = Color.soothingBreeze.value
        serviceField.setIcon(#imageLiteral(resourceName: "icon-account"))
        
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
        //usernameField.setLeftAndRightPadding(amount: 20)
        usernameField.tintColor = Color.soothingBreeze.value
        usernameField.setIcon(#imageLiteral(resourceName: "icon-user"))
        
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
        //passwordField.setLeftAndRightPadding(amount: 20)
        passwordField.tintColor = Color.soothingBreeze.value
        passwordField.setIcon(#imageLiteral(resourceName: "icon-lock"))
        
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
        saveButton.backgroundColor = Color.brightYarrow.value
        
        saveButton.sizeToFit()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20)
            ])
    }
    
}
