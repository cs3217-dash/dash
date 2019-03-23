//
//  GameEngine.swift
//  Dash
//
//  Created by Jie Liang Ang on 21/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class GameEngine {
    var gameModel: GameModel

    var gameStage = GameStage.arrow {
        didSet {
            //do something
        }
    }

    init(_ model: GameModel) {
        gameModel = model
    }

    func update() {
        gameModel.distance += Int(gameModel.speed * Constants.fps)
    }
}
