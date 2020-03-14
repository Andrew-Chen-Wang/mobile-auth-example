//
//  AuthApiResponse.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 3/3/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import Foundation

// IMPORTANT. You can change that AuthApiResponse to whatever you want so you don't clutter all your responses in one struct. You WANT to have multiple responses. I just had one since I'm lazy and there weren't that many things here. What'd I do is have an AuthApiResponse with access and refresh and a dedicated one for ping

struct AuthApiResponse {
    let access: String?
    let refresh: String?
    let id: Int? // Part of the ping path; server returns some random id
}

extension AuthApiResponse: Decodable {
    private enum AuthApiResponseCodingKeys: String, CodingKey {
        case access
        case refresh
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AuthApiResponseCodingKeys.self)
        
        access = try? container.decodeIfPresent(String.self, forKey: .access)
        refresh = try? container.decodeIfPresent(String.self, forKey: .refresh)
        id = try? container.decodeIfPresent(Int.self, forKey: .id)
    }
}
