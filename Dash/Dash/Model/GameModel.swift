//
//  GameModel.swift
//  Dash
//
//  Created by Jie Liang Ang on 21/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class GameModel: Observable {
    weak var observer: Observer?

    var player: Player
    var ghosts = [Player]()

    var obstacles = [Obstacle]() {
        didSet {
            observer?.onValueChanged(name: "obstacle", object: nil)
        }
    }

    var walls = [Wall]() {
        didSet {
            observer?.onValueChanged(name: "wall", object: nil)
        }
    }

    var speed = Constants.gameVelocity
    var distance = 0.0
    var time = 0.0
    var currentStage = Stage(id: 1)

    init(characterType: CharacterType) {
        player = Player(type: characterType)
    }
}
