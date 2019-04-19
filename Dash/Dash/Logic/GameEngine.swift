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
                currentStageLength = Constants.stageWidth
                difficulty += 1
                parameters.nextStage()
            }
        }
    }
    var currentStageLength = 1400
    var difficulty = 0
    var speed = Constants.glideVelocity
    var normalSpeed = Constants.glideVelocity
    var parameters: GameParameters

    // Path and Wall Generation Information
    var pathEndPoint = Point(xVal: 0, yVal: Constants.gameHeight / 2)
    var topWallEndY = Constants.gameHeight
    var bottomWallEndY = 0

    // Generator
    let pathGenerator: PathGeneratorV2
    let wallGenerator: WallGenerator
    let obstacleGenerator: ObstacleGenerator
    let powerUpGenerator: PowerUpGenerator
    var gameGenerator: SeededGenerator

    // Current Stage for Obstacle Calculation
    var currentPath = Path()
    var currentTopWall = Wall(top: true)
    var currentBottomWall = Wall(top: false)
    
    // Object Generation Information
    var canGenerateObstacle = true
    var nextObstaclePosition = 2000
    
    // PowerUp
    var powerUpActivated = false
    var nextPowerUpPosition = 6000
    var powerUpCooldownDistance = 0
    var powerUpEndDistance = 0
    
    // Coin
    var coinActivated = false
    var nextCoinPosition = 4000

    // Missions
    var missionManager: MissionManager

    // Networking
    var gameBegin = false
    var networkManager = NetworkManager.shared
    var handlerId: Int?

    // Timer
    private var timer: Timer?

    init(_ model: GameModel, seed: UInt64) {
        //Initialise generator
        pathGenerator = PathGeneratorV2(seed)
        pathGenerator.smoothing = !(model.type == .arrow)
        wallGenerator = WallGenerator(seed)
        obstacleGenerator = ObstacleGenerator(seed)
        powerUpGenerator = PowerUpGenerator(seed)
        gameGenerator = SeededGenerator(seed: seed)

        if model.type == .arrow {
            normalSpeed = Constants.arrowVelocity
        } else if model.type == .flappy {
            normalSpeed = Constants.flappyVelocity
        }
        speed = normalSpeed

        //Initialise model
        gameModel = model
        missionManager = MissionManager(mission: gameModel.mission)
        gameModel.addObserver(missionManager)
        parameters = GameParameters(model.type, seed: seed)

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
                    player.actionList.append(Action(time: action.time + 0.2, type: .hold))
                case .release:
                    player.actionList.append(Action(time: action.time + 0.2, type: .release))
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

    func stopTimer() {
        timer?.invalidate()
    }

    @objc func updateGame() {
        checkPowerUp()
        generateGameObjects()
        updatePositions()
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
        updateGameObjects(speed: speed)

        gameModel.distance += Int(speed / 10)
        inGameTime += speed
        currentStageTime += speed
    }

    func updateGameObjects(speed: Int) {
        for object in gameModel.movingObjects {
            switch object.objectType {
            case .movingObstacle:
                object.update(speed: speed * 2)
            default:
                object.update(speed: speed)
            }
        }
        gameModel.movingObjects = gameModel.movingObjects.filter {
            $0.xPos > -$0.width - 100
        }
    }
}

// MARK: Object Generation
extension GameEngine {
    private func generateGameObjects() {
        // Check and generate obstacles
        if canGenerateObstacle && inGameTime >= nextObstaclePosition {
            generateObstacle()
            nextObstaclePosition = inGameTime + Int.random(in: 250...600, using: &gameGenerator)
        }
        // Check and generate power up
        if !powerUpActivated && !coinActivated && inGameTime >= nextPowerUpPosition {
            generatePowerUp()
            nextPowerUpPosition = inGameTime + Int.random(in: 5000...8000, using: &gameGenerator)
        }
        // Check and generate coin
        // TODO: Improve coin generation algorithm
        if !powerUpActivated && inGameTime >= nextCoinPosition {
            generateCoin()
            let prob = Int.random(in: 0...100, using: &gameGenerator)
            nextCoinPosition = prob > 55 ? inGameTime + 90 : inGameTime + 800
        }
    }

