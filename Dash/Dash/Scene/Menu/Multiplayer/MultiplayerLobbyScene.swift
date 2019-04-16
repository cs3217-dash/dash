//
//  MultiplayerLobbyScene.swift
//  Dash
//
//  Created by Jolyn Tan on 16/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class MultiplayerLobbyScene: SKScene {

    override func didMove(to view: SKView) {
        initHostLabel()
        initJoinLabel()
        initBackButton()
    }

    private func initHostLabel() {
        let hostLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        hostLabel.name = "host"
        hostLabel.text = "H O S T  G A M E"
        hostLabel.fontSize = 40
        hostLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 45)
        self.addChild(hostLabel)
    }

    private func initJoinLabel() {
        let joinLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        joinLabel.name = "join"
        joinLabel.text = "J O I N  G A M E"
        joinLabel.fontSize = 40
        joinLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 45)
        self.addChild(joinLabel)
    }

    private func initBackButton() {
        let backButton = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        backButton.name = "back"
        backButton.text = "back"
        backButton.fontSize = 20
        backButton.position = CGPoint(x: backButton.frame.width + 70, y: self.frame.height - 70)
        self.addChild(backButton)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)

        switch nodes.first?.name {
        case "host":
            presentMultiplayerHostScene()
        case "join":
            presentMultiplayerJoinScene()
        case "back":
            presentMainMenuScene()
        default:
            return
        }
    }

    private func presentMainMenuScene() {
        let mainMenuScene = MainMenuScene(size: self.size)
        self.view?.presentScene(mainMenuScene)
    }

    private func presentMultiplayerHostScene() {
        let hostScene = MultiplayerHostScene(size: self.size)
        self.view?.presentScene(hostScene)
    }

    private func presentMultiplayerJoinScene() {
        let joinScene = MultiplayerJoinScene(size: self.size)
        self.view?.presentScene(joinScene)
    }
}
