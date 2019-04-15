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
            .distance: 5000, // TODO: get checkpoint from storagr
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
        default:
            return
        }
    }

    private func hasPassedCheckpoint(for missionType: MissionType, value: Int) -> Bool {
        guard let checkpoint = missionCheckpointList[missionType] else {
            return false
        }
        return value > checkpoint
    }

    private func checkMissionCompletion(for missionType: MissionType, value: Int) {
        guard hasPassedCheckpoint(for: missionType, value: value) else {
            return
        }
        let checkpoint = missionCheckpointList[missionType] ?? 0
        let message = missionMessage(for: missionType, value: checkpoint)
        mission.message = message

        let nextCheckpoint = nextCheckpointValue(for: missionType)
        missionCheckpointList[missionType] = nextCheckpoint
        let nextMessage = missionMessage(for: missionType, value: nextCheckpoint)
        Storage.saveMissionCheckpoint(for: missionType, with: nextMessage)
    }

    private func nextCheckpointValue(for missionType: MissionType) -> Int {
        var currentCheckpoint: Int
        var nextCheckpoint: Int

        switch missionType {
        case .distance:
            currentCheckpoint = missionCheckpointList[.distance] ?? 0
            nextCheckpoint = currentCheckpoint + 5000
        case .powerUp:
            nextCheckpoint = missionCheckpointList[.powerUp] ?? 0 + 2
        case .coin:
            nextCheckpoint = missionCheckpointList[.coin] ?? 0 + 10
        }

        return nextCheckpoint
    }

    private func missionMessage(for missionType: MissionType, value: Int) -> String {
        var message: String

        switch missionType {
        case .distance:
            message = "Reach \(value)m in one run"
        case .powerUp:
            message = "Consume \(value) power ups"
        case .coin:
            message = "Collect \(value) coins"
        }

        return message
    }

    private func updateCheckpoint(for missionType: MissionType) {
        let nextCheckpoint = nextCheckpointValue(for: missionType)
        missionCheckpointList[missionType] = nextCheckpoint
    }

    private func saveNextMissionCheckpoint(for missionType: MissionType, with message: String) {
        Storage.saveMissionCheckpoint(for: missionType, with: message)
    }
}
