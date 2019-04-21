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
    var isHolding = false
    var controller: PlayerController?
    var playerId: String?
    var direction = Direction.goUp
    var isRemote = false {
        didSet {
            if isRemote {
                physicsBody?.collisionBitMask = 0
                ghost = true
                dash = true
                emitter?.removeFromParent()
                alpha = Constants.ghostAlpha
            } else {
                physicsBody?.collisionBitMask = ColliderType.player.rawValue
            }
        }
    }
    var ghost = false
    var dash = false

    var emitter = SKEmitterNode(fileNamed: "Bokeh")
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

        // Set up SKEmitter
        guard let particleEmitter = emitter else {
            return
        }
        particleEmitter.position = self.position
        particleEmitter.particleSize = CGSize(width: 20, height: 20)
        particleEmitter.zPosition = 1

        particleEmitter.particleColorSequence = nil
        particleEmitter.particleColorBlendFactor = 1.0
        particleEmitter.particleColor = .white

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
        // Change appearance based on player state
        case Constants.notificationGhost:
            ghost = true
            self.alpha = 0.4
            self.emitter?.particleColor = UIColor.purple
        case Constants.notificationDash:
            dash = true
            self.emitter?.particleColor = UIColor.red
        case Constants.notificationShrink:
            self.size = Constants.playerShrinkSize
            self.emitter?.particleColor = UIColor.yellow
        case Constants.notificationNormal:
            self.size = Constants.playerOriginalSize
            ghost = false
            dash = false
            self.emitter?.particleColor = UIColor.white
            self.alpha = 1.0
        case Constants.notificationCoolDown:
            self.emitter?.particleColor = UIColor.darkGray
            let recover = SKAction.fadeAlpha(to: 0.9, duration: 0.5)
            let fade = SKAction.fadeAlpha(to: 0.3, duration: 0.5)
            let blink = SKAction.repeat(.sequence([fade, recover]), count: 2)
            self.run(blink)
        default:
            break
        }
    }

    func step(_ timestamp: TimeInterval) {
        controller?.move()
        updateParticle()
    }

    // Update player node direction
    private func updateParticle() {
        guard let velocity = physicsBody?.velocity.dy else {
            return
        }
        let angle = atan(Double(velocity) / Double(Constants.glideVelocity * 60))
        self.zRotation = CGFloat(angle)
        emitter?.emissionAngle = CGFloat(angle + Double.pi)
    }
}
