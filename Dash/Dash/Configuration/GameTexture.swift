//
//  GameTexture.swift
//  Dash
//
//  Created by Jie Liang Ang on 23/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import SpriteKit

class GameTexture {
    static let arrowUp = SKTexture(imageNamed: "arrow1.png")
    static let arrowDown = SKTexture(imageNamed: "arrow2.png")
    static let arrow = SKTexture(imageNamed: "arrow3.png")
    static let sampleBackground = SKTexture(imageNamed: "background.png")
    static let yellowGradientBG = SKTexture(imageNamed: "YellowGradient")
    static let redGradientBG = SKTexture(imageNamed: "RedGradient")
    static let greenGradientBG = SKTexture(imageNamed: "GreenGradient")
    static let blueGradientBG = SKTexture(imageNamed: "BlueGradient")

    static let topUpperCave = SKTexture(imageNamed: "TopUpperCave")
    static let topLowerCave = SKTexture(imageNamed: "TopLowerCave")
    static let bottomUpperCave = SKTexture(imageNamed: "BottomUpperCave")
    static let bottomLowerCave = SKTexture(imageNamed: "BottomLowerCave")

    static let caveWithLight = SKTexture(imageNamed: "CaveWithLight")

    static let obstacle1 = SKTexture(imageNamed: "Obstacle1")
    static let obstacle2 = SKTexture(imageNamed: "Obstacle2")
    static let obstacle3 = SKTexture(imageNamed: "Obstacle3")
    static let obstacle4 = SKTexture(imageNamed: "Obstacle4")
    static let obstacle5 = SKTexture(imageNamed: "Obstacle5")
    static let obstacles = [obstacle1, obstacle2, obstacle3, obstacle4, obstacle5]
    static let movingObstacle = SKTexture(imageNamed: "MovingObstacle")

    static func getObstacleTexture() -> SKTexture {
        let index = Int(arc4random_uniform(UInt32(obstacles.count)))
        return obstacles[index]
    }
    
    static let greenGem = SKTexture(imageNamed: "GreenGemSmall")
    static let yellowGem = SKTexture(imageNamed: "YellowGemSmall")
    static let purpleGem = SKTexture(imageNamed: "PurpleGemSmall")
    static let pinkGem = SKTexture(imageNamed: "PinkGemSmall")
}
