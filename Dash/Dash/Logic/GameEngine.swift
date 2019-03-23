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

    var gameStage = GameStage.arrow {
        didSet {
            //do something
        }
    }

    init(_ model: GameModel) {
        gameModel = model
    }

    func update() {
        let update = gameModel.speed * Constants.fps / 200
        gameModel.distance += update
    }

    func updateObstacles() {
        for obstacle in gameModel.obstacles {
            // update obstacle
        }
    }

    func tap() {
        gameModel.player.tap()
    }

    func longPress() {

    }
}
