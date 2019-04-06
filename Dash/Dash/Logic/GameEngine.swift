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

    var inGameTime = 0

    var difficulty = 0

    // Generator
    let pathGenerator = PathGenerator(100)
    let wallGenerator = WallGenerator(100)

    init(_ model: GameModel) {
        gameModel = model
    }

    func update(_ absoluteTime: TimeInterval) {
        if startTime == 0.0 {
            startTime = absoluteTime
        }
        currentTime = absoluteTime - startTime
        gameModel.time = currentTime
        //updateWalls()
        gameModel.player.step(currentTime)
        for ghost in gameModel.ghosts {
            ghost.step(currentTime)
        }

        gameModel.distance += gameModel.speed

        inGameTime += 1
    }

    func generateWall() {
        let path = pathGenerator.generateModel(startingX: 1500, startingY: Constants.gameHeight / 2,
                                               grad: 0.7, minInterval: 100, maxInterval: 400, range: 10000)
        let topWallPoints = wallGenerator.generateTopWallModel(path: path)
        let bottomWallPoints = wallGenerator.generateBottomWallModel(path: path)

        let topWall = Wall(path: topWallPoints)
        let bottomWall = Wall(path: bottomWallPoints)

        gameModel.walls.append(topWall)
        gameModel.walls.append(bottomWall)
    }

    func updateWalls() {
        for wall in gameModel.walls {
            wall.xPos -= Int(Constants.gameVelocity)
        }
    }

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
