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
        UserDefaults.standard.set(message, forKey: "mission-\(missionType)")
    }

    static func getMissionCheckpoint(for missionType: MissionType) -> String? {
        return UserDefaults.standard.value(forKey: "mission-\(missionType)") as? String
    }

    static func saveLocalHighScore(_ highscores: [HighScoreRecord],
                                   forCategory category: HighScoreCategory) {
        let serialized = highscores.compactMap { $0.dictionary }
        UserDefaults.standard.set(serialized, forKey: "highscores-\(category)")
    }

    static func getLocalHighScore(
        forCategory category: HighScoreCategory) -> [HighScoreRecord] {
            guard let dictArray = UserDefaults.standard.value(
                forKey: "highscores-\(category)") as? [[String: Any]] else {
                    return []
            }
            let records = dictArray.compactMap { HighScoreRecord(dict: $0) }
            return records
    }
}
