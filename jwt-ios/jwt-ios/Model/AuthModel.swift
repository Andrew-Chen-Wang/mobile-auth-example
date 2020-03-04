//
//  AuthModel.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 3/3/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import Foundation

struct AuthApiResponse {
    let access: String
    let refresh: String
}

extension AuthApiResponse: Decodable {
    private enum AuthApiResponseCodingKeys: String, CodingKey {
        case access
        case refresh
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AuthApiResponseCodingKeys.self)
        
        access = try container.decode(String.self, forKey: .access)
        refresh = try container.decode(String.self, forKey: .refresh)
    }
}
