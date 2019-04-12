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

    static func saveMissionCheckpoint(message: String) {
        UserDefaults.standard.set(message, forKey: "mission")
    }

    static func getMissionCheckpoint() -> String? {
        return UserDefaults.standard.value(forKey: "mission") as? String
    }
}
