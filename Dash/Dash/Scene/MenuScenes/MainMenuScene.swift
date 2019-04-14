//
//  MainMenuScene.swift
//  Dash
//
//  Created by Jolyn Tan on 14/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    var titleLabel: SKLabelNode!
    var tapToPlayLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        initBackground()
        initTitle()
        initTapToPlay()
    }

    private func initBackground() {
        self.backgroundColor = SKColor.init(red: 0.29, green: 0.27, blue: 0.30, alpha: 1)
    }

    private func initTitle() {
        titleLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        titleLabel.text = "D A S H"
        titleLabel.fontSize = 160
        titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(titleLabel)
    }

    private func initTapToPlay() {
        tapToPlayLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        tapToPlayLabel.text = "TAP TO PLAY"
        tapToPlayLabel.fontSize = 20
        tapToPlayLabel.position = CGPoint(x: self.frame.midX, y: titleLabel.position.y - 100)
        self.addChild(tapToPlayLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let controlsSelectionScene = ControlsSelectionScene(size: self.size)
        self.view?.presentScene(controlsSelectionScene)
    }
}
