//
//  GameScene.swift
//  Dash
//
//  Created by Jie Liang Ang on 18/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    // game nodes
    var playerNode: PlayerNode!
    var ghostNodes = [PlayerNode]()
    var backgroundNode: SKNode!
    var obstacleNode: SKNode!
    var scoreNode: ScoreNode!
    var missionNode: MissionNode!

    // menu
    var pauseButton: SKSpriteNode!
    var pauseWindow: SKSpriteNode?
    var countdownLabel: SKLabelNode!

    // model and logic
    var gameModel: GameModel!
    var gameEngine: GameEngine!
    var gameMode: GameMode = .single
    var room: Room?

    // Mapping of Model to Node
    var movingObjects: [ObjectIdentifier: SKNode] = [:]

    // gesture recognizers
    var tapGestureRecognizer: UITapGestureRecognizer!
    var longPressGestureRecognizer: UILongPressGestureRecognizer!

    var characterType = CharacterType.arrow
    var clockTime = -1.0
    private let networkManager = NetworkManager.shared
    private var handlerId: Int?
    private var pendingActions = [(ghostNode: PlayerNode, action: Action)]()
    private var startTime = 0.0
    private var currentTime = 0.0
    private var isStarted = true

    override func didMove(to view: SKView) {
        // Setup scene here
        initGameModel()
        initGameEngine(seed: 100)
        initPlayer()
        initGhost()
        initBackground(type: characterType)
        initScore()
        initMission()
        initPauseButton()
        initCountdownLabel()

        print(characterType.rawValue)
        // Set physics world
        switch characterType {
        case .arrow:
            physicsWorld.gravity = Constants.arrowGravity
        case .flappy:
            physicsWorld.gravity = Constants.flappyGravity
        case .glide:
            physicsWorld.gravity = Constants.glideGravity
        }

        physicsWorld.contactDelegate = self
        backgroundColor = .darkGray

        if clockTime > 0 {
            pause()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let isBodyAObstacle = contact.bodyA.categoryBitMask == ColliderType.Obstacle.rawValue
        let isBodyAWall = contact.bodyA.categoryBitMask == ColliderType.Wall.rawValue
        let isBodyBObstacle = contact.bodyB.categoryBitMask == ColliderType.Obstacle.rawValue
        let isBodyBWall = contact.bodyB.categoryBitMask == ColliderType.Wall.rawValue

        if isBodyAObstacle || isBodyAWall {
            guard let playerNode = contact.bodyB.node as? PlayerNode else {
                return
            }
            guard (isBodyAObstacle && (!playerNode.ghost && !playerNode.dash))
                || (isBodyAWall && !playerNode.dash) else {
                return
            }
            playerNode.removeFromParent()
            gameOver()
        } else if isBodyBObstacle || isBodyBWall {
            guard let playerNode = contact.bodyA.node as? PlayerNode else {
                return
            }
            guard (isBodyBObstacle && (!playerNode.ghost && !playerNode.dash))
                || (isBodyBWall && !playerNode.dash) else {
                    return
            }
            playerNode.removeFromParent()
            gameOver()
        } else if (contact.bodyA.categoryBitMask == ColliderType.PowerUp.rawValue) {
            guard let node = contact.bodyA.node as? PowerUpNode else {
                return
            }
            print(node.type)
            gameEngine.triggerPowerUp(type: node.type)
            node.removeFromParent()
        } else if (contact.bodyB.categoryBitMask == ColliderType.PowerUp.rawValue) {
            guard let node = contact.bodyB.node as? PowerUpNode else {
                return
            }
            print(node.type)
            gameEngine.triggerPowerUp(type: node.type)
            node.removeFromParent()
        } else if (contact.bodyA.categoryBitMask == ColliderType.Coin.rawValue) {
            guard let node = contact.bodyA.node as? CoinNode else {
                return
            }
            node.removeFromParent()
        } else if (contact.bodyB.categoryBitMask == ColliderType.Coin.rawValue) {
            guard let node = contact.bodyB.node as? CoinNode else {
                return
            }
            node.removeFromParent()
        }
    }

    private func gameOver() {
        gameEngine.stopTimer()
        // TODO: check if score makes it to leaderboard
        //presentGameOverScene()
        presentEnterLeaderBoardScene()
        print("game over")
    }

    override func update(_ absoluteTime: TimeInterval) {
        if startTime == 0.0 {
            startTime = absoluteTime
        }
        let nextTime = absoluteTime - startTime
        let deltaTime = nextTime - currentTime
        currentTime = nextTime

        // Called before each frame is rendered
        gameEngine.update(deltaTime, currentTime)
        playerNode.step(currentTime)
        for ghostNode in ghostNodes {
            ghostNode.step(currentTime)
        }
        updateScore()

        let frameHeight = Double(self.frame.height)
        pendingActions = pendingActions.filter { (ghostNode, action) in
            guard currentTime > action.time + 0.1, (action.type == .ping ||
                action.type == .hold || action.type == .release) else {
                    return true
            }
            ghostNode.position = CGPoint(x: 100, y: frameHeight * Double(action.position.y))
            ghostNode.physicsBody?.velocity = action.velocity
            return false
        }

        if clockTime > 0 {
            let timeNow = Date().timeIntervalSince1970 * 1000
            if timeNow > clockTime {
                clockTime = -1
                countdownLabel.alpha = 0
                resume()
            } else {
                let countdown = Int(ceil((clockTime - timeNow) / 1000))
                countdownLabel.text = String(countdown)
            }
        }

        guard let velocity = playerNode.physicsBody?.velocity else {
            return
        }
        if Int.random(in: 1...120) == 60 {
            let action = Action(time: currentTime, type: .ping)
            let yPosition = Double(playerNode.position.y) / frameHeight
            action.position = CGPoint(x: 0, y: yPosition)
            action.velocity = velocity
            networkManager.sendAction(action)
        }
    }

    func initGameModel() {
        gameModel = GameModel(characterType: characterType, gameMode: gameMode)
        gameModel.addObserver(self)
        gameModel.room = room
    }

    func initGameEngine(seed: UInt64) {
        gameEngine = GameEngine(gameModel, seed: seed)
    }

    func initPlayer() {
        playerNode = PlayerNode(gameModel.player)
        playerNode.position = CGPoint(x: CGFloat(Constants.playerOriginX), y: self.frame.height / 2)
        playerNode.emitter?.targetNode = self
        self.addChild(playerNode)
    }

    func initGhost() {
        guard let room = room else {
            return
        }

        room.players.forEach { player in
            let ghostNode = PlayerNode(player)
            ghostNode.position = CGPoint(x: 100, y: self.frame.height / 2)
            ghostNode.isRemote = true
            ghostNodes.append(ghostNode)
            self.addChild(ghostNode)
        }

        guard gameMode == .multi else {
            return
        }

        // TODO: Memory leak -> Remove action handler in deinit etc
        handlerId = networkManager.addActionHandler { [weak self] (peerID, action) in
            self?.ghostNodes.forEach { ghostNode in
                guard ghostNode.playerId == peerID, (action.type == .ping ||
                    action.type == .hold || action.type == .release) else {
                        return
                }
                self?.pendingActions.append((ghostNode, action))
            }
        }
    }

    func initBackground(type: CharacterType) {
        backgroundNode = BackgroundNode(self.frame, type: type)
        self.addChild(backgroundNode)
    }

    func initScore() {
        scoreNode = ScoreNode()
        scoreNode.position = CGPoint(x: 100, y: self.frame.height - 70)
        self.addChild(scoreNode)
    }

    func initMission() {
        missionNode = MissionNode(mission: gameModel.mission)
        missionNode.position = CGPoint(x: self.frame.midX, y: 0)
        self.addChild(missionNode)
    }

    func initPauseButton() {
        pauseButton = SKSpriteNode(color: SKColor.white,
                                       size: CGSize(width: 40, height: 40))
        pauseButton.name = "pause"
        pauseButton.position = CGPoint(x: self.frame.width - 70, y: self.frame.height - 70)
        pauseButton.zPosition = 10
        self.addChild(pauseButton)
    }

    func initCountdownLabel() {
        countdownLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        countdownLabel.name = "countdown"
        countdownLabel.text = ""
        countdownLabel.fontSize = 80
        countdownLabel.position = CGPoint(x: self.frame.midX,
                                          y: self.frame.midY - countdownLabel.frame.height / 2)
        self.addChild(countdownLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let frameHeight = Double(self.frame.height)
        let position = playerNode.position
        guard let velocity = playerNode.physicsBody?.velocity,
            let location = touches.first?.location(in: self) else {
                return
        }

        let nodes = self.nodes(at: location)

        switch nodes.first?.name {
        case "pause":
            pause()
            showPauseWindow()
        case "continue":
            resume()
        default:
            guard isStarted else {
                return
            }
            gameEngine.hold(CGPoint(x: 0, y: Double(position.y) / frameHeight), velocity)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let frameHeight = Double(self.frame.height)
        let position = playerNode.position
        guard let velocity = playerNode.physicsBody?.velocity,
            let location = touches.first?.location(in: self) else {
                return
        }

        let nodes = self.nodes(at: location)
        switch nodes.first?.name {
        case "menu":
            presentMenuScene()
        default:
            guard isStarted else {
                return
            }
            gameEngine.release(CGPoint(x: 0, y: Double(position.y) / frameHeight), velocity)
        }
    }

    func updateScore() {
        scoreNode.update(Int(gameModel.distance))
    }

    private func showPauseWindow() {
        pauseWindow = SKSpriteNode(color: SKColor.black, size: self.frame.size)
        guard let pauseWindow = pauseWindow else {
            return
        }
        pauseWindow.name = "continue"
        pauseWindow.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        pauseWindow.alpha = 0.8
        pauseWindow.zPosition = 50

        let pausedLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        pausedLabel.name = "continue"
        pausedLabel.text = "P A U S E D"
        pausedLabel.fontSize = 60
        pausedLabel.position = CGPoint(x: 0, y: 0)
        pauseWindow.addChild(pausedLabel)

        let continueLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        continueLabel.name = "continue"
        continueLabel.text = "tap to continue the game"
        continueLabel.fontSize = 20
        continueLabel.position = CGPoint(x: 0, y: -60)
        pauseWindow.addChild(continueLabel)

        // TOOD: replace icon + text with image
        let returnToMenuButton = SKSpriteNode(color: SKColor.white,
                                              size: CGSize(width: 40, height: 40))
        returnToMenuButton.name = "menu"
        returnToMenuButton.position = CGPoint(
            x: -pauseWindow.frame.width / 2 + 70,
            y: pauseWindow.frame.height / 2 - 70)
        returnToMenuButton.zPosition = 51
        pauseWindow.addChild(returnToMenuButton)

        let returnToMenuLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        returnToMenuLabel.name = "menu"
        returnToMenuLabel.text = "return to menu"
        returnToMenuLabel.fontSize = 20
        returnToMenuLabel.position = CGPoint(
            x: (returnToMenuLabel.frame.width + returnToMenuButton.frame.width) / 2 + 20,
            y: -5)
        returnToMenuButton.addChild(returnToMenuLabel)

        self.addChild(pauseWindow)
    }

    private func presentGameOverScene() {
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.currentCharacterType = characterType
        gameOverScene.currentPlayerActions = gameModel.player.actionList
        gameOverScene.score = gameModel.distance // TODO: calculate score with powerups and coins
        self.view?.presentScene(gameOverScene, transition: SKTransition.fade(with: .white, duration: 0.5))
    }

    private func presentEnterLeaderBoardScene() {
        let enterLeaderboardScene = EnterLeaderboardScene(size: self.size)
        enterLeaderboardScene.incomingScore = gameModel.distance

        switch characterType {
        case .arrow:
            enterLeaderboardScene.incomingCategory = .arrow
        case .flappy:
            enterLeaderboardScene.incomingCategory = .flappy
        case .glide:
            enterLeaderboardScene.incomingCategory = .glide
        }
        self.view?.presentScene(enterLeaderboardScene, transition: SKTransition.fade(with: .white, duration: 0.5))
    }

    private func presentMenuScene() {
        let menuScene = MainMenuScene(size: self.size)
        self.view?.presentScene(menuScene)
    }

    private func pause() {
        isStarted = false
        gameEngine.stopTimer()
        self.physicsWorld.speed = 0
    }

    private func resume() {
        isStarted = true
        if let pauseWindow = pauseWindow {
            self.removeChildren(in: [pauseWindow])
        }
        gameEngine.startTimer()
        self.physicsWorld.speed = 1
    }
}
