//
//  PingApiResponse.swift
//  jwt-ios
//
//  Created by Andrew Chen Wang on 5/11/20.
//  Copyright © 2020 Andrew Chen Wang. All rights reserved.
//

import Foundation

struct PingApiResponse: Decodable {
    let id: Int?

    private enum CodingKeys: String, CodingKey {
        case id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decodeIfPresent(Int.self, forKey: .id)
    }
}
