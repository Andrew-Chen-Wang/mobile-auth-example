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
        // Go to sign in page.
        self.popToRootViewController(animated: true)
        deleteUserCredentials()
        revokeAuthTokens()
    }
    
    /// Call when network raises authentication error
    func getNewAccessToken(_ completion: @escaping (_ success: Bool) -> ()) {
        AuthNetworkManager().access() { response, error in
            if error != nil {
                // Refresh token is expired?
                self.getNewRefreshToken({ success in
                    completion(success)
                })
            } else {
                completion(true)
            }
            // Response is handled by the Manager which will input the new access token into the Keychain
        }
    }
    
    func getNewRefreshToken(_ completion: @escaping (_ success: Bool) -> ()) {
        AuthNetworkManager().both() { response, error in
            if let error = error {
                switch error {
                case NetworkResponse.authenticationError.rawValue:
                    // If it's an authentication failure, we redirect user to LoginViewController BUT basically pop to that initial login.
//                    self.signout()
                    completion(false)
                    print(error)
                default:
                    // If it's a network error, then we show it in a BannerNotificationSwift thing
                    print(error)
                }
            } else {
                completion(true)
            }
            // Response is handled by the Manager which will input the new access token into the Keychain
        }
    }
}
