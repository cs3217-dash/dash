//
//  Storage.swift
//  Dash
//
//  Created by Jolyn Tan on 11/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

struct Storage {

    static func saveMissionCheckpoint(_ value: Int, forMissionType missionType: MissionType) {
        UserDefaults.standard.set(value, forKey: "mission-\(missionType)")
    }

    static func getMissionCheckpoint(forMissionType missionType: MissionType) -> Int? {
        return UserDefaults.standard.value(forKey: "mission-\(missionType)") as? Int
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
