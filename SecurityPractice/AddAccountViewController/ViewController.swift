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
import UIImageColors
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let blurView = UIVisualEffectView()
    var ghostPopupView: GhostPopupView!
    
    lazy var loadingAnimation = AnimationView()
    lazy var successAnimation = AnimationView()
    lazy var errorAnimation = AnimationView()
    
    let containerView = UIView()
    let serviceField  = UISuggestionTextField()
    let usernameField = UITextField()
    let passwordField = UITextField()
    let saveButton    = RoundButton()
    var cloudsAnimation = AnimationView()
    
    var userText = ""
    var currentSuggestion: String = "" {
        didSet {
            serviceField.suggestionText = currentSuggestion
        }
    }
    
    private var request: Request? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    let label = UILabel()
    let duration = 1.0
    let fontSizeSmall: CGFloat = 0.1
    let fontSizeBig: CGFloat = 35.0
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = """
                        Something went wrong!
                        Try again later...
                     """
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(name: "SFProRounded-Medium", size: 23)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cancelButton: AddAccountButton = {
        let button = AddAccountButton()
        button.backgroundColor = Color.custom(hexString: "#0984e3", alpha: 1).value
        button.translatesAutoresizingMaskIntoConstraints = false
        button.value = "x"
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.darkBackground.value
        setupContainerView()
        setupServiceTextfield()
        setupUsernameTextfield()
        setupPasswordTextField()
        setupSaveButton()
        setupHideKeyboardOnTap()
        setupCloudSecurityAnimation()
        cloudsAnimation.play(fromFrame: 0, toFrame: 600, loopMode: .autoReverse)
        setupBackgroundForegroundNotifications()
        setupCancelButton()
        
        // 🚧 Development Printing
//        AccountDefaults.safelyDeleteAllAccounts()
//        CompanyDefaults.deleteAllCompanies()
        Development.printAllAccounts()
        Development.printAllCompanies()
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
            
            guard let info = info else {
                print("fail")
                self.handleLoadingAndErrorAnimation() {
                    self.dismiss(animated: true, completion: {
                        globalMainViewController?.tableView.reloadData()
                    })
                }
                return
            }
            
            print("✅ API Call results:", info)
            
            guard let logoURLString = info["logo"] else { return } // Empty logo -> Fail!
            
            guard let logoURL = URL(string: logoURLString) else { return } // Bad URL -> Fail!
            
            // 🚧 newAccount.service should probably be passed into an extracted function?
            CompanyDefaults.companies[newAccount.service] = Company(name: newAccount.service, url: logoURL, color: nil)
            newAccount.addToAccountsDefaults()
            newAccount.safelyStoreInKeychain()
            
            self.handleLoadingAndSuccessAnimation() {
                self.dismiss(animated: true, completion: {
                    globalMainViewController?.tableView.reloadData()
                })
            }
        }
        
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
    
    
    private func scaleTransform(from: CGSize, to: CGSize) -> CGAffineTransform {
        let scaleX = to.width / from.width
        let scaleY = to.height / from.height
        
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
    
}


/// Handles setting up Container View, Cloud Animation, Service, Username, and Password Textfields
extension ViewController {
    
    private func setupContainerView() {
        containerView.frame = view.frame
        view.addSubview(containerView)
    }
    
    private func setupCloudSecurityAnimation() {
        let animation = Animation.named("clouds")
        cloudsAnimation.animation = animation
        cloudsAnimation.contentMode = .scaleAspectFit
        view.insertSubview(cloudsAnimation, belowSubview: containerView)
        
        cloudsAnimation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cloudsAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cloudsAnimation.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.203),
            cloudsAnimation.widthAnchor.constraint(equalToConstant: view.frame.width),
            cloudsAnimation.heightAnchor.constraint(equalToConstant: view.frame.width)
            ])
    }
    
    private func setupServiceTextfield() {
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
            serviceField.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.355 * view.frame.height),
            serviceField.widthAnchor.constraint(equalToConstant: 0.666 * view.frame.width),
            serviceField.heightAnchor.constraint(equalToConstant: 0.049 * view.frame.height)
            ])
        
        serviceField.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
    }
    
    
    
    @objc private func textDidChange(textField: UITextField) {
        self.serviceField.textChanged()
        
        userText = textField.text ?? ""
        
        navigationItem.rightBarButtonItem?.isEnabled = !userText.isEmpty
        
        if userText.lowercased() != currentSuggestion.lowercased().dropLast(max(currentSuggestion.count - userText.count, 0)) {
            currentSuggestion = ""
        }
        
        setRecommendation(for: userText)
    }
    
    private func setRecommendation(for text : String) {
        guard !text.isEmpty else {
            request?.cancel()
            currentSuggestion = ""
            return
        }
        
        
        //make suggestion text label the first bit should be what the user has already written then after that display the rest of the suggestion
        //when what the user has written doesnt match the suggestion than it will still look correct i.e capital E thing
        
        //user types vharacter that doesnt match up with next charcater in suggestion you need to hide suggestion immediately and show (textDidChange if last letter of text != what /// set sugg to empty s
        
        
        request = AF.request("https://autocomplete.clearbit.com/v1/companies/suggest?query=\(text)", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let companyNames = json.array?.compactMap { $0["name"].string } ?? []
                self.currentSuggestion = self.recommendedSuggestions(for: companyNames)
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func recommendedSuggestions(for suggestions: [String]) -> String {
        guard !userText.isEmpty else {
            return ""
        }
        return suggestions.first { $0.lowercased().hasPrefix(userText.lowercased()) } ?? ""
    }

    
    private func setupUsernameTextfield() {
        usernameField.delegate = self
        
        usernameField.placeholder = "Username"
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.backgroundColor = .white
        usernameField.tintColor = Color.soothingBreeze.value
        usernameField.setIcon(#imageLiteral(resourceName: "icon-user"))
        
        usernameField.layer.cornerRadius = 7.0
        usernameField.layer.borderColor = UIColor.white.cgColor
        usernameField.layer.borderWidth = 1.0
        
        containerView.addSubview(usernameField)
        
        NSLayoutConstraint.activate([
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.topAnchor.constraint(equalTo: serviceField.bottomAnchor, constant: 0.025 * view.frame.height),
            usernameField.widthAnchor.constraint(equalToConstant: 0.666 * view.frame.width),
            usernameField.heightAnchor.constraint(equalToConstant: 0.049 * view.frame.height)
            ])
    }
    
    private func setupPasswordTextField() {
        passwordField.delegate = self
        passwordField.placeholder = "Password"
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.backgroundColor = .white
        passwordField.tintColor = Color.soothingBreeze.value
        passwordField.setIcon(#imageLiteral(resourceName: "icon-lock"))
        
        passwordField.layer.cornerRadius = 7.0
        passwordField.layer.borderColor = UIColor.white.cgColor
        passwordField.layer.borderWidth = 1.0
        
        containerView.addSubview(passwordField)
        
        NSLayoutConstraint.activate([
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant:
                0.025 * view.frame.height),
            passwordField.widthAnchor.constraint(equalToConstant: 0.666 * view.frame.width),
            passwordField.heightAnchor.constraint(equalToConstant: 0.049 * view.frame.height)
            ])
    }
    
    private func setupSaveButton() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        saveButton.setTitle("Save Account", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "SFProRounded-Medium", size: 17)
        saveButton.backgroundColor = Color.brightYarrow.value
        
        saveButton.sizeToFit()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 0.024 * view.frame.height)
            ])
    }
}

