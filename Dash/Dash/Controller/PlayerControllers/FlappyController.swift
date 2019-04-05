//
//  FlappyController.swift
//  Dash
//
//  Created by Jolyn Tan on 5/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class FlappyController: PlayerController {
    var physicsBody: SKPhysicsBody
    var direction = Direction.goUp

    init() {
        let texture = SKTexture(imageNamed: "arrow3.png")
        let playerSize = CGSize(width: 55, height: 55)
        self.physicsBody = SKPhysicsBody(texture: texture, size: playerSize)

        self.physicsBody.affectedByGravity = true
        self.physicsBody.allowsRotation = false
        self.physicsBody.mass = 0.1
        self.physicsBody.velocity = CGVector(dx: 0, dy: 0)
    }

    var physicsBodyCopy: SKPhysicsBody {
        return physicsBody
    }

    func move() {
        switchDirection()
    }

    func switchDirection() {
        physicsBody.applyImpulse(CGVector(dx: 0, dy: 100))
        let velocity = physicsBody.velocity
        if velocity.dy > CGFloat(600) {
            physicsBody.velocity.dy = 600
        } else if velocity.dy < CGFloat(-600) {
            physicsBody.velocity.dy = -600
        }
    }
}
