//
//  ObstacleGenerator.swift
//  Dash
//
//  Created by Jie Liang Ang on 19/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class ObstacleGenerator {

    var generator: SeededGenerator

    init(_ seed: UInt64) {
        generator = SeededGenerator(seed: seed)
    }

    func generateNextObstacle(xPos: Int, topWall: Wall, bottomWall: Wall, path: Path, width: Int) -> Obstacle? {
        let num = Float.random(in: (0.0)...(1.0), using: &generator)

        //return generateObstacle(xPos: xPos, topBound: topWall.path, bottomBound: path.shift(by: width), top: true)
        //return generateObstacle(xPos: xPos, topBound: path.shift(by: -width),
        //                        bottomBound: bottomWall.path, top: false)

        if num < 0.5 {
            return generateObstacle(xPos: xPos, topBound: topWall.path, bottomBound: path.shift(by: width), top: true)
        } else {
            return generateObstacle(xPos: xPos, topBound: path.shift(by: -width),
                                    bottomBound: bottomWall.path, top: false)
        }
    }

    func generateObstacle(xPos: Int, topBound: Path, bottomBound: Path, top: Bool) -> Obstacle? {
        let range = 75
        let topPoints = topBound.getAllPointsFrom(from: xPos, to: min(topBound.length, xPos + range))
        let botPoints = bottomBound.getAllPointsFrom(from: xPos, to: min(bottomBound.length, xPos + range))

        let maxY = topPoints.reduce(Constants.gameHeight) { (result, next) -> Int in
            return min(result, next.yVal)
        }
        let minY = botPoints.reduce(0) { (result, next) -> Int in
            return max(result, next.yVal)
        }

        let candidateY = maxY - minY

        guard candidateY > 20 else {
            return nil
        }

        let size = min(candidateY, range)

        var pos: Int
        if top {
            pos = minY
        } else {
            if size == range {
                let diff = candidateY - range
                pos = minY + diff
            } else {
                pos = minY
            }
        }
        
//        va pos = top ? minY : minY
        
        let type: MovingObjectType
        let num = Float.random(in: (0.0)...(1.0), using: &generator)
        type = (num < 0.8) ? .obstacle : .movingObstacle

        return Obstacle(yPos: pos, width: size, height: size, objectType: type)
    }
}
