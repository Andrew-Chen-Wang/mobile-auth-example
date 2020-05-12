//
//  Router.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 3/2/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import UIKit

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                // Handle intercepting
                if let response = response as? HTTPURLResponse {
                    let result = handleNetworkResponse(response)
                    switch result {
                    case .success:
                        completion(data, response, error)
                    case .failure(let networkResponseError):
                        if networkResponseError == NetworkResponse.authenticationError.rawValue && ![AuthAPI.access.path, AuthAPI.both.path].contains(route.path) {
                            // This combines both the refreshing and getting both new tokens
                            AuthNetworkManager().access() { _, accessError in
                                if accessError == nil {
                                    self.request(route, completion: completion)
                                } else {
                                    AuthNetworkManager().both() { _, bothError in
                                        if let bothError = bothError {
                                            switch bothError {
                                            case NetworkResponse.authenticationError.rawValue:
                                                DispatchQueue.main.async {
                                                    (UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController as! UINavigationController).signout()
                                                }
                                            default:
                                                completion(data, response, error)
                                            }
                                        } else {
                                            self.request(route, completion: completion)
                                        }
                                    }
                                }
                            }
                        } else {
                            completion(data, response, error)
                        }
                    }
                }
            })
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(
            url: route.baseURL.appendingPathComponent(route.path),
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0
        )
        if let headers = route.headers {
            for (header, value) in headers {
                request.setValue(value, forHTTPHeaderField: header)
            }
        }
        request.httpShouldHandleCookies = false
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {   
            case .requestParameters(
                let bodyParameters,
                let bodyEncoding,
                let urlParameters):
                
                try self.configureParameters(
                    bodyParameters: bodyParameters,
                    bodyEncoding: bodyEncoding,
                    urlParameters: urlParameters,
                    request: &request
                )
                
            case .requestParametersAndHeaders(
                let bodyParameters,
                let bodyEncoding,
                let urlParameters,
                let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(
                    bodyParameters: bodyParameters,
                    bodyEncoding: bodyEncoding,
                    urlParameters: urlParameters,
                    request: &request
                )
            default:
                return request
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(
        bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        request: inout URLRequest
    ) throws {
        do {
            try bodyEncoding.encode(
                urlRequest: &request,
                bodyParameters: bodyParameters,
                urlParameters: urlParameters
            )
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}