/// Handles the finishing of the Loading and Success Animations
extension ViewController {
    private func finishLoadingAnimation(_ loadingDurationInSeconds: TimeInterval) {
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
    
    private func finishSuccessAnimation(_ loadingDurationInSeconds: TimeInterval, completion: @escaping () -> ()) {
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
                    completion()
                })
            }
        })
    }
    
    private func handleLoadingAndSuccessAnimation(donedone: @escaping () -> ()) {
        let loadingDurationInSeconds = self.loadingAnimation.animation!.duration
        print(loadingDurationInSeconds)
        self.finishLoadingAnimation(loadingDurationInSeconds)
        self.finishSuccessAnimation(loadingDurationInSeconds) {
            donedone()
        }
        
    }
    
    
    private func handleLoadingAndErrorAnimation(donedone: @escaping () -> ()) {
        let loadingDurationInSeconds = self.loadingAnimation.animation!.duration
        print(loadingDurationInSeconds)
        self.finishLoadingAnimation(loadingDurationInSeconds)
        self.finishErrorAnimation(loadingDurationInSeconds) {
            donedone()
        }
        
    }
    
    private func finishErrorAnimation(_ loadingDurationInSeconds: TimeInterval, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + loadingDurationInSeconds, execute: {
            self.setupErrorAnimation()
            
            
            self.view.addSubview(self.errorLabel)
            NSLayoutConstraint.activate([
                self.errorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.errorLabel.bottomAnchor.constraint(equalTo: self.errorAnimation.topAnchor, constant: -60)
                ])
            self.errorLabel.alpha = 0
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.errorLabel.alpha = 1
            }, completion: { (_) in
                self.errorAnimation.play() { (_) in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.errorAnimation.alpha = 0
                        self.animateLightBlurViewOut()
                        
                        self.errorLabel.alpha = 0
                    }, completion: { (_) in
                        self.errorAnimation.removeFromSuperview()
                        self.errorAnimation.removeConstraints(self.errorAnimation.constraints)
                        self.errorAnimation.alpha = 1
                        
                        self.errorLabel.removeFromSuperview()
                        self.errorLabel.removeConstraints(self.errorLabel.constraints)
                        
                        completion()
                    })
                }
            })
        })
    }
}

/// Sets up cancel button
extension ViewController {
    
    private func setupCancelButton() {
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0.018 * view.frame.height),
            cancelButton.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -0.018 * view.frame.height),
            cancelButton.widthAnchor.constraint(equalToConstant: 0.061 * view.frame.height),
            cancelButton.heightAnchor.constraint(equalToConstant: 0.061 * view.frame.height)
            ])
        
        cancelButton.addTarget(self, action: #selector(handleCancelTapped), for: [.touchUpInside])
    }
    
    @objc func handleCancelTapped() {
        self.dismiss(animated: true)
    }
    
}

/// Sets up Loading and Success Animations
extension ViewController {
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
    
    func setupErrorAnimation() {
        let animation = Animation.named("error")
        errorAnimation.animation = animation
        errorAnimation.contentMode = .scaleAspectFit
        view.addSubview(errorAnimation)
        
        errorAnimation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorAnimation.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorAnimation.widthAnchor.constraint(equalToConstant: view.frame.width * 0.5),
            errorAnimation.heightAnchor.constraint(equalToConstant: view.frame.width * 0.5)
            ])
    }
}


/// Registration and Handling for foreground/background entry/exit
extension ViewController {
    private func setupBackgroundForegroundNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        cloudsAnimation.pause()
    }
    
    @objc func appMovedToForeground() {
        cloudsAnimation.play()
    }
}


/// TextFieldShouldReturn
extension ViewController{
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if serviceField.hasText && usernameField.hasText && passwordField.hasText {
            textField.resignFirstResponder()
        } else {
            switch textField {
            case serviceField:
                if currentSuggestion.count > 0 {
                    serviceField.text = currentSuggestion
                }
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
}
