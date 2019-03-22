//
//  Player.swift
//  Dash
//
//  Created by Jie Liang Ang on 20/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class Player: Observable {
    weak var observer: Observer?

    var xCoordinate: Int = 0
    var yCoordinate: Int = 0
}
