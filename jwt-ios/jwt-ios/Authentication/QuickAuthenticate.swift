//
//  QuickAuthenticate.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 3/5/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import UIKit

/// Quickly grabs a new access or refresh token so that user's experience isn't hindered. This is normal since the tokens constantly expire.
extension UINavigationController {
    func signout() {
        self.popToRootViewController(animated: true)
        deleteUserCredentials()
        revokeAuthTokens()
    }
    
    /// Call when network raises authentication error
    func getNewAccessToken(_ networkManager: AuthNetworkManager) {
        networkManager.access() { response, error in
            if error != nil {
                // Refresh token is expired?
                self.getNewRefreshToken(networkManager)
            }
            // Response is handled by the Manager which will input the new access token into the Keychain
        }
    }
    
    func getNewRefreshToken(_ networkManager: AuthNetworkManager) {
        networkManager.both() { response, error in
            if let error = error {
                switch error {
                case NetworkResponse.authenticationError.rawValue:
                    // If it's an authentication failure, we redirect user to LoginViewController BUT basically pop to that initial login.
                    self.signout()
                    print(error)
                default:
                    // If it's a network error, then we show it in a BannerNotificationSwift thing
                    print(error)
                }
            }
            // Response is handled by the Manager which will input the new access token into the Keychain
        }
    }
}
