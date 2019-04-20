//
//  MissionsManager.swift
//  Dash
//
//  Created by Jolyn Tan on 11/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

// Detects and handles mission completion
class MissionManager: Observer {
    var missionCheckpointList: [MissionType: Int]
    var mission: Mission

    init(mission: Mission) {
        self.mission = mission
        self.missionCheckpointList = [
            .distance: 500, // TODO: get checkpoint from storage
            .powerUp: 1,
            .coin: 10
        ]
    }

    func onValueChanged(name: String, object: Any?) {
        guard let value = object as? Int else {
            return
        }
        switch name {
        case "distance":
            checkMissionCompletion(for: .distance, value: value)
        case "powerUpCount":
            checkMissionCompletion(for: .powerUp, value: value)
        case "coinCount":
            checkMissionCompletion(for: .coin, value: value)
        default:
            return
        }
    }

    private func hasPassedCheckpoint(for missionType: MissionType, value: Int) -> Bool {
        guard let checkpoint = missionCheckpointList[missionType] else {
            return false
        }
        return value >= checkpoint
    }

    private func checkMissionCompletion(for missionType: MissionType, value: Int) {
        guard hasPassedCheckpoint(for: missionType, value: value) else {
            return
        }
        let checkpoint = missionCheckpointList[missionType] ?? 0
        let message = Missions.messageForValue(checkpoint, missionType: missionType)
        mission.message = message

        let nextCheckpoint = nextCheckpointValue(for: missionType)
        missionCheckpointList[missionType] = nextCheckpoint

        Storage.saveMissionCheckpoint(nextCheckpoint, forMissionType: missionType)
    }

    private func nextCheckpointValue(for missionType: MissionType) -> Int {
        var currentCheckpoint: Int
        var nextCheckpoint: Int

        switch missionType {
        case .distance:
            currentCheckpoint = missionCheckpointList[.distance] ?? 0
            nextCheckpoint = currentCheckpoint + 500
        case .powerUp:
            currentCheckpoint = missionCheckpointList[.powerUp] ?? 0
            nextCheckpoint = currentCheckpoint + 2
        case .coin:
            currentCheckpoint = missionCheckpointList[.coin] ?? 0
            nextCheckpoint = currentCheckpoint + 10
        }

        return nextCheckpoint
    }
}
