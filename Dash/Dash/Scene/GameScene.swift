//
//  GameScene.swift
//  Dash
//
//  Created by Jie Liang Ang on 18/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    //nodes
    var playedNode: SKSpriteNode!
    var backgroundNode: SKNode!
    var obstacleNode: SKNode!

    override func didMove(to view: SKView) {
        // Setup scene here
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
