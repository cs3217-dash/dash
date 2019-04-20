//
//  Coin.swift
//  Dash
//
//  Created by Jie Liang Ang on 16/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class Coin: Observable, MovingObject {
    var objectType: MovingObjectType = .coin

    var observers = [ObjectIdentifier: Observation]()

    var xPos: Int = Constants.gameWidth {
        didSet {
            notifyObservers(name: "xPos", object: self)
        }
    }

    var yPos: Int

    var width: Int = Constants.powerUpSize
    var height: Int = Constants.powerUpSize

    init(yPos: Int) {
        self.yPos = yPos - Constants.powerUpSize / 2
    }

    func update(speed: Int) {
        xPos -= speed
    }
}
