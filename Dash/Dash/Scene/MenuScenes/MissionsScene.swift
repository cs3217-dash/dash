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
        initMissionsLabel()
        initCloseButton()
    }

    private func initMissionsLabel() {
        let missionsLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        missionsLabel.text = "MISSIONS"
        missionsLabel.fontSize = 80
        missionsLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(missionsLabel)
    }

    private func initCloseButton() {
        let closeButton = SKSpriteNode(color: SKColor.white,
                                       size: CGSize(width: 50, height: 50))
        closeButton.name = "close"
        closeButton.position = CGPoint(
            x: self.frame.width - closeButton.frame.width - 30,
            y: self.frame.height - closeButton.frame.width - 30)

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
