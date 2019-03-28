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
    let wallGenerator = WallGenerator()

    init(_ model: GameModel) {
        gameModel = model
    }

    func update() {
        gameModel.distance += gameModel.speed * Constants.fps / 200
        updateObstacles()
        //updateWalls()
        gameModel.player.update()
    }

    func updateObstacles() {
        for obstacle in gameModel.obstacles {
            // update obstacle
        }
    }

    func updateWalls() {
        let nextWalls = wallGenerator.generateNextWalls()
        gameModel.walls.append(nextWalls.top)
        gameModel.walls.append(nextWalls.bottom)

        for wall in gameModel.walls {
            // update walls
        }
    }

    func jump() {
        gameModel.player.isJumping = true
    }

    func fall() {
        gameModel.player.isJumping = false
    }
}
