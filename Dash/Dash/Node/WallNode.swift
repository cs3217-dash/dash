//
//  Wall.swift
//  Dash
//
//  Created by Jie Liang Ang on 19/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import SpriteKit

class WallNode: SKShapeNode, Observer {

    convenience init(wall: Wall) {
        let path = wall.path.generateBezierPath().cgPath
        self.init(path: path)

        self.lineWidth = 5
        self.physicsBody?.isDynamic = false
        self.position = CGPoint(x: wall.xPos, y: wall.yPos)

        self.name = "wall"
        self.physicsBody = SKPhysicsBody(edgeChainFrom: path)
        self.physicsBody?.categoryBitMask = ColliderType.Wall.rawValue
        self.physicsBody?.contactTestBitMask = 0
        self.physicsBody?.collisionBitMask = 0

        wall.addObserver(self)
    }

    func onValueChanged(name: String, object: Any?) {
        guard let wall = object as? Wall else {
            return
        }

        DispatchQueue.main.async {
            switch name {
            case "xPos":
                self.position = CGPoint(x: wall.xPos, y: wall.yPos)
            default:
                return
            }
        }
    }
}
