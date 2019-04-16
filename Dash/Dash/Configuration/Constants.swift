//
//  Constants.swift
//  Dash
//
//  Created by Jie Liang Ang on 19/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Constants {
    static let yVelocity = 500
    static let upwardVelocity = CGVector(dx: 0, dy: yVelocity)
    static let downwardVelocity = CGVector(dx: 0, dy: -yVelocity)
    static let zeroVelocity = CGVector(dx: 0, dy: 0)
    static let fps: Double = 1/60
    static let gravity = -10.0
    static let maxVelocity = 500

    static let glideVelocity = 12
    static let arrowVelocity = 13
    static let flappyVelocity = 10

    static let gameWidth = 1112
    static let gameHeight = 834
    static let stageWidth = 2400

    static let powerUpSize = 50
    
    static let playerOriginX = 150
    static let playerOriginalSize = CGSize(width: 55, height: 55)
    static let playerShrinkSize = CGSize(width: 30, height: 30)
    
    static let topWallOrigin = CGPoint(x: 0, y: 600)
    static let bottomWallOrigin = CGPoint(x: 0, y: 200)
    
    // Path Generation
    static let pathTopCap = gameHeight - 75
    static let pathBotCap = 75
    static let pathTopSmoothCap = gameHeight - 200
    static let pathBotSmoothCap = 200
    static let pathInterval = 50
    static let pathMinInterval = 100
    static let pathMaxInterval = 450

    static let notificationStateChange = "stateChange"
    static let notificationShrink = "shrink"
    static let notificationGhost = "ghost"
    static let notificationDash = "dash"
    static let notificationNormal = "normal"
    static let notificationCoolDown = "cooldown"

    static let arrowGravity = CGVector(dx: 0, dy: 0)
    static let flappyGravity = CGVector(dx: 0, dy: -20)
    static let glideGravity = CGVector(dx: 0, dy: -10.5)
    
    // Power Up
    static let powerUps = [PowerUpType.ghost, .dash, .shrink]

    static let roomIdLength = 6
    static let highScoreLimit = 10
}
