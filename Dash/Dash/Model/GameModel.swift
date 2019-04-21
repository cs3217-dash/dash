//
//  GameModel.swift
//  Dash
//
//  Created by Jie Liang Ang on 21/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

/**
 `GameModel` contains all the present game objects to be rendered,
 as well as in game information to be recoded.
 */
class GameModel: Observable {
    var observers = [ObjectIdentifier: Observation]()

    var player: Player
    var room: Room?
    var gameMode: GameMode

    var movingObjects = [MovingObject]() {
        didSet {
            notifyObservers(name: "moving", object: nil)
        }
    }

    /// Returns number of `PowerUp` collected
    var powerUpCount = 0 {
        didSet {
            notifyObservers(name: Constants.notificationPowerUpCount, object: self.powerUpCount)
        }
    }

    /// Returns number of `Coin` collected
    var coinCount = 0 {
        didSet {
            notifyObservers(name: Constants.notificationCoinCount, object: self.coinCount)
        }
    }

    var speed = Constants.glideVelocity

    var distance = 0 {
        didSet {
            notifyObservers(name: Constants.notificationDistance, object: self.distance)
        }
    }

    var time = 0.0
    var mission = Mission()

    var type: CharacterType

    init(characterType: CharacterType, gameMode: GameMode) {
        self.gameMode = gameMode
        player = Player(type: characterType)
        type = characterType
    }
}
