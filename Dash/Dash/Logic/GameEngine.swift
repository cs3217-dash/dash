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

    var generator : MainGenerator

    // Difficulty Info
    var inGameTime = 0
    var currentStageTime = 0 {
        didSet {
            if currentStageTime >= Constants.stageWidth {
                gameBegin = true

                let set = generator.getNext()
                gameModel.movingObjects.append(set.topWall)
                gameModel.movingObjects.append(set.bottomWall)

                currentStageTime = 0
            }
        }
    }

    var speed = Constants.glideVelocity
    var normalSpeed = Constants.glideVelocity

    // PowerUp
    var powerUpActivated = false
    var powerUpCooldownDistance = 0
    var powerUpEndDistance = 0

    // Missions
    var missionManager: MissionManager

    // Networking
    var gameBegin = false
    var networkManager = NetworkManager.shared
    var handlerId: Int?

    // Timer
    private var timer: Timer?

    init(_ model: GameModel, seed: UInt64) {
        // Initialise generator
        generator = MainGenerator(model, seed: seed)

        // Initialise model
        gameModel = model
        missionManager = MissionManager(mission: gameModel.mission)
        gameModel.addObserver(missionManager)

        // Set game speed
        initSpeed(type: model.type)

        startTimer()

        guard model.gameMode == .multi else {
            return
        }
        initMulti()
    }

    func initMulti() {
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

    func initSpeed(type: CharacterType) {
        if type == .arrow {
            normalSpeed = Constants.arrowVelocity
        } else if type == .flappy {
            normalSpeed = Constants.flappyVelocity
        }
        speed = normalSpeed
        generator.speed = speed
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
        checkObjects()
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

    func checkObjects() {
        guard gameBegin else {
            return
        }
        guard let object = generator.checkAndGetObject(position: inGameTime) else {
            return
        }
        if object.objectType == .powerup && powerUpActivated {
            return
        }
        gameModel.movingObjects.append(object)
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
            speed = speed * 2
            powerUpCooldownDistance = inGameTime + Constants.gameWidth * 2
            powerUpEndDistance = powerUpCooldownDistance + Constants.gameWidth
        } else {
            powerUpCooldownDistance = inGameTime + Constants.gameWidth
            powerUpEndDistance = powerUpCooldownDistance + Constants.gameWidth
        }
    }

    private func checkPowerUp() {
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
