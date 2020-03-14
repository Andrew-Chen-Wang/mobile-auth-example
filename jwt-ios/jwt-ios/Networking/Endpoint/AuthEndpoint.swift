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
    case both  // This is essentially logging in since simplejwt automatically checks for authentication https://github.com/davesque/django-rest-framework-simplejwt/blob/master/rest_framework_simplejwt/serializers.py#L33. Returns 401 code if incorrect credentials
    
    // Other API stuff
    case ping(id: Int)
    case whatever
}

extension AuthAPI: EndPointType {
    var environmentBaseURL : String {
        switch AuthNetworkManager.environment {
        case .local: return "http://127.0.0.1:8000/api/"
        // Return your actual domain
        case .staging: return "https://staging.themoviedb.org/3/movie/"
        case .production: return "https://api.themoviedb.org/3/movie/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .register, .access, .both:
            return .post
        default:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .register, .access, .both:
            // Authentication does not need Bearer token for authentication
            return nil
        default:
            return ["Authorization": "Bearer \(getAuthToken(.access))"]
        }
    }
    
    var path: String {
        // The path for api/ is already in baseURL
        switch self {
        case .register:
            return "accounts/register/"
        case .access:
            return "token/access/"
        case .both:
            return "token/both/"
        case .ping:
            return "ping/"
        case .whatever:
            return "whatever/"
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
        case .ping(let id):
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: [
                    "id": id
                ]
            )
        default:
            return .request
        }
    }
}
