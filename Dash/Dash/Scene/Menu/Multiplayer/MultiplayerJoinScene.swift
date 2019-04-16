//
//  MultiplayerJoinScene.swift
//  Dash
//
//  Created by Jolyn Tan on 16/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class MultiplayerJoinScene: SKScene {
    
    override func didMove(to view: SKView) {
        initIdTextField()
    }

    private func initIdTextField() {
        let enterIdLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        enterIdLabel.text = "enter room id"
        enterIdLabel.fontSize = 20
        enterIdLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 70)
        self.addChild(enterIdLabel)
    }
}
