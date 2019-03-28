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

    static let initialVelocity = 3000.0

    static let topWallOrigin = CGPoint(x: 0, y: 600)
    static let bottomWallOrigin = CGPoint(x: 0, y: 200)

    static let notificationStateChange = "stateChange"
}
