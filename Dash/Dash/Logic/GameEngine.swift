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

    // Difficulty Info
    var difficulty = 0
    var currentStageTime = 0 {
        didSet {
            if currentStageTime >= currentStageLength {
                gameBegin = true
                generateWall()

                currentStageTime = 0
                currentStageLength = 2000
                difficulty += 1
            }
        }
    }
    var currentStageLength = 800

    var pathEndPoint = Point(xVal: 0, yVal: Constants.gameHeight / 2)
    var topWallEndY = Constants.gameHeight
    var bottomWallEndY = 0

    // Generator
    let pathGenerator = PathGenerator(100)
    let pathGenerator2 = PathGeneratorV2(100)
    let wallGenerator = WallGenerator(100)
    let obstacleGenerator = ObstacleGenerator(100)
    let powerUpGenerator = PowerUpGenerator(100)

    // Current Stage for Obstacle Calculation
    var currentPath = Path()
    var currentTopWall = Wall()
    var currentBottomWall = Wall()

    var gameBegin = false
    var networkManager = NetworkManager.shared

    init(_ model: GameModel) {
        gameModel = model

        networkManager.onEvent("hold") { [weak self] _, obj in
            guard let self = self, let time = obj as? Double else {
                return
            }
            self.gameModel.ghosts[0].actionList.append(
                Action(stage: self.gameModel.currentStage, time: time, type: .hold))
        }

        networkManager.onEvent("release") { [weak self] _, obj in
            guard let self = self, let time = obj as? Double else {
                return
            }
            self.gameModel.ghosts[0].actionList.append(
                Action(stage: self.gameModel.currentStage, time: time, type: .release))
        }
    }

    func update(_ absoluteTime: TimeInterval) {
        if startTime == 0.0 {
            startTime = absoluteTime
        }
        let nextTime = absoluteTime - startTime
        let deltaTime = nextTime - currentTime
        currentTime = nextTime

        gameModel.time = currentTime

        gameModel.player.step(currentTime)
        for ghost in gameModel.ghosts {
            ghost.step(currentTime)
        }

        checkMovingObstacle()
        updateWalls(speed: Constants.gameVelocity)
        updateObstacles(speed: Constants.gameVelocity)

        let increment = deltaTime * Constants.gameVelocity * 60

        gameModel.distance += increment

        inGameTime += Int(increment)
        currentStageTime += Int(increment)

        // TODO: Generate at random instances
        if gameBegin && currentStageTime != 0 &&
            currentStageTime != currentStageLength && currentStageTime % 330 == 0 {
            generateObstacle()
        }
    }

    func updateWalls(speed: Double) {
        // Update wall position
        for wall in gameModel.walls {
            wall.update(speed: Int(Constants.gameVelocity))
        }
        // Remove walls that are out of bound
        gameModel.walls = gameModel.walls.filter {
            $0.xPos > -$0.width - 100
        }
    }

    func updateObstacles(speed: Double) {
        for obstacle in gameModel.obstacles {
            obstacle.update(speed: Int(Constants.gameVelocity))
        }

        gameModel.obstacles = gameModel.obstacles.filter {
            $0.xPos > -$0.width - 100
        }
    }

    func checkMovingObstacle() {
        guard let obstacle = gameModel.movingObstacleQueue.peek() else {
            return
        }
        if obstacle.xPos == inGameTime {
            obstacle.xPos = Constants.gameWidth * 2 - Constants.playerOriginX
            gameModel.obstacles.append(obstacle)
            gameModel.movingObstacleQueue.dequeue()
        }
    }

    func generateObstacle() {
        let obstacle = obstacleGenerator.generateNextObstacle(xPos: currentStageTime,
                                                              topWall: currentTopWall, bottomWall: currentBottomWall,
                                                              path: currentPath, width: 75)

        guard let validObstacle = obstacle else {
            return
        }
        
        switch validObstacle.type {
        case .stationary:
            validObstacle.velocity = Int(Constants.gameVelocity)
            gameModel.obstacles.append(validObstacle)
        case .moving:
            validObstacle.xPos = inGameTime
            validObstacle.velocity = Int(Constants.gameVelocity) * 2
            gameModel.movingObstacleQueue.enqueue(validObstacle)
        }
    }

    func generatePowerUp() {
        let powerUp = powerUpGenerator.generatePowerUp(xPos: currentStageTime, path: currentPath)
        gameModel.powerUp.append(powerUp)
    }

    func generateWall() {
        // TODO: Alter parameters by difficulty
//        let path = pathGenerator.generateModel(startingPt: pathEndPoint,
//                                               grad: 0.7, minInterval: 100, maxInterval: 400, range: 2000)

        let path = pathGenerator2.generateModel(startingPt: pathEndPoint, startingGrad: 0.0, switchProb: 0.7, range: 2000)

        let topWall = Wall(path: wallGenerator.generateTopWallModel(path: path, startingY: topWallEndY,
                                                                    minRange: 200, maxRange: 400))
        let bottomWall = Wall(path: wallGenerator.generateBottomWallModel(path: path, startingY: bottomWallEndY,
                                                                          minRange: -400, maxRange: -200))

        gameModel.walls.append(topWall)
        gameModel.walls.append(bottomWall)

        // Testing purposes
        //let topBound = Wall(path: wallGenerator.generateTopBound(path: path, startingY: topWallEndY, by: 0))
//        let bottomBound = Wall(path: wallGenerator.generateBottomBound(path: path, startingY: bottomWallEndY, by: 50))
        //gameModel.walls.append(topBound)
//        gameModel.walls.append(bottomBound)

        currentPath = path
        currentTopWall = topWall
        currentBottomWall = bottomWall

        pathEndPoint = Point(xVal: 0, yVal: path.lastPoint.yVal)
        topWallEndY = topWall.lastPoint.yVal
        bottomWallEndY = bottomWall.lastPoint.yVal
    }

    func hold() {
        gameModel.player.actionList.append(
            Action(stage: gameModel.currentStage, time: currentTime, type: .hold))
        networkManager.sendEventToEveryone("hold", time: currentTime)
    }

    func release() {
        gameModel.player.actionList.append(
            Action(stage: gameModel.currentStage, time: currentTime, type: .release))
        networkManager.sendEventToEveryone("release", time: currentTime)
    }
}
