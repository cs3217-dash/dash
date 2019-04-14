//
//  Obstacle.swift
//  Dash
//
//  Created by Jie Liang Ang on 20/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit

class Obstacle: Observable, MovingObject {
    var observers = [ObjectIdentifier : Observer]()
    var objectType = MovingObjectType.obstacle

    var xPos: Int = Constants.gameWidth {
        didSet {
            notifyObservers(name: "xPos", object: self)
        }
    }

    var yPos: Int

    var width: Int
    var height: Int

    init(yPos: Int, width: Int, height: Int, objectType: MovingObjectType) {
        self.yPos = yPos
        self.width = width
        self.height = height
        self.objectType = objectType
    }

    func update(speed: Int) {
        xPos -= speed
    }
}
