//
//  GameEngine.swift
//  Dash
//
//  Created by Jie Liang Ang on 21/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit

/**
 `GameEngine` handles the main game logic, including updating the game object positions,
 as well as handling power up and linking with `NetworkManager`
 */
class GameEngine {
    private var gameModel: GameModel
    private var generator : MainGenerator
    private var missionManager: MissionManager

    // Stage game time info
    private var inGameTime = 0
    private var currentStageTime = 0 {
        didSet {
            if currentStageTime >= Constants.stageWidth {
                gameBegin = true
                // Get walls of new stage
                let set = generator.getNext()
                gameModel.movingObjects.append(set.topWall)
                gameModel.movingObjects.append(set.bottomWall)
                currentStageTime = 0
            }
        }
    }
    private var currentTime = 0.0

    private var speed = Constants.glideVelocity
    private var normalSpeed = Constants.glideVelocity

    // PowerUp
    private var powerUpActivated = false
    private var powerUpCooldownDistance = 0
    private var powerUpEndDistance = 0

    // Networking
    private var gameBegin = false
    private var networkManager = NetworkManager.shared
    private var handlerId: Int?

    // Timer
    private var timer: Timer?

    init(_ model: GameModel, seed: UInt64) {
        // Initialise generator
        generator = MainGenerator(model, seed: seed)

        // Initialise model and mission manager
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

    private func initMulti() {
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

    /// Initialise in game speed
    /// - Parameters:
    ///     - type: `CharacterType` describes player control type in game
    private func initSpeed(type: CharacterType) {
        switch type {
        case .arrow: normalSpeed = Constants.arrowVelocity
        case .flappy: normalSpeed = Constants.flappyVelocity
        case.glide: normalSpeed = Constants.glideVelocity
        }
        speed = normalSpeed
        generator.speed = normalSpeed
    }

    /// Begin game engine timer
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: Constants.fps, target: self,
                                     selector: #selector(updateGame), userInfo: nil, repeats: true)
    }

    /// Stop or pause game engine timer
    func stopTimer() {
        timer?.invalidate()
    }

    @objc private func updateGame() {
        checkPowerUp()
        checkObjectsToGenerate()
        updatePositionsAndTime()
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

    /// Update positions of all moving objects and distance in `GameModel`, and in game time.
    private func updatePositionsAndTime() {
        updateGameObjects(speed: speed)
        gameModel.distance += Int(speed / 10)

        inGameTime += speed
        currentStageTime += speed
    }

    /// Update positions of all moving objects in `GameModel`
    private func updateGameObjects(speed: Int) {
        for object in gameModel.movingObjects {
            switch object.objectType {
            case .movingObstacle:
                object.update(speed: speed * 2)
            default:
                object.update(speed: speed)
            }
        }
        // Remove objects that are out of screen
        gameModel.movingObjects = gameModel.movingObjects.filter {
            $0.xPos > -$0.width - 100
        }
    }

    /// Generate moving objects in game from generator
    private func checkObjectsToGenerate() {
        guard gameBegin else {
            return
        }
        // Get all objects from generator to be added
        while let object = generator.checkAndGetObject(position: inGameTime) {
            // Do not generate power up if power up is currently activated
            if object.objectType == .powerup && powerUpActivated {
                continue
            }
            gameModel.movingObjects.append(object)
        }
    }
}

// MARK: Power Up Handling
extension GameEngine {
    /// Trigger a power up effect
    /// - Parameters:
    ///     - type: type of `PowerUp`
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
            powerUpCooldownDistance = inGameTime + Constants.gameWidth * 2
            powerUpEndDistance = powerUpCooldownDistance + Constants.gameWidth
        }
    }

    /// Update game state when power up is activated
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
