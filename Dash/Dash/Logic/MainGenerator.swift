//
//  MainGenerator.swift
//  Dash
//
//  Created by Jie Liang Ang on 21/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class MainGenerator {
    // Generator
    let pathGenerator: PathGenerator
    let wallGenerator: WallGenerator
    let obstacleGenerator: ObstacleGenerator
    let powerUpGenerator: CollectibleGenerator
    var gameGenerator: SeededGenerator
    
    // Path and Wall Generation Information
    var pathEndPoint = Point(xVal: 0, yVal: Constants.gameHeight / 2)
    var topWallEndY = Constants.gameHeight
    var bottomWallEndY = 0
    
    // Current Stage for Obstacle Calculation
    var path = Path()
    var topWall = Wall(top: true)
    var bottomWall = Wall(top: false)
    
    var currentPath = Path()
    var currentTopWall = Wall(top: true)
    var currentBottomWall = Wall(top: false)

    // Obstacle Generation
    var canGenerateObstacle = true
    var currentObstaclePosition = Constants.stageWidth
    
    var currentPowerUpPosition = Constants.stageWidth
    
    var currentCoinPosition = Constants.stageWidth
    
    // Current generation max
    var pathMax = Constants.stageWidth
    
    var parameters: GameParameters
    
    // Object Queue
    //var queue = Queue<ObjectSet>()
    
    // Wall Set
    var queue = Queue<WallSet>()
    
    var movingObjects = [MovingObject]() {
        didSet {
            print("added")
        }
    }

    init(_ model: GameModel, seed: UInt64) {
        pathGenerator = PathGenerator(seed)
        pathGenerator.smoothing = !(model.type == .arrow)
        wallGenerator = WallGenerator(seed)
        obstacleGenerator = ObstacleGenerator(seed)
        powerUpGenerator = CollectibleGenerator(seed)
        gameGenerator = SeededGenerator(seed: seed)
        parameters = GameParameters(model.type, seed: seed)

        addToQueue()
        addToQueue()
        addToQueue()
        addToQueue()
        addToQueue()

    }

    func getNext() -> WallSet {
        currentObstaclePosition = pathMax
        pathMax += Constants.stageWidth

        if queue.isEmpty {
            addToQueue()
        } else {
            DispatchQueue.global().async {
                self.addToQueue()
            }
        }
        guard let set = queue.dequeue() else {
            fatalError()
        }
        parameters.nextStage()

        currentPath = set.path
        currentTopWall = set.topWall
        currentBottomWall = set.bottomWall

//        addObstacle()
//        addObstacle()
//        addObstacle()
        
        addCoin()
        addCoin()
        addCoin()

        return set
    }

    func addToQueue() {

        let generatedPath = pathGenerator.generateModel(startingPt: pathEndPoint, startingGrad: 0.0, prob: parameters.switchProb,
                                               range: Constants.stageWidth, inter: parameters.obstacleMaxInterval)

        let generatedTopWall = Wall(path: wallGenerator.generateTopWallModel(path: generatedPath, startingY: topWallEndY,
                                                                    minRange: parameters.topWallMin,
                                                                    maxRange: parameters.topWallMax),
                           top: true)
        let generatedBottomWall = Wall(path: wallGenerator.generateBottomWallModel(path: generatedPath, startingY: bottomWallEndY,
                                                                          minRange: parameters.botWallMin,
                                                                          maxRange: parameters.botWallMax),
                              top: false)
        
        path = generatedPath
        topWall = generatedTopWall
        bottomWall = generatedBottomWall

        pathEndPoint = Point(xVal: 0, yVal: path.lastPoint.yVal)
        topWallEndY = topWall.lastPoint.yVal
        bottomWallEndY = bottomWall.lastPoint.yVal
        
        queue.enqueue(WallSet(path: path, topWall: topWall, bottomWall: bottomWall))
    }

    func checkAndGetObject(position: Int) ->MovingObject? {
        guard let first = movingObjects.first else {
            return nil
        }
        guard position >= first.initialPos else {
            return nil
        }


        switch first.objectType {
        case .coin:
            self.addCoin()
        case .movingObstacle, .obstacle:
            self.addObstacle()
        case .powerup:
            self.addObstacle()
        default:
            break
        }


        return movingObjects.removeFirst()
    }

    func addObstacle() {
        let position = currentObstaclePosition + Int.random(in: 250...600, using: &gameGenerator)

        guard position < pathMax else {
            return
        }
        currentObstaclePosition = position

        generateObstacle(position: currentObstaclePosition)
    }

    func generateObstacle(position: Int) {
        let obstacle = obstacleGenerator.generateNextObstacle(xPos: position % Constants.stageWidth,
                                                              topWall: currentTopWall, bottomWall: currentBottomWall,
                                                              path: currentPath, width: parameters.obstacleOffset,
                                                              movingProb: parameters.movingProb)

        guard let validObstacle = obstacle else {
            print("fail")
            return
        }
        validObstacle.initialPos = position
        movingObjects.append(validObstacle)
    }
    
    func generatePowerUp(position: Int) {
        let powerUp = powerUpGenerator.generatePowerUp(xPos: position % Constants.stageWidth, path: currentPath)
        movingObjects.append(powerUp)
    }
    
    func addCoin() {
        let prob = Int.random(in: 0...100, using: &gameGenerator)
        let position = prob > 55 ? currentCoinPosition + 90 : currentCoinPosition + 800
        guard position < pathMax else {
            return
        }
        currentCoinPosition = position

        generateCoin(position: currentCoinPosition)
    }
    
    func generateCoin(position: Int) {
        let coin = powerUpGenerator.generateCoin(xPos: position % Constants.stageWidth, path: currentPath)
        coin.initialPos = position
        movingObjects.append(coin)
    }


}

struct ObjectSet {
    var objects = [MovingObject]()
}

struct WallSet{
    var path: Path
    var topWall: Wall
    var bottomWall: Wall
}
