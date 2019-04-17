//
//  MainMenuScene.swift
//  Dash
//
//  Created by Jolyn Tan on 14/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    let controlsOrderMap: [Int: CharacterType] = [
        0: .arrow,
        1: .glide,
        2: .flappy
    ]

    var controlsSelectionBoxes: [SKShapeNode] = []
    var currentSelection = 0
    var canChangeSelection = true

    var leftArrow: SKShapeNode!
    var rightArrow: SKShapeNode!
    var backgroundNode: BackgroundNode!

    override func didMove(to view: SKView) {
        initBackground()
        createControlsSelectionBox(for: .arrow, order: 0)
        createControlsSelectionBox(for: .glide, order: 1)
        createControlsSelectionBox(for: .flappy, order: 2)
        initMissionsButton()
        initHighscoreButton()
        initMultiplayerButton()
        
        self.view?.isMultipleTouchEnabled = false
    }

//    private func initBackground() {
//        self.backgroundColor = SKColor.init(red: 0.29, green: 0.27, blue: 0.30, alpha: 1)
//    }

    private func initBackground() {
        backgroundNode = BackgroundNode(self.frame, type: .arrow)
        self.addChild(backgroundNode)
    }

    private func createControlsSelectionBox(for type: CharacterType, order: Int) {
        // temporary box
        let size = CGSize(width: self.frame.width - 140, height: self.frame.height * 0.7)
        let controlsBox = SKShapeNode(rectOf: size)
        controlsBox.name = "controlsBox"
        controlsBox.strokeColor = SKColor.clear
        if order == currentSelection {
            controlsBox.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        } else {
            controlsBox.position = CGPoint(x: self.frame.midX, y: 10000)
        }
        self.addChild(controlsBox)

        // controls type label
        let controlsLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")

        switch type {
        case .arrow:
            controlsLabel.text = "A R R O W"
        case .glide:
            controlsLabel.text = "G L I D E"
        case .flappy:
            controlsLabel.text = "F L A P P Y"
        }
        controlsLabel.fontSize = 60
        controlsLabel.position = CGPoint(x: 0, y: 10)
        controlsLabel.zPosition = -1
        controlsBox.addChild(controlsLabel)

        // play label
        let playLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        playLabel.text = "tap to play"
        playLabel.fontSize = 20
        playLabel.position = CGPoint(x: 0, y: -60)
        controlsBox.addChild(playLabel)

        // arrows
        let leftArrow = SKSpriteNode(texture: MenuTexture.leftArrow)
        leftArrow.size = CGSize(width: 80, height: 80)
        leftArrow.name = "leftArrow"
        leftArrow.position = CGPoint(x: -controlsBox.frame.width / 2, y: 0)
        controlsBox.addChild(leftArrow)

        let rightArrow = SKSpriteNode(texture: MenuTexture.rightArrow)
        rightArrow.size = CGSize(width: 80, height: 80)
        rightArrow.name = "rightArrow"
        rightArrow.position = CGPoint(x: controlsBox.frame.width / 2, y: 0)
        controlsBox.addChild(rightArrow)

        controlsSelectionBoxes.append(controlsBox)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)

        switch nodes.first?.name {
        case "leftArrow":
            slideLeft()
        case "rightArrow":
            slideRight()
        case "controlsBox":
            guard let controlsType = controlsOrderMap[currentSelection] else {
                return
            }
            presentGameScene(with: controlsType)
        default:
            return
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)

        switch nodes.first?.name {
        case "missions":
            presentMissionsScene()
        case "highscore":
            presentHighscoreScene()
        case "multiplayer":
            presentMultiplayerLobbyScene()
        default:
            return
        }
    }

    private func slideLeft() {
        guard canChangeSelection else {
            return
        }
        canChangeSelection = false

        let nextSelection = (currentSelection + 1) % 3

        // position next selection
        controlsSelectionBoxes[nextSelection].position = CGPoint(
            x: self.frame.midX + self.frame.width,
            y: self.frame.midY)

        let slideLeft = SKAction.moveBy(x: -self.frame.width, y: 0, duration: 0.3)
        let delay = SKAction.wait(forDuration: 0.3)

        for box in controlsSelectionBoxes {
            let sequence = SKAction.sequence([slideLeft, delay])
            box.run(sequence, completion: { [weak self] in
                self?.canChangeSelection = true
            })
        }
        currentSelection = nextSelection
        
        guard let controlsType = controlsOrderMap[currentSelection] else {
            return
        }
        backgroundNode.updateBackground(type: controlsType)
    }

    private func slideRight() {
        guard canChangeSelection else {
            return
        }
        canChangeSelection = false

        let nextSelection = (currentSelection == 0) ? 2 : currentSelection - 1

        // position next selection
        controlsSelectionBoxes[nextSelection].position = CGPoint(
            x: self.frame.midX - self.frame.width,
            y: self.frame.midY)

        let slideRight = SKAction.moveBy(x: self.frame.width, y: 0, duration: 0.3)
        let delay = SKAction.wait(forDuration: 0.3)

        for box in controlsSelectionBoxes {
            let sequence = SKAction.sequence([slideRight, delay])
            box.run(sequence, completion: { [weak self] in
                self?.canChangeSelection = true
            })
        }
        currentSelection = nextSelection

        guard let controlsType = controlsOrderMap[currentSelection] else {
            return
        }
        backgroundNode.updateBackground(type: controlsType)
    }

    private func initMissionsButton() {
        let missionsButton = SKSpriteNode(texture: MenuTexture.missions)
        missionsButton.size = CGSize(width: 35, height: 35)
        missionsButton.name = "missions"
        missionsButton.position = CGPoint(
            x: missionsButton.frame.width / 2 + 70,
            y: self.frame.height - 50)
        self.addChild(missionsButton)

        let missionsLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        missionsLabel.text = "missions"
        missionsLabel.name = "missions"
        missionsLabel.fontSize = 20
        missionsLabel.position = CGPoint(x: 65, y: -5)
        missionsButton.addChild(missionsLabel)
    }

    private func initHighscoreButton() {
        let highscoreButton = SKSpriteNode(texture: MenuTexture.highScore)
        highscoreButton.size = CGSize(width: 30, height: 30)
        highscoreButton.name = "highscore"
        highscoreButton.position = CGPoint(
            x: highscoreButton.frame.width + 240,
            y: self.frame.height - 50)
        self.addChild(highscoreButton)

        let highscoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        highscoreLabel.text = "highscore"
        highscoreLabel.name = "highscore"
        highscoreLabel.fontSize = 20
        highscoreLabel.position = CGPoint(x: 70, y: -5)
        highscoreButton.addChild(highscoreLabel)
    }

    private func initMultiplayerButton() {
        let multiplayerButton = SKSpriteNode(texture: MenuTexture.multiplayer)
        multiplayerButton.size = CGSize(width: 30, height: 30)
        multiplayerButton.name = "multiplayer"
        multiplayerButton.position = CGPoint(
            x: self.frame.width - multiplayerButton.frame.width / 2 - 70,
            y: self.frame.height - 50)
        self.addChild(multiplayerButton)

        let multiplayerLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        multiplayerLabel.name = "multiplayer"
        multiplayerLabel.text = "multiplayer"
        multiplayerLabel.fontSize = 20
        multiplayerLabel.position = CGPoint(x: -70, y: -5)
        multiplayerButton.addChild(multiplayerLabel)
    }

    private func presentGameScene(with characterType: CharacterType) {
        let gameScene = GameScene(size: self.size)
        gameScene.characterType = characterType
        gameScene.clockTime = (Date().timeIntervalSince1970 + 3) * 1000
        gameScene.seed = Int.random(in: 0...999999999)
        self.view?.presentScene(gameScene)
    }

    private func presentMissionsScene() {
        let missionsScene = MissionsScene(size: self.size)
        missionsScene.returnToMenuScene = self
        self.view?.presentScene(missionsScene)
    }

    private func presentHighscoreScene() {
        let leaderboardScene = LeaderboardScene(size: self.size)
        guard let selected = controlsOrderMap[currentSelection] else {
            return
        }

        var category = HighScoreCategory.arrow
        switch selected {
        case .arrow: category = .arrow
        case .flappy: category = .flappy
        case .glide: category = .glide
        }

        leaderboardScene.incomingCategory = category
        self.view?.presentScene(leaderboardScene)
    }

    private func presentMultiplayerLobbyScene() {
        let multiplayerLobbyScene = MultiplayerLobbyScene(size: self.size)
        self.view?.presentScene(multiplayerLobbyScene)
    }
}
