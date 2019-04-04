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
        //initBackground()
        initScore()
        setTemporaryWall()

        let pathGenerator = PlayerDesignatedPathGenerator(100)
        let wallGenerator = WallGenerator(100)

        let points = pathGenerator.generateModel(startingX: 0, startingY: Constants.gameHeight / 2)
        let topWallPoints = wallGenerator.generateTopWallModel(arr: points)
        let bottomWallPoints = wallGenerator.generateBottomWallModel(arr: points)

        let topWallPath = wallGenerator.makePath(arr: topWallPoints).cgPath
        let bottomWallPath = wallGenerator.makePath(arr: bottomWallPoints).cgPath

        wallTop = SKShapeNode(path: topWallPath)
        wallTop.physicsBody = SKPhysicsBody(edgeChainFrom: topWallPath)
        wallTop.physicsBody?.velocity = CGVector(dx: -400, dy: 0)
        //self.addChild(wallTop)

        wallBot = SKShapeNode(path: bottomWallPath)
        wallBot.physicsBody = SKPhysicsBody(edgeChainFrom: bottomWallPath)
        wallBot.physicsBody?.velocity = CGVector(dx: -400, dy: 0)
        //self.addChild(wallBot)

        // Set physics world
        physicsWorld.gravity = CGVector(dx: 0, dy: -10)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        gameEngine.update()
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
        playerNode.position = CGPoint(x: 150, y: self.frame.height/2)
        self.addChild(playerNode)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameEngine.jump()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameEngine.fall()
    }

    func updateScore() {
        scoreNode.update(Int(gameModel.distance))
    }

    func drawWalls() {
        let wall = gameModel.walls.removeFirst()
        let wallNode = WallNode(wall)
        self.addChild(wallNode)
    }
}
