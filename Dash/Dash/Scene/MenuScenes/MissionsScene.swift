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
    }

    private func initMissionsTitleLabel() {
        let missionsLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        missionsLabel.text = "MISSIONS"
        missionsLabel.fontSize = 100
        missionsLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        self.addChild(missionsLabel)
    }

    private func initMissions() {
        // distance
        let distanceMission = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        distanceMission.text = Storage.getMissionCheckpoint(for: .distance)
        distanceMission.fontSize = 20
        distanceMission.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 40)
        self.addChild(distanceMission)

        // powerups
        let powerUpMission = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        powerUpMission.text = "power up mission"
        powerUpMission.fontSize = 20
        powerUpMission.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 80)
        self.addChild(powerUpMission)

        // coins
        let coinsMission = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        coinsMission.text = "coins mission"
        coinsMission.fontSize = 20
        coinsMission.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 120)
        self.addChild(coinsMission)
    }

    private func initCloseButton() {
        let closeButton = SKSpriteNode(color: SKColor.white,
                                       size: CGSize(width: 50, height: 50))
        closeButton.name = "close"
        closeButton.position = CGPoint(
            x: self.frame.width - closeButton.frame.width - 30,
            y: self.frame.height - 80)

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
}
