//
//  MissionsScene.swift
//  Dash
//
//  Created by Jolyn Tan on 14/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class MissionsScene: SKScene {
    var returnToMenuScene: SKScene!

    override func didMove(to view: SKView) {
        initMissionsTitleLabel()
        initMissions()
        initCloseButton()
        initBackground()
    }

    private func initBackground() {
        let backgroundNode = BackgroundNode(self.frame, type: .flappy)
        self.addChild(backgroundNode)
    }

    private func initMissionsTitleLabel() {
        let missionsLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        missionsLabel.text = "M I S S I O N S"
        missionsLabel.fontSize = 80
        missionsLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        self.addChild(missionsLabel)
    }

    private func initMissions() {
        // distance
        let distanceMission = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        distanceMission.text = retrieveMessage(missionType: .distance)
        distanceMission.fontSize = 20
        distanceMission.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 40)
        self.addChild(distanceMission)

        // powerups
        let powerUpMission = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        powerUpMission.text = retrieveMessage(missionType: .powerUp)
        powerUpMission.fontSize = 20
        powerUpMission.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 80)
        self.addChild(powerUpMission)

        // coins
        let coinsMission = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        coinsMission.text = retrieveMessage(missionType: .coin)
        coinsMission.fontSize = 20
        coinsMission.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 120)
        self.addChild(coinsMission)
    }

    private func initCloseButton() {
        let closeButton = SKSpriteNode(texture: MenuTexture.cross)
        closeButton.size = CGSize(width: 40, height: 40)
        closeButton.name = "close"
        closeButton.position = CGPoint(
            x: self.frame.width - 70,
            y: self.frame.height - 70)

        self.addChild(closeButton)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)

        if nodes.first?.name == "close" {
            self.view?.presentScene(returnToMenuScene)
        }
    }

    private func retrieveMessage(missionType: MissionType) -> String {
        guard let message = Storage.getMissionCheckpoint(for: missionType) else {
            switch missionType {
            case .distance:
                return "Reach 500m in one run"
            case .powerUp:
                return "Consume 1 power up"
            case .coin:
                return "Collect 10 coins"
            }
        }
        return message
    }
}
