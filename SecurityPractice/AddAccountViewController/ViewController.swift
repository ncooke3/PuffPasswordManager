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
    
    lazy var loadingAnimation = AnimationView()
    
    func setupLoadingAnimation() {
        let animation = Animation.named("loading")
        loadingAnimation.animation = animation
        loadingAnimation.contentMode = .scaleAspectFit
        view.addSubview(loadingAnimation)
        
        loadingAnimation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingAnimation.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingAnimation.widthAnchor.constraint(equalToConstant: view.frame.width * 0.5),
            loadingAnimation.heightAnchor.constraint(equalToConstant: view.frame.width * 0.5)
            ])
    }
    
    lazy var successAnimation = AnimationView()
    
    func setupSuccessAnimation() {
        let animation = Animation.named("success")
        successAnimation.animation = animation
        successAnimation.contentMode = .scaleAspectFit
        view.addSubview(successAnimation)
        
        successAnimation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            successAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successAnimation.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            successAnimation.widthAnchor.constraint(equalToConstant: view.frame.width * 0.5),
            successAnimation.heightAnchor.constraint(equalToConstant: view.frame.width * 0.5)
            ])
    }
    
    let containerView = UIView()
    let serviceField  = UITextField()
    let usernameField = UITextField()
    let passwordField = UITextField()
    let saveButton    = RoundButton()
    var cloudsAnimation = AnimationView()
    
    let label = UILabel()
    let duration = 1.0
    let fontSizeSmall: CGFloat = 0.1
    let fontSizeBig: CGFloat = 35.0
    
    fileprivate func setupContainerView() {
        containerView.frame = view.frame
        view.addSubview(containerView)
    }
    
    fileprivate func setupBackgroundForegroundNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
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
        cloudsAnimation.play(fromFrame: 0, toFrame: 600, loopMode: .autoReverse)

        // 🚧 Development Printing
//        AccountDefaults.safelyDeleteAllAccounts()
//        CompanyDefaults.deleteAllCompanies()
        Development.printAllAccounts()
        Development.printAllCompanies()
        
        setupBackgroundForegroundNotifications()
    }
    
    @objc func appMovedToBackground() {
        cloudsAnimation.pause()
    }
    
    @objc func appMovedToForeground() {
        cloudsAnimation.play()
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

    fileprivate func finishLoadingAnimation(_ loadingDurationInSeconds: TimeInterval) {
        DispatchQueue.main.async {
            self.loadingAnimation.pause()
            self.loadingAnimation.play(toProgress: 1)
            self.loadingAnimation.loopMode = .playOnce
            
            UIView.animate(withDuration: loadingDurationInSeconds, delay: 0, options: [.curveEaseOut], animations: {
                self.loadingAnimation.alpha = 0
            }, completion: { (_) in
                self.loadingAnimation.removeFromSuperview()
                self.loadingAnimation.removeConstraints(self.loadingAnimation.constraints)
                self.loadingAnimation.alpha = 1
            })
        }
    }
    
    fileprivate func finishSuccessAnimation(_ loadingDurationInSeconds: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + loadingDurationInSeconds, execute: {
            self.setupSuccessAnimation()
            self.successAnimation.play() { (_) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.successAnimation.alpha = 0
                    self.animateLightBlurViewOut()
                }, completion: { (_) in
                    self.successAnimation.removeFromSuperview()
                    self.successAnimation.removeConstraints(self.successAnimation.constraints)
                    self.successAnimation.alpha = 1
                })
            }
        })
    }
    
    fileprivate func handleLoadingAndSuccessAnimation() {
        let loadingDurationInSeconds = self.loadingAnimation.animation!.duration
        print(loadingDurationInSeconds)
        self.finishLoadingAnimation(loadingDurationInSeconds)
        self.finishSuccessAnimation(loadingDurationInSeconds)
    }
    
    @objc func saveButtonTapped() {
        
        var service  = serviceField.text!
        var username = usernameField.text!
        var password = passwordField.text!
        
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
        
        // Launch Loading Animation & Blur
        setupBlurView()
        animateLightBlurViewIn()
        setupLoadingAnimation()
        loadingAnimation.loopMode = .loop
        loadingAnimation.play()
        
        // Make Account
        service = service.trimmingCharacters(in: .whitespacesAndNewlines)
        username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let newAccount = Account(service: service, username: username, password: password)
        
        // Clear all Textfields
        serviceField.text  = ""
        usernameField.text = ""
        passwordField.text = ""
        
        // 🚧 Handle Duplicate Accounts Here
        // Maybe by updating current's password (the same as if you edited an account)
        
        // 🚧 Handle punctuation?
        let urlSafeServiceString = newAccount.service.replacingOccurrences(of: " ", with: "")
        let stringURL = "https://autocomplete.clearbit.com/v1/companies/suggest?query=\(urlSafeServiceString)"
        let url = URL(string: stringURL)!
        
        // Make API call 🚧 Handles errors!
        Requests().fetchCompanyInformation(with: url) { (info) in
            print("✅ API Call results:", info)
            
            guard let logoURLString = info["logo"] else { return } // Empty logo -> Fail!
            
            guard let logoURL = URL(string: logoURLString) else { return } // Bad URL -> Fail!
            
            // 🚧 newAccount.service should probably be passed into an extracted function?
            CompanyDefaults.companies[newAccount.service] = Company(name: newAccount.service, url: logoURL, color: nil)
            newAccount.addToAccountsDefaults()
            newAccount.safelyStoreInKeychain()
            
            self.handleLoadingAndSuccessAnimation()
        }
        
        
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
    
    func animateLightBlurViewIn() {
        UIView.animate(withDuration: 0.4) {
            self.blurView.effect = UIBlurEffect(style: .light)
        }
    }
    
    func animateLightBlurViewOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.effect = nil
        }) { (_) in
            self.blurView.removeFromSuperview()
        }
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
        cloudsAnimation.animation = animation
        cloudsAnimation.contentMode = .scaleAspectFit
        view.insertSubview(cloudsAnimation, belowSubview: containerView)
        
        cloudsAnimation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cloudsAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cloudsAnimation.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.22),
            cloudsAnimation.widthAnchor.constraint(equalToConstant: view.frame.width),
            cloudsAnimation.heightAnchor.constraint(equalToConstant: view.frame.width)
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
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if serviceField.hasText && usernameField.hasText && passwordField.hasText {
            textField.resignFirstResponder()
        } else {
            switch textField {
            case serviceField:
                usernameField.becomeFirstResponder()
            case usernameField:
                passwordField.becomeFirstResponder()
            case passwordField:
                passwordField.resignFirstResponder()
            default:
                textField.resignFirstResponder()
            }
        }

        return true
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
        saveButton.titleLabel?.font = UIFont(name: "SFProRounded-Medium", size: 17)
        saveButton.backgroundColor = Color.brightYarrow.value
        
        saveButton.sizeToFit()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20)
            ])
    }
    
}
