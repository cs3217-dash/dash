//
//  Action.swift
//  Dash
//
//  Created by Ang YC on 29/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class Action: GamePayload {
    var time: Double
    var type: ActionType
    var value = 0.0

    init(time: Double, type: ActionType) {
        self.time = time
        self.type = type
        super.init()
    }

    private enum CodingKeys: String, CodingKey {
        case time
        case type
        case value
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.time = try values.decode(Double.self, forKey: .time)
        self.type = try values.decode(ActionType.self, forKey: .type)
        self.value = try values.decode(Double.self, forKey: .value)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(time, forKey: .time)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(value, forKey: .value)
    }
}
