//
//  MissionConfig.swift
//  Dash
//
//  Created by Jolyn Tan on 20/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class MissionConfig {
    static let initialDistanceCheckpoint = 500
    static let initialPowerUpCheckpoint = 1
    static let initialCoinCheckpoint = 10

    static let distanceOffset = 500
    static let powerUpOffset = 2
    static let coinOffset = 10

    static func message(for value: Int, missionType: MissionType) -> String {
        switch missionType {
        case .distance:
            return "Reach \(value)m in one run"
        case .powerUp:
            return "Consume \(value) power ups"
        case .coin:
            return "Collect \(value) coins"
        }
    }
}
