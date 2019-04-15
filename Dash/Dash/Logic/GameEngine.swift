//
//  GameEngine.swift
//  Dash
//
//  Created by Jie Liang Ang on 21/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit

class GameEngine {
    var gameModel: GameModel

    var currentTime = 0.0

    // Difficulty Info
    var inGameTime = 0
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
    var currentStageLength = 1400
    var difficulty = 0
    var speed = Constants.gameVelocity

    var pathEndPoint = Point(xVal: 0, yVal: Constants.gameHeight / 2)
    var topWallEndY = Constants.gameHeight
    var bottomWallEndY = 0

    // Timer
    private var timer: Timer?

    // Generator
    let pathGenerator2 = PathGeneratorV2(100)
    let wallGenerator = WallGenerator(100)
    var obstacleGenerator = ObstacleGenerator(100)
    let powerUpGenerator = PowerUpGenerator(100)
    var gameGenerator = SeededGenerator(seed: 100)

    // Current Stage for Obstacle Calculation
    var currentPath = Path()
    var currentTopWall = Wall()
    var currentBottomWall = Wall()
    var nextObstaclePosition = 2000
    var canGenerateObstacle = true
    var nextPowerUpPosition = 4000
    
    // Dash
    var powerUp = false
    var powerUpCooldownDistance = 0
    var powerUpEndDistance = 0

    // Missions
    var missionManager: MissionManager

    // Networking
    var gameBegin = false
    var networkManager = NetworkManager.shared
    var handlerId: Int?

    init(_ model: GameModel) {
        gameModel = model
        missionManager = MissionManager(mission: gameModel.mission)
        gameModel.addObserver(missionManager)

        switch model.type {
        case .arrow:
            pathGenerator2.smoothing = false
        default:
            pathGenerator2.smoothing = true
        }
        startTimer()

        guard model.gameMode == .multi else {
            return
        }
        _initMulti()
    }

    func _initMulti() {
        handlerId = networkManager.addActionHandler { [weak self] (peerID, action) in
            self?.gameModel.room?.players.forEach { (player) in
                guard player.id == peerID else {
                    return
                }
                switch action.type {
                case .hold:
                    player.actionList.append(Action(time: action.time + 0.1, type: .hold))
                case .release:
                    player.actionList.append(Action(time: action.time + 0.1, type: .release))
                default:
                    break
                }
            }
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: Constants.fps, target: self,
                                     selector: #selector(updateGame), userInfo: nil, repeats: true)
    }

    func pause() {
        timer?.invalidate()
    }

    @objc func updateGame() {
        generateGameObjects()
        updatePositions()
        checkDash()
    }

    func update(_ deltaTime: Double, _ currentTime: Double) {
        self.currentTime = currentTime
        gameModel.time = currentTime
        gameModel.player.step(currentTime)

        if let room = gameModel.room {
            for player in room.players {
                player.step(currentTime)
            }
        }
    }

    func updatePositions() {
        //checkMovingObstacle()
        updateGameObjects(speed: speed)

        gameModel.distance += speed
        inGameTime += speed
        currentStageTime += speed
    }

    func generateGameObjects() {

        if canGenerateObstacle && inGameTime >= nextObstaclePosition {
            generateObstacle()
            nextObstaclePosition = inGameTime + Int.random(in: 300...900, using: &gameGenerator)
        }

        if inGameTime >= nextPowerUpPosition {
            generatePowerUp()
            nextPowerUpPosition = inGameTime + Int.random(in: 2000...6000, using: &gameGenerator)
        }
    }

    func updateGameObjects(speed: Int) {
        // Update moving objects position
        for object in gameModel.movingObjects {
            switch object.objectType {
            case .movingObstacle:
                object.update(speed: speed * 2)
            default:
                object.update(speed: speed)
            }
        }
        //
        gameModel.movingObjects = gameModel.movingObjects.filter {
            $0.xPos > -$0.width - 100
        }
    }

    func checkMovingObstacle() {
        guard let obstacle = gameModel.movingObstacleQueue.peek() else {
            return
        }
        if obstacle.xPos == inGameTime {
            obstacle.xPos = Constants.gameWidth * 2 - Constants.playerOriginX
            gameModel.movingObjects.append(obstacle)
            gameModel.movingObstacleQueue.dequeue()
        }
    }

    func generateObstacle() {
        let obstacle = obstacleGenerator.generateNextObstacle(xPos: currentStageTime,
                                                              topWall: currentTopWall, bottomWall: currentBottomWall,
                                                              path: currentPath, width: 100)

        guard let validObstacle = obstacle else {
            return
        }

        switch validObstacle.objectType {
        case .obstacle:
            gameModel.movingObjects.append(validObstacle)
        case .movingObstacle:
            validObstacle.xPos = Constants.gameWidth * 2 - Constants.playerOriginX
            gameModel.movingObjects.append(validObstacle)
            //gameModel.movingObstacleQueue.enqueue(validObstacle)
        default:
            break
        }
    }

    func generatePowerUp() {
        let powerUp = powerUpGenerator.generatePowerUp(xPos: currentStageTime, path: currentPath)
        gameModel.movingObjects.append(powerUp)
    }

    func generateWall() {

        let path = pathGenerator2.generateModel(startingPt: pathEndPoint, startingGrad: 0.0, prob: 0.3, range: 2000)

        let topWall = Wall(path: wallGenerator.generateTopWallModel(path: path, startingY: topWallEndY,
                                                                    minRange: 300, maxRange: 300))
        let bottomWall = Wall(path: wallGenerator.generateBottomWallModel(path: path, startingY: bottomWallEndY,
                                                                          minRange: -300, maxRange: -300))

        gameModel.movingObjects.append(topWall)
        gameModel.movingObjects.append(bottomWall)

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

    func triggerPowerUp(type: PowerUpType) {
        guard !powerUp else {
            return
        }
        gameModel.player.state = type
        powerUp = true

        if type == .dash {
            speed = Constants.gameVelocity + 20
            powerUpCooldownDistance = inGameTime + 5000
            powerUpEndDistance = powerUpCooldownDistance + 1000
        } else {
            powerUpCooldownDistance = inGameTime + 2000
            powerUpEndDistance = powerUpCooldownDistance + 200
        }
    }

    func checkDash() {
        guard powerUp else {
            return
        }
        if inGameTime >= powerUpEndDistance {
            gameModel.player.state = .normal
            powerUp = false
        } else if inGameTime >= powerUpCooldownDistance {
            if gameModel.player.state == .dash {
                speed = Constants.gameVelocity
            }
        }
    }

    func hold(_ position: CGPoint, _ velocity: CGVector) {
        let action = Action(time: currentTime, type: .hold)
        action.position = position
        action.velocity = velocity
        gameModel.player.actionList.append(action)

        guard gameModel.gameMode == .multi else {
            return
        }
        networkManager.sendAction(action)
    }

    func release(_ position: CGPoint, _ velocity: CGVector) {
        let action = Action(time: currentTime, type: .release)
        action.position = position
        action.velocity = velocity
        gameModel.player.actionList.append(action)

        guard gameModel.gameMode == .multi else {
            return
        }
        networkManager.sendAction(action)
    }
}
