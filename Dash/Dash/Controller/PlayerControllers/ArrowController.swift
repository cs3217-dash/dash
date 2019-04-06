//
//  ArrowController.swift
//  Dash
//
//  Created by Jolyn Tan on 5/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class ArrowController: PlayerController {
    var physicsBody: SKPhysicsBody
    var direction = Direction.goUp

    init() {
        let texture = SKTexture(imageNamed: "arrow3.png")
        let playerSize = CGSize(width: 55, height: 55)
        self.physicsBody = SKPhysicsBody(texture: texture, size: playerSize)

        self.physicsBody.affectedByGravity = false
        self.physicsBody.allowsRotation = false
        self.physicsBody.mass = 30
        self.physicsBody.velocity = CGVector(dx: 0, dy: 100)
    }

    var physicsBodyCopy: SKPhysicsBody {
        return physicsBody
    }

    func move() {
        switchDirection()
    }

    func switchDirection() {
        switch direction {
        case .goUp:
            direction = .goDown
            self.physicsBody.velocity = Constants.downwardVelocity
        case .goDown:
            direction = .goUp
            self.physicsBody.velocity = Constants.upwardVelocity
        }
    }
}
