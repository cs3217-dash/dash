//
//  BoundaryNode.swift
//  Dash
//
//  Created by Jie Liang Ang on 17/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import SpriteKit

class BoundaryNode: SKSpriteNode {

    convenience init(_ yPos: CGFloat) {
        self.init(color: UIColor.red, size: CGSize(width: 400, height: 1))
        self.position = CGPoint(x: 0, y: yPos)
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.boundary.rawValue
        self.physicsBody?.contactTestBitMask = ColliderType.boundary.rawValue
    }
}
