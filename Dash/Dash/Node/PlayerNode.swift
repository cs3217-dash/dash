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
    case up, down
}

class PlayerNode: SKSpriteNode {

    var direction = Direction.up
    let arrowUpTexture = GameTexture.arrowUp
    let arrowDownTexture = GameTexture.arrowDown

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    convenience init() {
        let texture = SKTexture(imageNamed: "arrow1.png")
        let playerSize = CGSize(width: 30, height: 30)
        self.init(texture: GameTexture.arrowUp, color: SKColor.clear, size: playerSize)

        let physicsBody = SKPhysicsBody(texture: texture, size: playerSize)
        self.physicsBody = physicsBody
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.mass = 30
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 100)
    }

    func switchDirection() {
        switch direction {
        case .up:
            direction = .down
            self.physicsBody?.velocity = CGVector(dx: 0, dy: -200)
            self.texture = arrowDownTexture
        case .down:
            direction = .up
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 200)
            self.texture = arrowUpTexture
        }
    }
    
    func jump() {
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
    }
}

extension PlayerNode: Observer {
    func onValueChanged(_ event: Any?) {

    }
}
