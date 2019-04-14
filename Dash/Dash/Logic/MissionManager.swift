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
    var missionQueue = MissionQueue()
    var mission: Mission

    init(mission: Mission) {
        self.mission = mission
    }

    func onValueChanged(name: String, object: Any?) {
        switch name {
        case "distance":
            guard let distance = object as? Double else {
                return
            }
            checkMissionQueue(for: distance)

        default:
            return
        }
    }

    private func checkMissionQueue(for distance: Double) {
        guard let checkpoint = missionQueue.distance.peek() else {
            return
        }
        if distance > Double(checkpoint) {
            guard let value = missionQueue.distance.dequeue() else {
                return
            }
            mission.message = "Reach \(value)m in one run"
            saveMissionCheckpoint(message: mission.message)
            // save complete mission

            // storage.save(mission.message)
        }
    }

    private func saveMissionCheckpoint(message: String) {
        print("saved")
        Storage.saveMissionCheckpoint(message: message)
    }
}
