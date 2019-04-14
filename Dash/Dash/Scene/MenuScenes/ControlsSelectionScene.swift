//
//  ControlsSelectionScene.swift
//  Dash
//
//  Created by Jolyn Tan on 14/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class ControlsSelectionScene: SKScene {
    var controlsSelectionBoxes: [SKShapeNode] = []
    var currentSelection = 0
    var canChangeSelection = true

    override func didMove(to view: SKView) {
        initBackground()
        createControlsSelectionBox(for: .arrow, order: 0)
        createControlsSelectionBox(for: .jetpack, order: 1)
        createControlsSelectionBox(for: .flappy, order: 2)
        self.view?.isMultipleTouchEnabled = false
    }

    private func initBackground() {
        self.backgroundColor = SKColor.init(red: 0.29, green: 0.27, blue: 0.30, alpha: 1)
    }

    private func createControlsSelectionBox(for type: CharacterType, order: Int) {

        // temporary box
        let size = CGSize(width: self.frame.width * 0.7, height: self.frame.height * 0.6)
        let controlsBox = SKShapeNode(rectOf: size)
        controlsBox.strokeColor = SKColor.white
        controlsBox.position = CGPoint(x: self.frame.midX + CGFloat(order) * self.frame.width, y: controlsBox.frame.height / 2 + 40)
        self.addChild(controlsBox)

        // text
        let controlsLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")

        switch type {
        case .arrow:
            controlsLabel.text = "ARROW"
        case .jetpack:
            controlsLabel.text = "GLIDE"
        case .flappy:
            controlsLabel.text = "FLAPPY"
        }
        controlsLabel.fontSize = 40
        controlsLabel.position = CGPoint(x: 0, y: 0)
        controlsBox.addChild(controlsLabel)

        // arrows
        let arrow = SKShapeNode(circleOfRadius: 30)
        arrow.fillColor = SKColor.white
        arrow.position = CGPoint(x: 0, y: 0)
        controlsBox.addChild(arrow)

        controlsSelectionBoxes.append(controlsBox)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard canChangeSelection else {
            return
        }
        canChangeSelection = false

        let slideLeft = SKAction.moveBy(x: -self.frame.width, y: 0, duration: 0.3)
        let moveToBack = SKAction.moveTo(x: self.frame.midX + CGFloat(2) * self.frame.width, duration: 0)
        let delay = SKAction.wait(forDuration: 0.3)

        for (idx, box) in controlsSelectionBoxes.enumerated() {
            let sequence: SKAction

            if idx == currentSelection {
                sequence = SKAction.sequence([slideLeft, moveToBack, delay])
            } else {
                sequence = SKAction.sequence([slideLeft, delay])
            }

            box.run(sequence, completion: { [weak self] in
                self?.canChangeSelection = true
            })
        }

        currentSelection = (currentSelection + 1) % 3
    }
}
