//
//  Storage.swift
//  Dash
//
//  Created by Jolyn Tan on 11/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

struct Storage {

    private init() {}

    static func saveMissionCheckpoint(_ value: Int, forMissionType missionType: MissionType) {
        UserDefaults.standard.set(value, forKey: "mission-\(missionType)")
    }

    static func getMissionCheckpoint(forMissionType missionType: MissionType) -> Int {
        let key = "mission-\(missionType)"

        guard let checkpoint = UserDefaults.standard.value(forKey: key) as? Int else {
            switch missionType {
            case .distance:
                return MissionConfig.initialDistanceCheckpoint
            case .powerUp:
                return MissionConfig.initialPowerUpCheckpoint
            case .coin:
                return MissionConfig.initialCoinCheckpoint
            }
        }

        return checkpoint
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
