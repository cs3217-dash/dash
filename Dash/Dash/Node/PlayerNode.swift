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

enum ColliderType: UInt32 {
    case Player =   0b00001
    case Obstacle = 0b00010
    case Wall =     0b00100
    case PowerUp =  0b01000
    case Coin =     0b10000
}

class PlayerNode: SKSpriteNode, Observer {
    var isHolding = false
    var controller: PlayerController?
    var playerId: String?
    var direction = Direction.goUp
    let arrowUpTexture = GameTexture.arrowUp
    let arrowDownTexture = GameTexture.arrowDown
    var isRemote = false {
        didSet {
            if isRemote {
                physicsBody?.collisionBitMask = 0
                ghost = true
                dash = true
            } else {
                physicsBody?.collisionBitMask = ColliderType.Player.rawValue
            }
        }
    }
    var ghost = false
    var dash = false

    let emitter = SKEmitterNode(fileNamed: "Bokeh")
    var ingameVelocity = 0

    convenience init(_ player: Player) {
        let playerSize = Constants.playerOriginalSize
        self.init(texture: GameTexture.arrow, color: SKColor.clear, size: playerSize)

        self.name = "player"
        let controller: PlayerController
        switch player.type {
        case .arrow:
            controller = ArrowController(playerNode: self)
        case .glide:
            controller = GlideController(playerNode: self)
        case .flappy:
            controller = FlappyController(playerNode: self)
        }
        self.controller = controller
        player.addObserver(self)
        playerId = player.id

        ingameVelocity = player.ingameVelocity
        guard let particleEmitter = emitter else {
            return
        }
        particleEmitter.position = self.position
        particleEmitter.particleSize = CGSize(width: 20, height: 20)
        particleEmitter.zPosition = 1

//        switch player.type {
//        case .flappy:
//            particleEmitter.particleBirthRate = 40
//        default:
//            particleEmitter.particleBirthRate = 80
//        }
        
        self.addGlow()
        self.addChild(particleEmitter)

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    func onValueChanged(name: String, object: Any?) {
        switch name {
        case Constants.notificationStateChange:
            guard let player = object as? Player else {
                return
            }
            controller?.isHolding = player.isHolding
        case Constants.notificationGhost:
            ghost = true
        case Constants.notificationDash:
            dash = true
        case Constants.notificationShrink:
            self.size = Constants.playerShrinkSize
        // TODO: Check if hitbox decreases. Suspect it doesnt
        case Constants.notificationNormal:
            self.size = Constants.playerOriginalSize
            ghost = false
            dash = false
        case Constants.notificationCoolDown:
            // indicate effect ending soon
            print("cooling down")
        default:
            break
        }
    }

    func step(_ timestamp: TimeInterval) {
        controller?.move()
        updateParticle()
    }
    
    func updateParticle() {
        guard let velocity = physicsBody?.velocity.dy else {
            return
        }
        let angle = atan(Double(velocity) / Double(Constants.glideVelocity * 60))
        self.zRotation = CGFloat(angle)
        emitter?.emissionAngle = CGFloat(angle + Double.pi)
    }
}
