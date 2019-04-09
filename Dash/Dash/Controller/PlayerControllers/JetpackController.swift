//
//  JetpackController.swift
//  Dash
//
//  Created by Jolyn Tan on 5/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class JetpackController: PlayerController {
    var physicsBody: SKPhysicsBody

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
        physicsBody.applyForce(CGVector(dx: 0, dy: 350))
        let velocity = physicsBody.velocity
        if velocity.dy > CGFloat(700) {
            physicsBody.velocity.dy = 700
        } else if velocity.dy < CGFloat(-700) {
            physicsBody.velocity.dy = -700
        }
    }
}
