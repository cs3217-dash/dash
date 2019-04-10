//
//  GameModel.swift
//  Dash
//
//  Created by Jie Liang Ang on 21/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class GameModel: Observable {
    var observers = [ObjectIdentifier : Observer]()

    var player: Player
    var ghosts = [Player]()

    var obstacles = [Obstacle]() {
        didSet {
            notifyObservers(name: "obstacle", object: nil)
        }
    }

    var walls = [Wall]() {
        didSet {
            notifyObservers(name: "wall", object: nil)
        }
    }

    var movingObstacleQueue = Queue<Obstacle>()

    var powerUps = [PowerUp]() {
        didSet {
            notifyObservers(name: "powerup", object: nil)
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
