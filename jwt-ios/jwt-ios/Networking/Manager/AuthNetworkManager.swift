//
//  AuthNetworkManager.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 3/3/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import Foundation

struct AuthNetworkManager {
    static let environment: NetworkEnvironment = .local
    let router = Router<AuthAPI>()
    let networkConnErrorMsg = "Please check your network connection."

    // MARK: Request Functions
    
    func access(completion: @escaping (_ auth: AuthApiResponse?, _ error: String?) -> ()) {
        router.request(.access) { data, response, error in
            
            if error != nil {
                completion(nil, self.networkConnErrorMsg)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        // IMPORTANT. You can change that AuthApiResponse to whatever you want so you don't clutter all your responses in one struct
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(AuthApiResponse.self, from: responseData)
                        print(apiResponse)
                        saveAuthToken(.access, apiResponse.access)
                        completion(nil, nil)
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }

                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func both(completion: @escaping (_ auth: AuthApiResponse?, _ error: String?) -> ()) {
        router.request(.both) { data, response, error in
            
            if error != nil {
                completion(nil, self.networkConnErrorMsg)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(AuthApiResponse.self, from: responseData)
                        saveAuthToken(.access, apiResponse.access)
                        saveAuthToken(.refresh, apiResponse.refresh!)
                        completion(nil, nil)
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }

                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func ping(id: Int, completion: @escaping (_ auth: PingApiResponse?, _ error: String?) -> ()) {
        router.request(.ping(id: id)) { data, response, error in
            
            if error != nil {
                completion(nil, self.networkConnErrorMsg)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(PingApiResponse.self, from: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }

                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
}
