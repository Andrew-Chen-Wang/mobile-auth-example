//
//  ViewController.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 3/2/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let label = UILabel()
    
    var networkManager: RegularNetworkManager!
    init(networkManager: RegularNetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.networkManager = networkManager
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backBarButtonItem?.title = "< Sign Out"

        label.text = "Hello world!"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        // Begining async calling to check if expired or not
        testLogin()
    }
    
    /// Test login against server every second
    func testLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            // Perform ping test
            
            // Re-run function to test login again until it fails
            self.testLogin()
        })
    }
    
    func signout() {
        navigationController?.popToRootViewController(animated: true)
        deleteUserCredentials()
        revokeAuthTokens()
    }
}

extension ViewController: UINavigationBarDelegate {
    // On sign out, we should revoke all tokens. It's up to you if you also want to delete shared web user credentials. For us, we delete all.
    func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        signout()
    }
}
