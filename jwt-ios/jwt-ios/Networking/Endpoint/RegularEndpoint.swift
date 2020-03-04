//
//  RegularEndpoint.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 3/3/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import Foundation

public enum RegularAPI {
    case ping(id:Int)
    case whatever
}

extension RegularAPI: EndPointType {
    var httpMethod: HTTPMethod {
        switch self {
        case .ping:
            return .get
        case .whatever:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default:
            // For authentication purposes when doing any request besides login, register, and getting the tokens themselves.
            // MARK: IMPORTANT
            // Usually, I'll have many Endpoints. In that case, instead of a switch case, you should just return nil
            return [
                "Authorization": "Bearer \(getAuthToken(.access))"
            ]
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: "http://127.0.0.1:8000/") else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .ping(let id):
            return "ping/\(id)"
        case .whatever:
            return "whatever"
        }
    }
    
    var task: HTTPTask {
        switch self {
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
