//
//  AuthApiResponse.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 3/3/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import Foundation

struct AuthApiResponse: Decodable {
    let access: String
    let refresh: String?
    
    private enum CodingKeys: String, CodingKey {
        case access
        case refresh
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        access = try container.decode(String.self, forKey: .access)
        refresh = try? container.decodeIfPresent(String.self, forKey: .refresh)
    }
}
