//
//  GameModel.swift
//  Dash
//
//  Created by Jie Liang Ang on 21/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class GameModel {
    var player = Player(type: CharacterType.arrow)
    var obstacles = [Obstacle]()
    var walls = [Wall]()
    var speed = Constants.initialVelocity
    var distance = 0.0
}
