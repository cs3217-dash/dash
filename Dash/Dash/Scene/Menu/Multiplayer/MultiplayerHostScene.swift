//
//  MultiplayerHostScene.swift
//  Dash
//
//  Created by Jolyn Tan on 16/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class MultiplayerHostScene: SKScene {
    var selectArrowPosition: CGPoint!
    var selectGlidePosition: CGPoint!
    var selectFlappyPosition: CGPoint!

    var selectionBox: SKShapeNode!

    var currentSelection = CharacterType.arrow

    override func didMove(to view: SKView) {
        initRoomIdLabel(id: "1234")
        initPlayerCountLabel(count: 0)
        initModeSelectionLabel()
        initStartLabel()
    }

    private func initRoomIdLabel(id: String) {
        let roomIdLabel = SKLabelNode(fontNamed: "HelveticaNeue-Regular")
        roomIdLabel.text = "room id: \(id)"
        roomIdLabel.fontSize = 30
        roomIdLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.8)
        self.addChild(roomIdLabel)
    }

    private func initPlayerCountLabel(count: Int) {
        let roomIdLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        roomIdLabel.text = "\(count) players joined"
        roomIdLabel.fontSize = 20
        roomIdLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.75)
        self.addChild(roomIdLabel)
    }

    private func initModeSelectionLabel() {
        let selectLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        selectLabel.text = "S E L E C T  M O D E"
        selectLabel.fontSize = 40
        selectLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.5)
        self.addChild(selectLabel)

        let arrowLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        arrowLabel.name = "arrow"
        arrowLabel.text = "arrow"
        arrowLabel.fontSize = 20
        arrowLabel.position = CGPoint(x: self.frame.midX - 140, y: self.frame.height * 0.4)
        self.addChild(arrowLabel)

        selectArrowPosition = selectionBoxPosition(for: arrowLabel.position)

        let glideLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        glideLabel.name = "glide"
        glideLabel.text = "glide"
        glideLabel.fontSize = 20
        glideLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.4)
        self.addChild(glideLabel)

        selectGlidePosition = selectionBoxPosition(for: glideLabel.position)

        let flappyLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        flappyLabel.name = "flappy"
        flappyLabel.text = "flappy"
        flappyLabel.fontSize = 20
        flappyLabel.position = CGPoint(x: self.frame.midX + 140, y: self.frame.height * 0.4)
        self.addChild(flappyLabel)

        selectFlappyPosition = selectionBoxPosition(for: flappyLabel.position)

        selectionBox = SKShapeNode(rectOf: CGSize(width: 110, height: 45))
        selectionBox.position = selectArrowPosition
        self.addChild(selectionBox)

    }

    private func selectionBoxPosition(for labelPosition: CGPoint) -> CGPoint {
        return CGPoint(x: labelPosition.x, y: labelPosition.y + 5)
    }

    private func initStartLabel() {
        let startLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        startLabel.name = "start"
        startLabel.text = "S T A R T"
        startLabel.fontSize = 40
        startLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.2)
        self.addChild(startLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)

        switch nodes.first?.name {
        case "arrow":
            updateSelection(to: .arrow)
        case "glide":
            updateSelection(to: .glide)
        case "flappy":
            updateSelection(to: .flappy)
        default:
            return
        }
    }

    private func updateSelection(to selectedType: CharacterType) {
        currentSelection = selectedType

        switch selectedType {
        case .arrow:
            selectionBox.position = selectArrowPosition
        case .glide:
            selectionBox.position = selectGlidePosition
        case .flappy:
            selectionBox.position = selectFlappyPosition
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)

        switch nodes.first?.name {
        case "start":
            print("start!!")
        default:
            return
        }
    }
}
