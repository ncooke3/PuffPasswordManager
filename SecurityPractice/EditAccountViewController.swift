//
//  EditAccountViewController.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/18/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

class EditAccountViewController: UIViewController, UITextFieldDelegate {
    
    let blurView = UIVisualEffectView()
    
    var cardView: UIView!
    
    var serviceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProRounded-Medium", size: 36)
        label.text = "LABEL"
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let usernameField = UITextField()
    let passwordField = UITextField()
    let saveButton = RoundButton()
    let copyUsernameButton = RoundButton()
    let copyPasswordButton = RoundButton()
    
    let highlightedImage: UIImage = {
        let image = UIImage(named: "copy_icon.png")
        image?.sd_tintedImage(with: .white)
        return image!
    }()
    
    

    fileprivate func setupCopyUsernameButton() {
        copyUsernameButton.setImage(UIImage(named: "copy_icon.png"), for: .normal)
        copyUsernameButton.setImage(highlightedImage, for: .highlighted)
        copyUsernameButton.setTitle("Copy", for: .normal)
        copyUsernameButton.titleLabel?.font = UIFont(name: "SFProRounded-Medium", size: 17)
        copyUsernameButton.backgroundColor = Color.brightYarrow.value
        
        cardView.addSubview(copyUsernameButton)
        copyUsernameButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            copyUsernameButton.centerYAnchor.constraint(equalTo: usernameField.centerYAnchor),
            copyUsernameButton.leadingAnchor.constraint(equalTo: usernameField.trailingAnchor, constant: 5),
            copyUsernameButton.widthAnchor.constraint(equalToConstant: 50),
            copyUsernameButton.heightAnchor.constraint(equalTo: usernameField.heightAnchor)
            ])
    }
    
    fileprivate func setupCopyPasswordButton() {
        copyPasswordButton.setImage(UIImage(named: "copy_icon.png"), for: .normal)
        copyPasswordButton.setImage(highlightedImage, for: .highlighted)
        copyPasswordButton.setTitle("Copy", for: .normal)
        copyPasswordButton.titleLabel?.font = UIFont(name: "SFProRounded-Medium", size: 17)
        copyPasswordButton.backgroundColor = Color.brightYarrow.value
        
        cardView.addSubview(copyPasswordButton)
        copyPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            copyPasswordButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor),
            copyPasswordButton.leadingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: 5),
            copyPasswordButton.widthAnchor.constraint(equalToConstant: 50),
            copyPasswordButton.heightAnchor.constraint(equalTo: passwordField.heightAnchor)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBlurView()
        
        cardView = CardView()
        view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 375),
            cardView.widthAnchor.constraint(equalToConstant: 335)
            ])
        

 
        
        saveButton.setTitle("Edit", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "SFProRounded-Medium", size: 17)
        saveButton.backgroundColor = Color.brightYarrow.value
        saveButton.addTarget(self, action: #selector(handleSaveTapped), for: .touchUpInside)
        saveButton.sizeToFit()
        
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 20)
            ])
        
        
        setupServiceLabel()
        setupUsernameTextfield()
        setupPasswordTextField()
        
        setupCopyUsernameButton()
        setupCopyPasswordButton()
        
        
    }
    
    @objc func handleSaveTapped() {
        let newTitle = saveButton.titleLabel!.text == "Edit" ? "Save" : "Edit"
        saveButton.setTitle(newTitle, for: .normal)
        
        if saveButton.titleLabel!.text == "Save" {

            usernameField.isEnabled = true
            usernameField.textColor = UIColor.black
            passwordField.isEnabled = true
            passwordField.textColor = UIColor.black
            
        } else {
            
            // Do save functions!
            
            usernameField.isEnabled = false
            usernameField.textColor = UIColor.gray
            passwordField.isEnabled = false
            passwordField.textColor = UIColor.gray

        }
    }
    
    func setupServiceLabel() {
        cardView.addSubview(serviceLabel)
        NSLayoutConstraint.activate([
            serviceLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 50),
            serviceLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
        ])
    }
    
    func setupBlurView() {
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        blurView.effect = UIBlurEffect(style: .regular)
    }
    
    fileprivate func setupUsernameTextfield() {
        usernameField.delegate = self
        
        usernameField.placeholder = "Username"
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.backgroundColor = .white
        
        usernameField.tintColor = Color.soothingBreeze.value
        usernameField.setIcon(#imageLiteral(resourceName: "icon-user"))
        
        usernameField.layer.cornerRadius = 7.0
        usernameField.layer.borderColor = UIColor.white.cgColor
        usernameField.layer.borderWidth = 1.0
        
        cardView.addSubview(usernameField)
        
        NSLayoutConstraint.activate([
            usernameField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            usernameField.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: -25),
            usernameField.widthAnchor.constraint(equalToConstant: 250),
            usernameField.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    fileprivate func setupPasswordTextField() {
        passwordField.delegate = self
        passwordField.placeholder = "Password"
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.backgroundColor = .white
        
        passwordField.tintColor = Color.soothingBreeze.value
        passwordField.setIcon(#imageLiteral(resourceName: "icon-lock"))
        
        passwordField.layer.cornerRadius = 7.0
        passwordField.layer.borderColor = UIColor.white.cgColor
        passwordField.layer.borderWidth = 1.0
        
        cardView.addSubview(passwordField)
        
        NSLayoutConstraint.activate([
            passwordField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            passwordField.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: 75),
            passwordField.widthAnchor.constraint(equalToConstant: 250),
            passwordField.heightAnchor.constraint(equalToConstant: 40)
        ])
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
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        
        // set the cornerRadius of the containerView's layer
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = Color.custom(hexString: "#6c5ce7", alpha: 1.0).value
        
        addSubview(containerView)
        
        //
        // add additional views to the containerView here
        //
        
        // add constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    

    fileprivate func setupSaveButton() {
        //saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

    }
    
}
