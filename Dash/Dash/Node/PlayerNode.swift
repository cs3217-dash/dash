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
    var isHolding = false
    var controller: PlayerController

    convenience init(_ player: Player) {
        let playerSize = CGSize(width: 55, height: 55)
        let controller: PlayerController
        switch player.type {
        case .arrow:
            controller = ArrowController()
        case .jetpack:
            controller = JetpackController()
        case .flappy:
            controller = FlappyController()
        }
        self.init(texture: GameTexture.arrowUp, color: SKColor.clear, size: playerSize, controller: controller)
        self.physicsBody = controller.physicsBodyCopy
        player.observer = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private init(texture: SKTexture?, color: UIColor, size: CGSize, controller: PlayerController) {
        self.controller = controller
        super.init(texture: texture, color: color, size: size)
    }

    func onValueChanged(name: String, object: Any?) {
        guard let player = object as? Player else {
            return
        }

        isHolding = player.isHolding
    }

    func step(_ timestamp: TimeInterval) {
        if isHolding {
            controller.move()
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
