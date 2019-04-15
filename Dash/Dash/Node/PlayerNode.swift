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

    convenience init(_ player: Player) {
        let playerSize = Constants.playerOriginalSize
        self.init(texture: GameTexture.arrowUp, color: SKColor.clear, size: playerSize)
        
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
            isHolding = player.isHolding
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
        default:
            break
        }
    }

    func step(_ timestamp: TimeInterval) {
        if isHolding {
            controller?.move()
        }



        /*
        if isHolding {
            physicsBody?.applyForce(CGVector(dx: 0, dy: 400))
        }

        guard let velocity = physicsBody?.velocity else {
            return
        }
        if velocity.dy > CGFloat(700) {
            physicsBody?.velocity.dy = 700
        } else if velocity.dy < CGFloat(-700) {
            physicsBody?.velocity.dy = -700
        }*/
    }
//
//    func setType(_ type: CharacterType) {
//        switch type {
//        case .arrow:
//            self.physicsBody?.affectedByGravity = false
//            self.physicsBody?.velocity = Constants.upwardVelocity
//        case .glide:
//            self.physicsBody?.affectedByGravity = true
//            self.physicsBody?.velocity = Constants.zeroVelocity
//        }
//    }
}
