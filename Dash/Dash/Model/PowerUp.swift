//
//  PowerUp.swift
//  Dash
//
//  Created by Jie Liang Ang on 7/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit

enum PowerUpType {
    case ghost, magnet, dash
}

class PowerUp: Observable {
    var observers = [ObjectIdentifier : Observer]()

    var xPos: Int = Constants.gameWidth {
        didSet {
            notifyObservers(name: "xPos", object: self)
        }
    }

    var yPos: Int

    var width: Int = Constants.powerUpSize
    var height: Int = Constants.powerUpSize

    var type: PowerUpType = .ghost

    init(yPos: Int) {
        self.yPos = yPos
    }

    func update(speed: Int) {
        xPos -= speed
    }
}
