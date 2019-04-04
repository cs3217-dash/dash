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

    //nodes
    var playerNode: PlayerNode!
    var ghostNodes = [PlayerNode]()
    var backgroundNode: SKNode!
    var obstacleNode: SKNode!
    var wallNodes = [WallNode]()
    var scoreNode: ScoreNode!

    var line: SKShapeNode!
    var wallTop: SKShapeNode!
    var wallBot: SKShapeNode!

    // model and logic
    var gameModel: GameModel!
    var gameEngine: GameEngine!

    // gesture recognizers
    var tapGestureRecognizer: UITapGestureRecognizer!
    var longPressGestureRecognizer: UILongPressGestureRecognizer!

    override func didMove(to view: SKView) {
        // Setup scene here
        initGameModel()
        initGameEngine()
        initPlayer()
        initGhost()
        //initBackground()
        initScore()
        setTemporaryWall()
        //setWall()

        // Set physics world
        physicsWorld.gravity = CGVector(dx: 0, dy: -10)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        gameEngine.update(currentTime)
        playerNode.step(currentTime)
        for ghostNode in ghostNodes {
            ghostNode.step(currentTime)
        }
        updateScore()
        //drawWalls()
    }

    func initGameModel() {
        gameModel = GameModel()
    }

    func initGameEngine() {
        gameEngine = GameEngine(gameModel)
    }

    func initPlayer() {
        playerNode = PlayerNode(gameModel.player)
        playerNode.position = CGPoint(x: 150, y: self.frame.height / 2)
        self.addChild(playerNode)
    }

    func initGhost() {
        let ghost = Player()
        let ghostNode = PlayerNode(ghost)
        ghostNode.position = CGPoint(x: 100, y: self.frame.height / 2)

        gameModel.ghosts.append(ghost)
        ghostNodes.append(ghostNode)
        self.addChild(ghostNode)
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

    func setTemporaryWall() {
        let topWall = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 1))
        topWall.position = CGPoint(x: 0, y: frame.height)
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody!.isDynamic = false
        self.addChild(topWall)

        let bottomWall = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 1))
        bottomWall.position = CGPoint(x: 0, y: 0)
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
        bottomWall.physicsBody!.isDynamic = false
        self.addChild(bottomWall)
    }

    // Temporary. for testing purposes
    func setWall() {
        let pathGenerator = PathGenerator(100)
        let wallGenerator = WallGenerator(100)

        let path = pathGenerator.generateModel(startingX: 1500, startingY: Constants.gameHeight / 2,
                                               grad: 0.7, minInterval: 100, maxInterval: 400, range: 10000)
        let topWallPoints = wallGenerator.generateTopWallModel(path: path)
        let bottomWallPoints = wallGenerator.generateBottomWallModel(path: path)

        let topWallPath = wallGenerator.makePath(path: topWallPoints).cgPath
        let bottomWallPath = wallGenerator.makePath(path: bottomWallPoints).cgPath

        wallTop = SKShapeNode(path: topWallPath)
        wallTop.physicsBody = SKPhysicsBody(edgeChainFrom: topWallPath)
        wallTop.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        self.addChild(wallTop)

        wallBot = SKShapeNode(path: bottomWallPath)
        wallBot.physicsBody = SKPhysicsBody(edgeChainFrom: bottomWallPath)
        wallBot.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        self.addChild(wallBot)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameEngine.hold()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameEngine.release()
    }

    func updateScore() {
        scoreNode.update(Int(gameModel.distance))
    }

//    func drawWalls() {
//        let wall = gameModel.walls.removeFirst()
////        let wallNode = WallNode(wall)
//        self.addChild(wallNode)
//    }
}
