//
//  Obstacle.swift
//  Dash
//
//  Created by Jie Liang Ang on 20/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class Obstacle: Observable {
    var observer: Observer?

    var xCoordinate: Int = 0
    var yCoordinate: Int = 0
}
