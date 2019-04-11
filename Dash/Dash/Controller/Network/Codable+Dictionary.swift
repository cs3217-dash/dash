//
//  Codable+Dictionary.swift
//  Dash
//
//  Created by Ang YC on 8/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

extension Decodable {
    init?(dict: [String: Any]) {
        let decoder = JSONDecoder()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let decoded = try? decoder.decode(Self.self, from: jsonData) else {
                return nil
        }
        self = decoded
    }
}
