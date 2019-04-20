//
//  PowerUp.swift
//  Dash
//
//  Created by Jie Liang Ang on 7/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit

class PowerUp: Observable, MovingObject {
    var observers = [ObjectIdentifier: Observation]()
    var objectType = MovingObjectType.powerup

    var xPos: Int = Constants.gameWidth {
        didSet {
            notifyObservers(name: "xPos", object: self)
        }
    }

    var yPos: Int

    var width: Int = Constants.powerUpSize
    var height: Int = Constants.powerUpSize

    var type: PowerUpType = PowerUpType.randomType()

    init(yPos: Int) {
        self.yPos = yPos - Constants.powerUpSize / 2
    }

    func update(speed: Int) {
        xPos -= speed
    }
}
