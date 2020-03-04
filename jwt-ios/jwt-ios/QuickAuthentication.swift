//
//  QuickAuthentication.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 3/3/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import UIKit

/*
 https://stackoverflow.com/questions/48707059/login-sign-up-via-uialertcontroller
 DispatchQueue.main.async {
    self.present(alertController, animated: true, completion: nil)
}
 */

class QuickAuthenticationController: UIAlertController {
    var networkManager: AuthNetworkManager!
    init(networkManager: AuthNetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.networkManager = networkManager
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func signout() {
        navigationController?.popToRootViewController(animated: true)
        deleteUserCredentials()
        revokeAuthTokens()
    }
    
    func quickAuthenticate(_ retryCount: Int) {
        // Maybe the user changed their password, so we should quick authenticate so that current progress is not lost but usr only gets 3 shots
        let alertController = UIAlertController(title: "Quick login", message: "You may have changed your password, so quickly login to not lose your current progress! You have \(3 - retryCount) attempt(s) left.", preferredStyle: .alert)
        alertController.addTextField{
            $0.placeholder = "Username"
        }
        alertController.addTextField{
            $0.placeholder = "Password"
            $0.isSecureTextEntry = true
            
        }
        
        let signoutAction = UIAlertAction(title: "Logout", style: .cancel) { (_) in
            self.signout()
        }
        let loginAction = UIAlertAction(title: "Login", style: .default) { (_) in
            let username = alertController.textFields?[0].text ?? ""
            let password = alertController.textFields?[1].text ?? ""
            saveUserCredentials(username: username, password: password)
            
            self.networkManager.both(completion: { response, error in
                if error != nil {
                    if retryCount == 2 {
                        self.signout()
                    } else {
                        self.quickAuthenticate(retryCount + 1)
                    }
                } else {
                    self.dismiss(animated: true)
                }
            })
        }
        
        alertController.addAction(signoutAction)
        alertController.addAction(loginAction)
    }
}
