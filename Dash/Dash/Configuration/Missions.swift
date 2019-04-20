//
//  Mission.swift
//  Dash
//
//  Created by Jolyn Tan on 20/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class Missions {
    static func messageForValue(_ value: Int, missionType: MissionType) -> String {
        switch missionType {
        case .distance:
            return "Reach \(value)m in one run"
        case .powerUp:
            return "Consume \(value) power ups"
        case .coin:
            return "Collect \(value) coins"
        }
    }

    static func defaultMessage(for missionType: MissionType) -> String {
        switch missionType {
        case .distance:
            return "Reach 500m in one run"
        case .powerUp:
            return "Consume 1 power up"
        case .coin:
            return "Collect 10 coins"
        }
    }
}
