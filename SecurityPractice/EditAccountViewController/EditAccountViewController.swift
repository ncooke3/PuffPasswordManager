//
//  EditAccountViewController.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/18/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

class EditAccountViewController: UIViewController, UITextFieldDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Passed from MainViewController
    var selectedAccount: Account?
    
    let blurView = UIVisualEffectView()
    var cardView = UIView()
    let usernameField = UITextField()
    let passwordField = UITextField()
    let saveButton = RoundButton()
    let copyUsernameButton = RoundButton()
    let copyPasswordButton = RoundButton()
    
    var cancelButton: AddAccountButton = {
        let button = AddAccountButton()
        button.backgroundColor = Color.brightYarrow.value
        button.translatesAutoresizingMaskIntoConstraints = false
        button.value = "x"
        return button
    }()
    
    var serviceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProRounded-Medium", size: 36)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let highlightedImage: UIImage = {
        let image = UIImage(named: "copy_icon.png")
        image?.sd_tintedImage(with: .white)
        return image!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBlurView()
        setupCancelButton()
        setupCardView(brandColor: CompanyDefaults.companies[selectedAccount!.service]?.color)
        setupServiceLabel()
        setupUsernameTextfield()
        setupPasswordTextField()
        setupCopyUsernameButton()
        setupCopyPasswordButton()
        setupSaveButton()
    }
}

/// Handles View Setup
extension EditAccountViewController {
    
    private func setupCardView(brandColor : String?) {
        cardView.layer.cornerRadius = 20
        if let colorString = brandColor {

            cardView.layer.backgroundColor = Color.custom(hexString: colorString, alpha: 1).value.cgColor
        } else {
            cardView.layer.backgroundColor = Color.electronBlue.value.cgColor
        }
        cardView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -0.061 * view.frame.height),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 0.461 * view.frame.height),
            cardView.widthAnchor.constraint(equalToConstant: 0.412 * view.frame.height)
            ])
    }
    
    private func setupBlurView() {
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        blurView.effect = UIBlurEffect(style: .regular)
    }
    
    
    private func setupServiceLabel() {
        cardView.addSubview(serviceLabel)
        serviceLabel.text = selectedAccount?.service
        NSLayoutConstraint.activate([
            serviceLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 0.061 * view.frame.height),
            serviceLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
        ])
    }
    
    private func setupUsernameTextfield() {
        usernameField.delegate = self
        
        usernameField.placeholder = "Username"
        usernameField.text = selectedAccount?.username
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.backgroundColor = .white
        usernameField.textColor = Color.soothingBreeze.value
        
        usernameField.tintColor = Color.soothingBreeze.value
        usernameField.setIcon(#imageLiteral(resourceName: "icon-user"))
        usernameField.isEnabled = false
        usernameField.layer.cornerRadius = 7.0
        usernameField.layer.borderColor = UIColor.white.cgColor
        usernameField.layer.borderWidth = 1.0
        
        cardView.addSubview(usernameField)
        
        NSLayoutConstraint.activate([
            usernameField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 0.018 * view.frame.height),
            usernameField.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: -0.030 * view.frame.height),
            usernameField.widthAnchor.constraint(equalToConstant: 0.307 * view.frame.height),
            usernameField.heightAnchor.constraint(equalToConstant: 0.049 * view.frame.height)
            ])
    }
    
    private func setupPasswordTextField() {
        passwordField.delegate = self
        passwordField.placeholder = "Password"
        passwordField.text = selectedAccount?.getPasswordFromStore()
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.backgroundColor = .white
        passwordField.textColor = Color.soothingBreeze.value
        passwordField.isEnabled = false
        passwordField.tintColor = Color.soothingBreeze.value
        passwordField.setIcon(#imageLiteral(resourceName: "icon-lock"))
        
        passwordField.layer.cornerRadius = 7.0
        passwordField.layer.borderColor = UIColor.white.cgColor
        passwordField.layer.borderWidth = 1.0
        
        cardView.addSubview(passwordField)
        
        NSLayoutConstraint.activate([
            passwordField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 0.018 * view.frame.height),
            passwordField.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: 0.092 * view.frame.height),
            passwordField.widthAnchor.constraint(equalToConstant: 0.307 * view.frame.height),
            passwordField.heightAnchor.constraint(equalToConstant: 0.049 * view.frame.height)
            ])
    }
}