    private func generateObstacle() {
        let obstacle = obstacleGenerator.generateNextObstacle(xPos: currentStageTime,
                                                              topWall: currentTopWall, bottomWall: currentBottomWall,
                                                              path: currentPath, width: parameters.obstacleOffset,
                                                              movingProb: parameters.movingProb)

        guard let validObstacle = obstacle else {
            return
        }

        switch validObstacle.objectType {
        case .obstacle:
            gameModel.movingObjects.append(validObstacle)
        case .movingObstacle:
            validObstacle.xPos = Constants.gameWidth * 2 - Constants.playerOriginX
            gameModel.movingObjects.append(validObstacle)
        default:
            break
        }
    }

    func generatePowerUp() {
        let powerUp = powerUpGenerator.generatePowerUp(xPos: currentStageTime, path: currentPath)
        gameModel.movingObjects.append(powerUp)
    }

    func generateCoin() {
        let coin = powerUpGenerator.generateCoin(xPos: currentStageTime, path: currentPath)
        gameModel.movingObjects.append(coin)
    }

    func generateWall() {

        let path = pathGenerator.generateModel(startingPt: pathEndPoint, startingGrad: 0.0, prob: parameters.switchProb,
                                               range: Constants.stageWidth, inter: parameters.obstacleMaxInterval)

        let topWall = Wall(path: wallGenerator.generateTopWallModel(path: path, startingY: topWallEndY,
                                                                    minRange: parameters.topWallMin, maxRange: parameters.topWallMax),
                           top: true)
        let bottomWall = Wall(path: wallGenerator.generateBottomWallModel(path: path, startingY: bottomWallEndY,
                                                                          minRange: parameters.botWallMin, maxRange: parameters.botWallMax),
                              top: false) 

        gameModel.movingObjects.append(topWall)
        gameModel.movingObjects.append(bottomWall)
        
//        let actual = Wall(path: wallGenerator.generateTopWallModel(path: path, startingY: pathEndPoint.yVal,
//                                                                    minRange: 0, maxRange: 0))
//        gameModel.movingObjects.append(actual)

        currentPath = path
        currentTopWall = topWall
        currentBottomWall = bottomWall

        pathEndPoint = Point(xVal: 0, yVal: path.lastPoint.yVal)
        topWallEndY = topWall.lastPoint.yVal
        bottomWallEndY = bottomWall.lastPoint.yVal
    }
}

// MARK: Power Up Handling
extension GameEngine {
    func triggerPowerUp(type: PowerUpType) {
        guard !powerUpActivated else {
            return
        }
        updatePlayerState(to: type)
        powerUpActivated = true
        gameModel.powerUpCount += 1

        if type == .dash {
            speed = Constants.glideVelocity + 20
            powerUpCooldownDistance = inGameTime + 5000
            powerUpEndDistance = powerUpCooldownDistance + 1500
        } else {
            powerUpCooldownDistance = inGameTime + 2000
            powerUpEndDistance = powerUpCooldownDistance + 1000
        }
    }

    func checkPowerUp() {
        guard powerUpActivated else {
            return
        }
        if inGameTime >= powerUpEndDistance {
            updatePlayerState(to: .normal)
            powerUpActivated = false
        } else if inGameTime >= powerUpCooldownDistance {
            if gameModel.player.state == .dash {
                speed = normalSpeed
                updatePlayerState(to: .cooldown)
            } else if gameModel.player.state != .cooldown {
                updatePlayerState(to: .cooldown)
            }
        }
    }

    private func updatePlayerState(to state: PowerUpType) {
        let action = Action(time: currentTime, type: .powerup)
        action.powerUp = state
        gameModel.player.actionList.append(action)

        guard gameModel.gameMode == .multi else {
            return
        }
        networkManager.sendAction(action)

        // TODO: This might need to fix but both using different time
        // inGameTime vs absoluteTime
    }
}

// MARK: Player Controls
extension GameEngine {
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
