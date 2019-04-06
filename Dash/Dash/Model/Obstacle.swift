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

    var xPos: Int = Constants.gameWidth {
        didSet {
            observer?.onValueChanged(name: "xPos", object: self)
        }
    }

    var yPos: Int

    var width: Int
    var height: Int

    init(yPos: Int, width: Int, height: Int) {
        self.yPos = yPos
        self.width = width
        self.height = height
    }

    func update(speed: Int) {
        xPos -= speed
    }
}
