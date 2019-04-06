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

    var pathEndPoint = Point(xVal: 0, yVal: Constants.gameHeight / 2)
    var topWallEnd = Point(xVal: 0, yVal: Constants.gameHeight)
    var bottomWallEnd = Point(xVal: 0, yVal: 0)

    var currentStageTime = 0 {
        didSet {
            if currentStageTime >= currentStageLength {
                generateWall()

                currentStageTime = 0
                currentStageLength = 5000
            }
        }
    }
    var currentStageLength = 1000

    // Generator
    let pathGenerator = PathGenerator(100)
    let wallGenerator = WallGenerator(100)

    // Current Stage for Obstacle Calculation
    var currentPath: Path?
    var currentTopWall: Wall?
    var currentBottomWall: Wall?

    init(_ model: GameModel) {
        gameModel = model
    }

    func update(_ absoluteTime: TimeInterval) {
        if startTime == 0.0 {
            startTime = absoluteTime
        }
        currentTime = absoluteTime - startTime
        gameModel.time = currentTime
        updateWalls()
        gameModel.player.step(currentTime)
        for ghost in gameModel.ghosts {
            ghost.step(currentTime)
        }

        gameModel.distance += Constants.gameVelocity

        inGameTime += Int(Constants.gameVelocity)
        currentStageTime += Int(Constants.gameVelocity)
    }

    func updateWalls() {
        for wall in gameModel.walls {
            wall.update(speed: Int(Constants.gameVelocity))
        }

        gameModel.walls = gameModel.walls.filter {
            $0.xPos > -$0.length - 100
        }
    }

    func generateWall() {
        let path = pathGenerator.generateModel(startingPt: pathEndPoint,
                                               grad: 0.7, minInterval: 100, maxInterval: 400, range: 5000)
        let topWall = Wall(path: wallGenerator.generateTopWallModel(path: path))
        let bottomWall = Wall(path: wallGenerator.generateBottomWallModel(path: path))

        gameModel.walls.append(topWall)
        gameModel.walls.append(bottomWall)

        currentPath = path
        currentTopWall = topWall
        currentBottomWall = bottomWall
        pathEndPoint = Point(xVal: 0, yVal: path.lastPoint.yVal)
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
