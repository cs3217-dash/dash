//
//  MissionsManager.swift
//  Dash
//
//  Created by Jolyn Tan on 11/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

/// Detects and handles mission completion
class MissionManager: Observer {
    var missionCheckpointList: [MissionType: Int]
    var mission: Mission

    init(mission: Mission) {
        self.mission = mission
        self.missionCheckpointList = [
            .distance: Storage.getMissionCheckpoint(forMissionType: .distance),
            .powerUp: Storage.getMissionCheckpoint(forMissionType: .powerUp),
            .coin: Storage.getMissionCheckpoint(forMissionType: .coin)
        ]
    }

    func onValueChanged(name: String, object: Any?) {
        guard let value = object as? Int else {
            return
        }
        switch name {
        case Constants.notificationDistance:
            checkMissionCompletion(for: .distance, value: value)
        case Constants.notificationPowerUpCount:
            checkMissionCompletion(for: .powerUp, value: value)
        case Constants.notificationCoinCount:
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

        setCheckpointToDisplay(for: missionType)
        updateNextCheckpoint(for: missionType)
    }

    private func setCheckpointToDisplay(for missionType: MissionType) {
        let checkpoint = missionCheckpointList[missionType] ?? 0
        let message = MissionConfig.message(for: checkpoint, missionType: missionType)
        mission.message = message
    }

    /// Updates next checkpoint in `missionCheckpointList` and storage
    private func updateNextCheckpoint(for missionType: MissionType) {
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
            nextCheckpoint = currentCheckpoint + MissionConfig.distanceOffset
        case .powerUp:
            currentCheckpoint = missionCheckpointList[.powerUp] ?? 0
            nextCheckpoint = currentCheckpoint + MissionConfig.powerUpOffset
        case .coin:
            currentCheckpoint = missionCheckpointList[.coin] ?? 0
            nextCheckpoint = currentCheckpoint + MissionConfig.coinOffset
        }

        return nextCheckpoint
    }
}
