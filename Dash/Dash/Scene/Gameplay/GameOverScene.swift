//
//  GameOverScene.swift
//  Dash
//
//  Created by Jolyn Tan on 15/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

// TODO: add menu bar
class GameOverScene: SKScene {
    var currentCharacterType: CharacterType = .arrow
    var currentPlayerActions: [Action] = []

    var score = 0
    var scoreLabel: SKLabelNode!
    var bestScoreLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        initCurrentScoreLabel()
        initShadowPlayLabel()
        initReplayLabel()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)

        switch nodes.first?.name {
        case "replay":
            presentGameScene(with: currentCharacterType)
        case "shadow":
            presentGameSceneShadow(with: currentCharacterType)
        default:
            return
        }
    }

    private func initCurrentScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        scoreLabel.text = "\(score) pts"
        scoreLabel.fontSize = 120
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 60)
        self.addChild(scoreLabel)
    }

    private func initReplayLabel() {
        let replayLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        replayLabel.name = "replay"
        replayLabel.text = "play again"
        replayLabel.fontSize = 28
        replayLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 60)
        self.addChild(replayLabel)
    }

    private func initShadowPlayLabel() {
        let shadowPlayLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        shadowPlayLabel.name = "shadow"
        shadowPlayLabel.text = "shadow play"
        shadowPlayLabel.fontSize = 22
        shadowPlayLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 120)
        self.addChild(shadowPlayLabel)
    }

    private func presentGameScene(with characterType: CharacterType) {
        let gameScene = GameScene(size: self.size)

        gameScene.characterType = characterType
        gameScene.gameMode = .single
        gameScene.room = nil

        self.view?.presentScene(gameScene)
    }

    private func presentGameSceneShadow(with characterType: CharacterType) {
        let gameScene = GameScene(size: self.size)

        let room = Room(id: "", type: characterType)
        let shadow = Player(type: characterType)
        var clonedActions: [Action] = []

        currentPlayerActions.forEach { (action) in
            guard let copy = action.copy() else {
                return
            }
            copy.time = copy.time + 0.2
            clonedActions.append(copy)
        }
        shadow.actionList = clonedActions
        room.players.append(shadow)

        gameScene.characterType = characterType
        gameScene.gameMode = .shadow
        gameScene.room = room

        self.view?.presentScene(gameScene)
    }
}
