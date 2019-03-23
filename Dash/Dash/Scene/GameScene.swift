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
    var scoreNode: ScoreNode!

    var gameModel: GameModel!
    var gameEngine: GameEngine!

    override func didMove(to view: SKView) {
        // Setup scene here
        initGameModel()
        initGameEngine()
        initPlayer()
        initBackground()
        initScore()
        setTemporaryWall()

        // Set physics world
        physicsWorld.gravity = CGVector(dx: 0, dy: -8)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    func initGameModel() {
        gameModel = GameModel()
    }

    func initGameEngine() {
        gameEngine = GameEngine(gameModel)
    }

    func initPlayer() {
        playerNode = PlayerNode()
        playerNode.position = CGPoint(x: 50, y: self.frame.height/2)
        self.addChild(playerNode)
    }

    func initBackground() {
        backgroundNode = BackgroundNode(self.frame)
        self.addChild(backgroundNode)
    }

    func initScore() {
        scoreNode = ScoreNode()
        scoreNode.position = CGPoint(x: 50, y: self.frame.height - 50)
        print(scoreNode.text)
        self.addChild(scoreNode)
    }

    func setTemporaryWall() {
        print(frame.height)
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
        playerNode.switchDirection()
        //playerNode.jump()
    }
}
