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

    static let gameVelocity = 11

    static let gameWidth = 1112
    static let gameHeight = 834
    static let stageWidth = gameWidth * 4

    static let powerUpSize = 50
    
    static let playerOriginX = 150
    static let playerOriginalSize = CGSize(width: 55, height: 55)
    static let playerShrinkSize = CGSize(width: 30, height: 30)
    
    static let topWallOrigin = CGPoint(x: 0, y: 600)
    static let bottomWallOrigin = CGPoint(x: 0, y: 200)
    
    // Path Generation
    static let pathTopCap = gameHeight - 100
    static let pathBotCap = 100
    static let pathTopSmoothCap = gameHeight - 250
    static let pathBotSmoothCap = 250
    static let pathInterval = 50

    static let notificationStateChange = "stateChange"
    static let notificationShrink = "shrink"
    static let notificationGhost = "ghost"
    static let notificationDash = "dash"
    static let notificationNormal = "normal"
    static let notificationCoolDown = "cooldown"

    static let arrowGravity = CGVector(dx: 0, dy: 0)
    static let flappyGravity = CGVector(dx: 0, dy: -30)
    static let glideGravity = CGVector(dx: 0, dy: -10.5)
    
    // Power Up
    static let powerUps = [PowerUpType.ghost, .dash, .shrink]
}
