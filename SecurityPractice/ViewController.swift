//
//  ViewController.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 7/31/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    fileprivate func createServiceTextfield() {
        let serviceField = UITextField()
        serviceField.delegate = self
        serviceField.placeholder = "Service"
        serviceField.translatesAutoresizingMaskIntoConstraints = false
        serviceField.backgroundColor = .white
        serviceField.setLeftAndRightPadding(amount: 20)
        
        serviceField.layer.cornerRadius = 7.0
        serviceField.layer.borderColor = UIColor.gray.cgColor
        serviceField.layer.borderWidth = 1.0
        
        view.addSubview(serviceField)
        
        NSLayoutConstraint.activate([
            serviceField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            serviceField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            serviceField.widthAnchor.constraint(equalToConstant: 250),
            serviceField.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    fileprivate func createUsernameTextfield() {
        let usernameField = UITextField()
        usernameField.delegate = self
        usernameField.placeholder = "Username"
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.backgroundColor = .white
        usernameField.setLeftAndRightPadding(amount: 20)
        
        usernameField.layer.cornerRadius = 7.0
        usernameField.layer.borderColor = UIColor.gray.cgColor
        usernameField.layer.borderWidth = 1.0
        
        view.addSubview(usernameField)
        
        NSLayoutConstraint.activate([
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            usernameField.widthAnchor.constraint(equalToConstant: 250),
            usernameField.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    fileprivate func createPasswordTextField() {
        let passwordField = UITextField()
        passwordField.delegate = self
        passwordField.placeholder = "Password"
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.backgroundColor = .white
        passwordField.setLeftAndRightPadding(amount: 20)
        
        passwordField.layer.cornerRadius = 7.0
        passwordField.layer.borderColor = UIColor.gray.cgColor
        passwordField.layer.borderWidth = 1.0
        
        view.addSubview(passwordField)
        
        NSLayoutConstraint.activate([
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordField.widthAnchor.constraint(equalToConstant: 250),
            passwordField.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        setupHideKeyboardOnTap()
        createServiceTextfield()
        createUsernameTextfield()
        createPasswordTextField()
    }


}

extension UITextField {
    
    func setLeftAndRightPadding(amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}

extension UIViewController {
    
    /// Dismisses open keyboards by tapping anywhere in vc
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        
        self.navigationController?.navigationBar
            .addGestureRecognizer(self.endEditingRecognizer())
    }
    
    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    /// Dismisses keyboard when 'return' is tapped
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return false
    }
}
