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
    let obstacleGenerator = ObstacleGenerator()

    var gameStage = CharacterType.arrow {
        didSet {
            gameModel.player.type = gameStage
        }
    }

    init(_ model: GameModel) {
        gameModel = model
    }

    func update() {
        let increment = gameModel.speed * Constants.fps / 200
        gameModel.distance += increment
    }

    func updateObstacles() {
        for obstacle in gameModel.obstacles {
            // update obstacle
        }
        for wall in gameModel.walls {
            // update walls
        }
    }

    func tap() {
        gameModel.player.tap()
    }

    func longPress() {
        gameModel.player.longPress()
    }
}
