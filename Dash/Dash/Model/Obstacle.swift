//
//  Obstacle.swift
//  Dash
//
//  Created by Jie Liang Ang on 20/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit

class Obstacle: Observable {
    var observer: Observer?

    var xPos: Int
    var yPos: Int

    var width: Int
    var height: Int

    init(xPos: Int, yPos: Int, width: Int, height: Int) {
        self.xPos = xPos
        self.yPos = yPos
        self.width = width
        self.height = height
    }

    func update(speed: Int) {
        xPos -= speed
    }
}
