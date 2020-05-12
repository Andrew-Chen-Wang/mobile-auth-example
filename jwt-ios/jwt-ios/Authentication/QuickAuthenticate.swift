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
}
