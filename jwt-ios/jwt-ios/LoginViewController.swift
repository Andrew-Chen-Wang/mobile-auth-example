//
//  LoginViewController.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 3/2/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let usernameField = UITextField()
    let passwordField = UITextField()
    let submitButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.placeholder = "Username"
        usernameField.borderStyle = .roundedRect
        usernameField.textContentType = .username
        usernameField.autocorrectionType = .no
        usernameField.autocapitalizationType = .none
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Login", for: .normal)
        submitButton.backgroundColor = .systemGreen
        submitButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        submitButton.tintColor = .white
        
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(submitButton)
        
        view.layoutMargins = .init(top: 10, left: 20, bottom: 30, right: 20)
        let lg = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            usernameField.topAnchor.constraint(equalTo: lg.topAnchor),
            usernameField.leadingAnchor.constraint(equalTo: lg.leadingAnchor),
            usernameField.trailingAnchor.constraint(equalTo: lg.trailingAnchor),
            
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: lg.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: lg.trailingAnchor),
            
            submitButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 40),
            submitButton.leadingAnchor.constraint(equalTo: lg.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: lg.trailingAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func login(sender: UIButton!) {
        saveUserCredentials(username: usernameField.text ?? "", password: passwordField.text ?? "")
        AuthNetworkManager().both() { response, error in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    // Pass the network manager so that we don't keep instantiating it.
                    self.navigationController?.pushViewController(ViewController(), animated: true)
                }
            }
        }
    }
}
