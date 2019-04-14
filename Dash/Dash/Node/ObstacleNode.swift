//
//  ObstacleNode.swift
//  Dash
//
//  Created by Jie Liang Ang on 18/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import SpriteKit

class ObstacleNode: SKSpriteNode, Observer {

    convenience init(obstacle: Obstacle) {
        self.init(color: UIColor.white,
                  size: CGSize(width: obstacle.width, height: obstacle.height))

        self.position = CGPoint(x: obstacle.xPos + obstacle.width / 2,
                                y: obstacle.yPos + obstacle.height / 2)

        self.name = "obstacle"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.Obstacle.rawValue
        self.physicsBody?.contactTestBitMask = ColliderType.Player.rawValue
        self.physicsBody?.collisionBitMask = 0
        
        obstacle.addObserver(self)
    }

    func onValueChanged(name: String, object: Any?) {
        guard let obstacle = object as? Obstacle else {
            return
        }

        DispatchQueue.main.async {
            switch name {
            case "xPos":
                self.position = CGPoint(x: obstacle.xPos + obstacle.width / 2,
                                        y: obstacle.yPos + obstacle.height / 2)
            default:
                return
            }
        }
    }
}
