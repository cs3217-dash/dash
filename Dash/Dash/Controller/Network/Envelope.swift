//
//  Envelope.swift
//  Dash
//
//  Created by Ang YC on 8/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class Envelope<T: Codable>: Codable {
    var peerID: String
    var payload: T

    init(_ peerID: String, _ payload: T) {
        self.peerID = peerID
        self.payload = payload
    }

    private enum CodingKeys: String, CodingKey {
        case peerID
        case payload
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.peerID = try values.decode(String.self, forKey: .peerID)
        self.payload = try values.decode(T.self, forKey: .payload)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(peerID, forKey: .peerID)
        try container.encode(payload, forKey: .payload)
    }
}
