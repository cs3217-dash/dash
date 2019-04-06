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
    var scoreNode: ScoreNode!

    // model and logic
    var gameModel: GameModel!
    var gameEngine: GameEngine!
    
    // Mapping of Model to Node
    var walls: [ObjectIdentifier: WallNode] = [:]

    // gesture recognizers
    var tapGestureRecognizer: UITapGestureRecognizer!
    var longPressGestureRecognizer: UILongPressGestureRecognizer!

    var characterType = CharacterType.arrow

    override func didMove(to view: SKView) {
        // Setup scene here
        initGameModel()
        initGameEngine()
        initPlayer()
        initGhost()
        //initBackground()
        initScore()

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
        gameModel = GameModel(characterType: characterType)
        gameModel.observer = self
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
        let ghost = Player(type: .arrow)
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

//    func setTemporaryWall() {
//        let topWall = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 1))
//        topWall.position = CGPoint(x: 0, y: frame.height)
//        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
//        topWall.physicsBody!.isDynamic = false
//        self.addChild(topWall)
//
//        let bottomWall = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 1))
//        bottomWall.position = CGPoint(x: 0, y: 0)
//        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
//        bottomWall.physicsBody!.isDynamic = false
//        self.addChild(bottomWall)
//    }
//

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameEngine.hold()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameEngine.release()
    }

    func updateScore() {
        scoreNode.update(Int(gameModel.distance))
    }
}

extension GameScene: Observer {
    func onValueChanged(name: String, object: Any?) {
        switch name {
        case "wall":
            // Add new walls
            for wall in gameModel.walls where walls[ObjectIdentifier(wall)] == nil {
                let wallNode = WallNode(wall: wall)
                self.addChild(wallNode)
                walls[ObjectIdentifier(wall)] = wallNode
            }
            // Remove walls
            // Object identifier of all present walls in gameModel
            let wallOids = gameModel.walls.map { ObjectIdentifier($0) }

            // Remove wallNodes that are not in the gameModel
            for wallOid in walls.keys where !wallOids.contains(wallOid) {
                guard let wallNode = walls[wallOid] else {
                    continue
                }
                wallNode.removeFromParent()
                walls.removeValue(forKey: wallOid)
            }
        default:
            break
        }
    }
}
