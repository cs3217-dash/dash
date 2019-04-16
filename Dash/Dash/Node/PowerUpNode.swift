//
//  PowerUpNode.swift
//  Dash
//
//  Created by Jie Liang Ang on 7/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import SpriteKit

class PowerUpNode: SKSpriteNode, Observer {

    var type: PowerUpType = .ghost
    
    convenience init(powerUp: PowerUp) {
        let texture: SKTexture
        switch powerUp.type {
        case .dash:
            texture = GameTexture.pinkGem
        case .ghost:
            texture = GameTexture.purpleGem
        default:
            texture = GameTexture.yellowGem
        }
        self.init(texture: texture, size: CGSize(width: powerUp.width, height: powerUp.height))

        self.type = powerUp.type

        self.position = CGPoint(x: powerUp.xPos + powerUp.width / 2,
                                y: powerUp.yPos + powerUp.height / 2)

        self.name = "powerup"

        self.physicsBody = SKPhysicsBody(texture: texture,
                                         size: CGSize(width: powerUp.width,
                                                      height: powerUp.height))
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.PowerUp.rawValue
        self.physicsBody?.contactTestBitMask = ColliderType.Player.rawValue
        self.physicsBody?.collisionBitMask = 0

        self.addGlow()

        powerUp.addObserver(self)
    }

    func onValueChanged(name: String, object: Any?) {
        guard let powerUp = object as? PowerUp else {
            return
        }

        DispatchQueue.main.async {
            switch name {
            case "xPos":
                self.position = CGPoint(x: powerUp.xPos + powerUp.width / 2,
                                        y: powerUp.yPos + powerUp.height / 2)
            default:
                return
            }
        }
    }
}

extension SKSpriteNode {
    func addGlow(radius: Float = 20) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture, size: size))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius":radius])
    }
}