/// Handles Cancel and Save Buttons
extension EditAccountViewController {
    
    private func setupCancelButton() {
        cancelButton.addTarget(self, action: #selector(handleCancelTapped), for: [.touchUpInside])
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0.018 * view.frame.height),
            cancelButton.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -0.018 * view.frame.height),
            cancelButton.widthAnchor.constraint(equalToConstant: 0.061 * view.frame.height),
            cancelButton.heightAnchor.constraint(equalToConstant: 0.061 * view.frame.height)
            ])
    }
    
    @objc func handleCancelTapped() {
        self.dismiss(animated: true, completion: {
            globalMainViewController?.tableView.reloadData()
        })
    }
    
    private func setupSaveButton() {
        saveButton.setTitle("Edit", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "SFProRounded-Medium", size: 17)
        saveButton.backgroundColor = Color.brightYarrow.value
        saveButton.addTarget(self, action: #selector(handleSaveTapped), for: .touchUpInside)
        saveButton.sizeToFit()
        
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 0.024 * view.frame.height)
            ])
    }
    
    @objc func handleSaveTapped() {
        let newTitle = saveButton.titleLabel!.text == "Edit" ? "Save" : "Edit"
        saveButton.setTitle(newTitle, for: .normal)
        if saveButton.titleLabel!.text == "Save" {
            passwordField.isEnabled = true
            passwordField.textColor = UIColor.black
            
        } else {
            guard selectedAccount != nil else { return }
            if let newPassword = passwordField.text {
                if newPassword != selectedAccount?.getPasswordFromStore() {
                    selectedAccount?.setPasswordInStore(newPassword: newPassword)
                }
            }
            passwordField.isEnabled = false
            passwordField.textColor = UIColor.lightGray
        }
    }
}

/// Handles Username/Password Copy Buttons
extension EditAccountViewController {
    
    private func setupCopyUsernameButton() {
        copyUsernameButton.setImage(UIImage(named: "copy_icon.png"), for: .normal)
        copyUsernameButton.setImage(highlightedImage, for: .highlighted)
        copyUsernameButton.setTitle("Copy", for: .normal)
        copyUsernameButton.titleLabel?.font = UIFont(name: "SFProRounded-Medium", size: 17)
        copyUsernameButton.backgroundColor = Color.brightYarrow.value
        copyUsernameButton.addTarget(self, action: #selector(handleCopyUsername), for: .touchUpInside)
        copyUsernameButton.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(copyUsernameButton)
        NSLayoutConstraint.activate([
            copyUsernameButton.centerYAnchor.constraint(equalTo: usernameField.centerYAnchor),
            copyUsernameButton.leadingAnchor.constraint(equalTo: usernameField.trailingAnchor, constant: 5),
            copyUsernameButton.widthAnchor.constraint(equalToConstant: 0.133 * view.frame.width),
            copyUsernameButton.heightAnchor.constraint(equalTo: usernameField.heightAnchor)
            ])
    }
    
    private func setupCopyPasswordButton() {
        copyPasswordButton.setImage(UIImage(named: "copy_icon.png"), for: .normal)
        copyPasswordButton.setImage(highlightedImage, for: .highlighted)
        copyPasswordButton.setTitle("Copy", for: .normal)
        copyPasswordButton.titleLabel?.font = UIFont(name: "SFProRounded-Medium", size: 17)
        copyPasswordButton.backgroundColor = Color.brightYarrow.value
        copyPasswordButton.addTarget(self, action: #selector(handleCopyPassword), for: .touchUpInside)
        copyPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(copyPasswordButton)
        NSLayoutConstraint.activate([
            copyPasswordButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor),
            copyPasswordButton.leadingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: 5),
            copyPasswordButton.widthAnchor.constraint(equalToConstant: 0.133 * view.frame.width),
            copyPasswordButton.heightAnchor.constraint(equalTo: passwordField.heightAnchor)
            ])
    }
    
    @objc func handleCopyUsername() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = usernameField.text
    }
    
    @objc func handleCopyPassword() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = passwordField.text
    }
}


class CardView: UIView {
    
    let containerView = UIView()
    let cornerRadius: CGFloat = 6.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = Color.custom(hexString: "#6c5ce7", alpha: 1.0).value
        
        addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}
