//
//  GameEngine.swift
//  Dash
//
//  Created by Jie Liang Ang on 21/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class GameEngine {
    var startTime = 0.0
    var currentTime = 0.0
    var gameModel: GameModel
    let obstacleGenerator = ObstacleGenerator()

    init(_ model: GameModel) {
        gameModel = model
    }

    func update(_ absoluteTime: TimeInterval) {
        if startTime == 0.0 {
            startTime = absoluteTime
        }
        currentTime = absoluteTime - startTime
        gameModel.distance += gameModel.speed * Constants.fps / 200
        gameModel.time = currentTime
        updateObstacles()
        //updateWalls()
        gameModel.player.step(currentTime)
        for ghost in gameModel.ghosts {
            ghost.step(currentTime)
        }
    }

    func updateObstacles() {
        for obstacle in gameModel.obstacles {
            // update obstacle
        }
    }

//    func updateWalls() {
//        let nextWalls = wallGenerator.generateNextWalls()
//        gameModel.walls.append(nextWalls.top)
//        gameModel.walls.append(nextWalls.bottom)
//
//        for wall in gameModel.walls {
//            // update walls
//        }
//    }

    func hold() {
        gameModel.player.actionList.append(
            Action(stage: gameModel.currentStage, time: currentTime, type: .hold))
        gameModel.ghosts[0].actionList.append(
            Action(stage: gameModel.currentStage, time: currentTime + 0.15, type: .hold))
    }

    func release() {
        gameModel.player.actionList.append(
            Action(stage: gameModel.currentStage, time: currentTime, type: .release))
        gameModel.ghosts[0].actionList.append(
            Action(stage: gameModel.currentStage, time: currentTime + 0.15, type: .release))
    }
}
