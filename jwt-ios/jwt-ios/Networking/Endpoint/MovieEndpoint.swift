//
//  MovieEndpoint.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 3/2/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import Foundation

/*
 Why is this file still here? It's a way of understanding how the "endpoint" directory works. I didn't want to call the actual file an "AuthEndpoint.swift" since that'd send the incorrect notion that only the authentication stuff shuold go there when, in reality, a lot of your API calls, if not all, should go there.
 */

public enum MovieApi {
    case recommended(id:Int)
    case popular(page:Int)
    case newMovies(page:Int)
    case video(id:Int)
}

extension MovieApi: EndPointType {
    var environmentBaseURL : String {
        switch MovieNetworkManager.environment {
        case .production: return "https://api.themoviedb.org/3/movie/"
        case .local: return "https://qa.themoviedb.org/3/movie/"
        case .staging: return "https://staging.themoviedb.org/3/movie/"
        }
    }

    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }

    var path: String {
        switch self {
        case .recommended(let id):
            return "\(id)/recommendations"
        case .popular:
            return "popular"
        case .newMovies:
            return "now_playing"
        case .video(let id):
            return "\(id)/videos"
        }
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var task: HTTPTask {
        switch self {
        case .newMovies(let page):
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: [
                    "page": page,
                    "api_key": MovieNetworkManager.MovieAPIKey
                ]
            )
        default:
            return .request
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
