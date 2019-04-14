//
//  Storage.swift
//  Dash
//
//  Created by Jolyn Tan on 11/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

struct Storage {
    var missionCheckpoint: String?

    // TODO: different mission types
    static func saveMissionCheckpoint(for missionType: MissionType, with message: String) {
        UserDefaults.standard.set(message, forKey: "mission")
    }

    static func getMissionCheckpoint(for missionType: MissionType) -> String? {
        return UserDefaults.standard.value(forKey: "mission") as? String
    }
}
