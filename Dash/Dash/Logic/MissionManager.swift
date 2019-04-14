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
            .distance: 5000,
            .powerUp: 0,
            .coin: 0
        ]
    }

    func onValueChanged(name: String, object: Any?) {
        switch name {
        case "distance":
            guard let distance = object as? Double else {
                return
            }
            checkMissionCompletion(for: .distance, value: distance)
        default:
            return
        }
    }

    private func hasPassedCheckpoint(for missionType: MissionType, value: Double) -> Bool {
        guard let checkpoint = missionCheckpointList[missionType] else {
            return false
        }
        return value > Double(checkpoint)
    }

    private func checkMissionCompletion(for missionType: MissionType, value: Double) {
        guard hasPassedCheckpoint(for: missionType, value: value) else {
            return
        }
        let checkpoint = missionCheckpointList[missionType] ?? 0
        let message = missionMessage(for: missionType, value: checkpoint)
        mission.message = message
        saveMissionCheckpoint(for: missionType, with: message)

        updateCheckpoint(for: missionType)
    }

    private func nextCheckpointValue(for missionType: MissionType) -> Int {
        var currentCheckpoint: Int
        var nextCheckpoint: Int

        switch missionType {
        case .distance:
            currentCheckpoint = missionCheckpointList[.distance] ?? 0
            nextCheckpoint = currentCheckpoint + 5000
        case .powerUp:
            nextCheckpoint = missionCheckpointList[.powerUp] ?? 0 + 3
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

    private func saveMissionCheckpoint(for missionType: MissionType, with message: String) {
        Storage.saveMissionCheckpoint(for: missionType, with: message)
    }
}
