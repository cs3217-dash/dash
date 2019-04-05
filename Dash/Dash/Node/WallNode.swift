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
//    convenience init(_ wall: Wall) {
//        let wallPath = UIBezierPath()
//        wallPath.move(to: wall.startPoint)
//        wallPath.addLine(to: wall.endPoint)
//
//        self.init(path: wallPath.cgPath)
//
//        self.fillColor = .white
//        self.lineWidth = 10
//        self.physicsBody = SKPhysicsBody(edgeChainFrom: wallPath.cgPath)
//        self.physicsBody!.isDynamic = false
//
//        wall.observer = self
//    }

    func onValueChanged(name: String, object: Any?) {

    }
}
