//
//  Authentication.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 3/2/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import Foundation

// MARK: User Credentials
// I actually usually use KeychainAccess https://github.com/kishikawakatsumi/KeychainAccess/ for larger apps

/// THIS FUNCTIONALITY IS FOR TESTING PURPOSES, and it SHOULD NOT BE USED in production. Use shared web credentials.
func saveUserCredentials(username: String, password: String) {
    // This shouldn't be used for production. Use a KeychainWrapper online that supports shared web credentials
    KeychainWrapper.standard.set(username, forKey: "username")
    KeychainWrapper.standard.set(password, forKey: "password")
}

func getUserCredentials() -> (String?, String?) {
    return (KeychainWrapper.standard.string(forKey: "username"), KeychainWrapper.standard.string(forKey: "password"))
}

func deleteUserCredentials() {
    let _ = KeychainWrapper.standard.removeAllKeys()
}

// MARK: Auth tokens

enum AuthToken {
    case access
    case refresh
}

func saveAuthToken(_ token: AuthToken, _ string: String) {
    switch token {
    case .access:
        KeychainWrapper.standard.set(string, forKey: "jwtAccess")
    case .refresh:
        KeychainWrapper.standard.set(string, forKey: "jwtRefresh")
    }
}

/// Get token from keychain
func getAuthToken(_ token: AuthToken) -> String {
    switch token {
    case .access:
        if let text = KeychainWrapper.standard.string(forKey: "jwtAccess") {
            return text
        }
    case .refresh:
        if let text = KeychainWrapper.standard.string(forKey: "jwtRefresh") {
            return text
        }
    }
    return ""
}

/// Use this when a user signs out. There is no revoke method on the server side, but at least the client is not vulnerable.
func revokeAuthTokens() {
    KeychainWrapper.standard.removeObject(forKey: "jwtAccess")
    KeychainWrapper.standard.removeObject(forKey: "jwtRefresh")
}
