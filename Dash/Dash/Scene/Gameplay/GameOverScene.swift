//
//  GameOverScene.swift
//  Dash
//
//  Created by Jolyn Tan on 15/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    var currentCharacterType: CharacterType = .arrow
    var currentPlayerActions: [Action] = []
    var currentSeed = 0

    var score = 0
    var scoreLabel: SKLabelNode!
    var bestScoreLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        initCurrentScoreLabel()
        initShadowPlayLabel()
        initReplayLabel()
        initReturnToMenuButton()
    }

    private func initReturnToMenuButton() {
        let returnToMenuButton = ReturnToMenuNode()
        returnToMenuButton.position = CGPoint(x: 70 + returnToMenuButton.frame.width / 2, y: frame.height - 70)
        self.addChild(returnToMenuButton)
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
        case "menu":
            presentMainMenuScene()
        default:
            return
        }
    }

    private func initCurrentScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: Constants.defaultFont)
        scoreLabel.text = "\(score) m"
        scoreLabel.fontSize = 120
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 60)
        self.addChild(scoreLabel)
    }

    private func initReplayLabel() {
        let replayLabel = SKLabelNode(fontNamed: Constants.defaultFont)
        replayLabel.name = "replay"
        replayLabel.text = "play again"
        replayLabel.fontSize = 28
        replayLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 60)
        self.addChild(replayLabel)
    }

    private func initShadowPlayLabel() {
        let shadowPlayLabel = SKLabelNode(fontNamed: Constants.defaultFont)
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
        gameScene.clockTime = (Date().timeIntervalSince1970 + 3) * 1000
        gameScene.seed = Int.random(in: 0...999999999)

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
            copy.time += 0.2
            clonedActions.append(copy)
        }
        shadow.actionList = clonedActions
        room.players.append(shadow)

        gameScene.characterType = characterType
        gameScene.gameMode = .shadow
        gameScene.room = room
        gameScene.clockTime = (Date().timeIntervalSince1970 + 3) * 1000
        gameScene.seed = currentSeed

        self.view?.presentScene(gameScene)
    }

    private func presentMainMenuScene() {
        let mainMenuScene = MainMenuScene(size: self.size)
        self.view?.presentScene(mainMenuScene)
    }
}
