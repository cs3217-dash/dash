//
//  GlideController.swift
//  Dash
//
//  Created by Jolyn Tan on 5/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class GlideController: PlayerController {
    weak var playerNode: PlayerNode?

    var isHolding = false

    init(playerNode: PlayerNode) {
        let texture = SKTexture(imageNamed: "arrow3.png")
        let playerSize = CGSize(width: 55, height: 55)
        let physicsBody = SKPhysicsBody(texture: texture, size: playerSize)

        physicsBody.affectedByGravity = true
        physicsBody.allowsRotation = false
        physicsBody.mass = 0.1
        physicsBody.velocity = CGVector(dx: 0, dy: 0)

        physicsBody.categoryBitMask = ColliderType.player.rawValue
        physicsBody.contactTestBitMask = ColliderType.wall.rawValue | ColliderType.obstacle.rawValue
            | ColliderType.powerup.rawValue | ColliderType.coin.rawValue | ColliderType.boundary.rawValue
        physicsBody.collisionBitMask = 0

        playerNode.physicsBody = physicsBody
        self.playerNode = playerNode
    }

    func move() {
        guard isHolding else {
            return
        }
        glideUp()
    }

    private func glideUp() {
        guard let physicsBody = playerNode?.physicsBody else {
            return
        }
        physicsBody.applyForce(CGVector(dx: 0, dy: 370))
        let velocity = physicsBody.velocity
        if velocity.dy > CGFloat(700) {
            physicsBody.velocity.dy = 700
        } else if velocity.dy < CGFloat(-700) {
            physicsBody.velocity.dy = -700
        }
    }
}
