//
//  PlayerNode.swift
//  Dash
//
//  Created by Jie Liang Ang on 18/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import SpriteKit

enum Direction {
    case goUp, goDown
}

class PlayerNode: SKSpriteNode, Observer {
    var direction = Direction.goUp
    let arrowUpTexture = GameTexture.arrowUp
    let arrowDownTexture = GameTexture.arrowDown

    var controls: PlayerControls

    convenience init(_ player: Player) {
        let texture = SKTexture(imageNamed: "arrow3.png")
        let playerSize = CGSize(width: 55, height: 55)

        self.init(texture: GameTexture.arrowUp, color: SKColor.clear, size: playerSize, controls: ArrowControls())

        self.physicsBody = controls.physicsBodyCopy
        player.observer = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private init(texture: SKTexture?, color: UIColor, size: CGSize, controls: PlayerControls) {
        self.controls = controls
        super.init(texture: texture, color: color, size: size)
    }

    func onValueChanged(name: String, object: Any?) {
        guard let player = object as? Player else {
            return
        }

        // controls.moveup/movedown
        if player.isJumping {
            controls.moveUp()
        }
    }

    func setType(_ type: CharacterType) {
        switch type {
        case .arrow:
            self.physicsBody?.affectedByGravity = false
            self.physicsBody?.velocity = Constants.upwardVelocity
        case .glide:
            self.physicsBody?.affectedByGravity = true
            self.physicsBody?.velocity = Constants.zeroVelocity
        }
    }
}

class JetpackControls: PlayerControls {
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

    func moveUp() {
        physicsBody.applyForce(CGVector(dx: 0, dy: 300))
        let velocity = physicsBody.velocity
        if velocity.dy > CGFloat(600) {
            physicsBody.velocity.dy = 600
        } else if velocity.dy < CGFloat(-600) {
            physicsBody.velocity.dy = -600
        }
    }

    func moveDown() {
    }
}

class ArrowControls: PlayerControls {
    var physicsBody: SKPhysicsBody
    var direction = Direction.goUp

    init() {
        let texture = SKTexture(imageNamed: "arrow3.png")
        let playerSize = CGSize(width: 55, height: 55)
        self.physicsBody = SKPhysicsBody(texture: texture, size: playerSize)

        self.physicsBody.affectedByGravity = false
        self.physicsBody.allowsRotation = false
        self.physicsBody.mass = 0.1
        self.physicsBody.velocity = CGVector(dx: 0, dy: 0)
    }

    var physicsBodyCopy: SKPhysicsBody {
        return physicsBody
    }

    func moveUp() {
        switchDirection()
    }

    func moveDown() {
    }

    func switchDirection() {
        switch direction {
        case .goUp:
            direction = .goDown
            self.physicsBody.velocity = Constants.downwardVelocity
           // self.texture = arrowDownTexture
        case .goDown:
            direction = .goUp
            self.physicsBody.velocity = Constants.upwardVelocity
            //self.texture = arrowUpTexture
        }
    }

}
