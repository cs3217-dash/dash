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
    var room: Room?
    var gameMode: GameMode

    var powerUpCount = 0 {
        didSet {
            notifyObservers(name: Constants.notificationPowerUpCount, object: self.powerUpCount)
        }
    }

    var coinCount = 0 {
        didSet {
            notifyObservers(name: Constants.notificationCoinCount, object: self.coinCount)
        }
    }

    var movingObjects = [MovingObject]() {
        didSet {
            notifyObservers(name: "moving", object: nil)
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
