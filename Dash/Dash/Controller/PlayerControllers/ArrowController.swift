//
//  ArrowController.swift
//  Dash
//
//  Created by Jolyn Tan on 5/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class ArrowController: PlayerController {
    let arrowUpTexture = GameTexture.arrowUp
    let arrowDownTexture = GameTexture.arrowDown

    weak var playerNode: PlayerNode?
    var direction = Direction.goUp

    var wasHolding = false

    init(playerNode: PlayerNode) {
        let texture = SKTexture(imageNamed: "arrow3.png")
        let playerSize = CGSize(width: 55, height: 55)
        let physicsBody = SKPhysicsBody(texture: texture, size: playerSize)

        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.mass = 30
        physicsBody.velocity = CGVector(dx: 0, dy: 100)

        playerNode.physicsBody = physicsBody
        self.playerNode = playerNode
    }

    func move() {
        if !wasHolding {
            wasHolding = true
            switchDirection()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.wasHolding = false
            })
        }
    }

    func switchDirection() {
        guard let physicsBody = playerNode?.physicsBody else {
            return
        }

        switch direction {
        case .goUp:
            direction = .goDown
            physicsBody.velocity = Constants.downwardVelocity
            playerNode?.texture = arrowDownTexture
        case .goDown:
            direction = .goUp
            physicsBody.velocity = Constants.upwardVelocity
            playerNode?.texture = arrowUpTexture
        }
    }
}
