//
//  AuthEndpoint.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 3/2/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import Foundation

public enum AuthAPI {
    // We don't actually have registration setup on the server
    // We don't need password listed twice. Pw validation should happen client side unless you want to be lazy like me and use NotificationBannerSwift and show the errors as strings there
    case register(username: String, email: String, password: String)
    case access
    case both  // This is essentially logging in since simpletjwt automatically checks for authentication https://github.com/davesque/django-rest-framework-simplejwt/blob/master/rest_framework_simplejwt/serializers.py#L33
}

extension AuthAPI: EndPointType {
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var headers: HTTPHeaders? {
        // Check out IMPORTANT note in RegularEndpoint.swift
        return nil
    }
    
    var baseURL: URL {
        guard let url = URL(string: "http://127.0.0.1:8000/") else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .register:
            return "api/accounts/register/"
        case .access:
            return "api/token/access/"
        case .both:
            return "api/token/both/"
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .register(let username, let email, let password):
            return .requestParameters(
                bodyParameters: [
                    "username": username,
                    "email": email,
                    "password": password
                ],
                bodyEncoding: .jsonEncoding,
                urlParameters: nil
            )
        case .access:
            return .requestParameters(
                bodyParameters: [
                    "refresh": getAuthToken(.refresh)
                ],
                bodyEncoding: .jsonEncoding,
                urlParameters: nil
            )
        case .both:
            let (user, pw) = getUserCredentials()
            return .requestParameters(
                bodyParameters: [
                    "username": user ?? "",
                    "password": pw ?? ""
                ],
                bodyEncoding: .jsonEncoding,
                urlParameters: nil
            )
//        default:
//            return .request
        }
    }
}
