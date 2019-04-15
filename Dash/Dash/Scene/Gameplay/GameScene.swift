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
    var pauseWindow: SKSpriteNode!

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
    private let networkManager = NetworkManager.shared
    private var handlerId: Int?
    private var pendingActions = [(ghostNode: PlayerNode, action: Action)]()
    private var startTime = 0.0
    private var currentTime = 0.0

    override func didMove(to view: SKView) {
        // Setup scene here
        initGameModel()
        initGameEngine()
        initPlayer()
        initGhost()
        //initBackground()
        initScore()
        initMission()
        initPauseButton()
        
        print(characterType.rawValue)
        // Set physics world
        switch characterType {
        case .arrow:
            physicsWorld.gravity = Constants.arrowGravity
        case .flappy:
            physicsWorld.gravity = Constants.flappyGravity
        case .jetpack:
            physicsWorld.gravity = Constants.jetpackGravity
        }

        physicsWorld.contactDelegate = self

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if ((contact.bodyA.categoryBitMask == ColliderType.Obstacle.rawValue) || (contact.bodyB.categoryBitMask == ColliderType.Obstacle.rawValue)
            || (contact.bodyA.categoryBitMask == ColliderType.Wall.rawValue) || (contact.bodyB.categoryBitMask == ColliderType.Wall.rawValue)) {
            // Game Over
            gameEngine.pause()
            presentGameOverScene()
            print("game over")
        }
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

    func initGameEngine() {
        gameEngine = GameEngine(gameModel)
    }

    func initPlayer() {
        playerNode = PlayerNode(gameModel.player)
        playerNode.position = CGPoint(x: CGFloat(Constants.playerOriginX), y: self.frame.height / 2)
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

    func initBackground() {
        backgroundNode = BackgroundNode(self.frame)
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
            gameEngine.pause()
            showPauseWindow()
        case "continue":
            self.removeChildren(in: [pauseWindow])
            gameEngine.start()
        default:
            gameEngine.hold(CGPoint(x: 0, y: Double(position.y) / frameHeight), velocity)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let frameHeight = Double(self.frame.height)
        let position = playerNode.position
        guard let velocity = playerNode.physicsBody?.velocity else {
            return
        }
        gameEngine.release(CGPoint(x: 0, y: Double(position.y) / frameHeight), velocity)
    }

    func updateScore() {
        scoreNode.update(Int(gameModel.distance))
    }

    private func showPauseWindow() {
        pauseWindow = SKSpriteNode(color: SKColor.black, size: self.frame.size)
        pauseWindow.name = "continue"
        pauseWindow.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        pauseWindow.alpha = 0.8
        pauseWindow.zPosition = 50

        let pausedLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        pausedLabel.text = "P A U S E D"
        pausedLabel.fontSize = 60
        pausedLabel.position = CGPoint(x: 0, y: 0)
        pauseWindow.addChild(pausedLabel)

        let continueLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        continueLabel.text = "tap to continue the game"
        continueLabel.fontSize = 20
        continueLabel.position = CGPoint(x: 0, y: -60)
        pauseWindow.addChild(continueLabel)

        self.addChild(pauseWindow)
    }

    private func presentGameOverScene() {
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.currentCharacterType = characterType
        gameOverScene.currentPlayerActions = gameModel.player.actionList
        gameOverScene.score = gameModel.distance // TODO: calculate score with powerups and coins
        self.view?.presentScene(gameOverScene, transition: SKTransition.crossFade(withDuration: 0.5))
    }
}
