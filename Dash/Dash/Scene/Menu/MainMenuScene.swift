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
        1: .jetpack,
        2: .flappy
    ]

    var controlsSelectionBoxes: [SKShapeNode] = []
    var currentSelection = 0
    var canChangeSelection = true

    var leftArrow: SKShapeNode!
    var rightArrow: SKShapeNode!

    override func didMove(to view: SKView) {
        initBackground()
        createControlsSelectionBox(for: .arrow, order: 0)
        createControlsSelectionBox(for: .jetpack, order: 1)
        createControlsSelectionBox(for: .flappy, order: 2)
        initMissionsButton()
        
        self.view?.isMultipleTouchEnabled = false
    }

    private func initBackground() {
        self.backgroundColor = SKColor.init(red: 0.29, green: 0.27, blue: 0.30, alpha: 1)
    }

    private func createControlsSelectionBox(for type: CharacterType, order: Int) {
        // temporary box
        let size = CGSize(width: self.frame.width * 0.7, height: self.frame.height * 0.7)
        let controlsBox = SKShapeNode(rectOf: size)
        controlsBox.name = "controlsBox"
        controlsBox.strokeColor = SKColor.white
        if order == currentSelection {
            controlsBox.position = CGPoint(x: self.frame.midX, y: controlsBox.frame.height / 2 + 40)
        } else {
            controlsBox.position = CGPoint(x: self.frame.midX, y: 10000)
        }
        self.addChild(controlsBox)

        // controls type label
        let controlsLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")

        switch type {
        case .arrow:
            controlsLabel.text = "A R R O W"
        case .jetpack:
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
        let leftArrow = SKShapeNode(circleOfRadius: 30)
        leftArrow.name = "leftArrow"
        leftArrow.fillColor = SKColor.white
        leftArrow.position = CGPoint(x: -controlsBox.frame.width / 2, y: 0)
        controlsBox.addChild(leftArrow)

        let rightArrow = SKShapeNode(circleOfRadius: 30)
        rightArrow.name = "rightArrow"
        rightArrow.fillColor = SKColor.white
        rightArrow.position = CGPoint(x: controlsBox.frame.width / 2, y: 0)
        controlsBox.addChild(rightArrow)

        controlsSelectionBoxes.append(controlsBox)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)

        if nodes.first?.name == "leftArrow" {
            slideLeft()
        }
        if nodes.first?.name == "rightArrow" {
            slideRight()
        }

        if nodes.first?.name == "controlsBox" {
            guard let controlsType = controlsOrderMap[currentSelection] else {
                return
            }
           presentGameScene(with: controlsType)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)

        if nodes.first?.name == "missions" {
            presentMissionsScene()
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
            y: controlsSelectionBoxes[nextSelection].frame.height / 2 + 40)

        let slideLeft = SKAction.moveBy(x: -self.frame.width, y: 0, duration: 0.3)
        let delay = SKAction.wait(forDuration: 0.3)

        for box in controlsSelectionBoxes {
            let sequence = SKAction.sequence([slideLeft, delay])
            box.run(sequence, completion: { [weak self] in
                self?.canChangeSelection = true
            })
        }
        currentSelection = nextSelection
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
            y: controlsSelectionBoxes[nextSelection].frame.height / 2 + 40)

        let slideRight = SKAction.moveBy(x: self.frame.width, y: 0, duration: 0.3)
        let delay = SKAction.wait(forDuration: 0.3)

        for box in controlsSelectionBoxes {
            let sequence = SKAction.sequence([slideRight, delay])
            box.run(sequence, completion: { [weak self] in
                self?.canChangeSelection = true
            })
        }
        currentSelection = nextSelection
    }

    private func initMissionsButton() {
        let missionsButton = SKShapeNode(circleOfRadius: 20)
        missionsButton.name = "missions"
        missionsButton.fillColor = SKColor.white
        missionsButton.position = CGPoint(
            x: missionsButton.frame.width + 20,
            y: self.frame.height - missionsButton.frame.width - 20)
        self.addChild(missionsButton)
    }

    private func presentGameScene(with characterType: CharacterType) {
        let gameScene = GameScene(size: self.size)
        gameScene.characterType = characterType
        self.view?.presentScene(gameScene)
    }

    private func presentMissionsScene() {
        let missionsScene = MissionsScene(size: self.size)
        missionsScene.returnToMenuScene = self
        self.view?.presentScene(missionsScene)
    }
}
