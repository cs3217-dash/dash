//
//  ObstacleGenerator.swift
//  Dash
//
//  Created by Jie Liang Ang on 19/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

/**
 `ObstacleGenerator` handles generation of `Wall`
 */
class ObstacleGenerator {

    var generator: SeededGenerator

    init(_ seed: UInt64) {
        generator = SeededGenerator(seed: seed)
    }

    /// Generate obstacle based on two bounds and path
    /// - Parameters:
    ///     - xPos: starting position of obstacle
    ///     - topWall: upper Wall in game
    ///     - bottomWall: bottom Wall in game
    ///     - path: Path in game
    ///     - width: width of path
    func generateNextObstacle(xPos: Int, topWall: Wall, bottomWall: Wall, path: Path, width: Int) -> Obstacle? {
        let num = Float.random(in: (0.0)...(1.0), using: &generator)
        // Decide to place obstacle at upper or lower of path
        if num < 0.5 {
            return generateObstacle(xPos: xPos, topBound: topWall.path, bottomBound: path.shift(by: width), top: true)
        } else {
            return generateObstacle(xPos: xPos, topBound: path.shift(by: -width),
                                    bottomBound: bottomWall.path, top: false)
        }
    }

    private func generateObstacle(xPos: Int, topBound: Path, bottomBound: Path, top: Bool) -> Obstacle? {

        let type: MovingObjectType
        let num = Float.random(in: (0.0)...(1.0), using: &generator)
        type = (num < 0.8) ? .obstacle : .movingObstacle
        let range = (num < 0.8) ? 75 : 40

        let topPoints = topBound.getAllPointsFrom(from: xPos, to: min(topBound.length, xPos + range))
        let botPoints = bottomBound.getAllPointsFrom(from: xPos, to: min(bottomBound.length, xPos + range))

        let maxY = topPoints.reduce(Constants.gameHeight) { (result, next) -> Int in
            return min(result, next.yVal)
        }
        let minY = botPoints.reduce(0) { (result, next) -> Int in
            return max(result, next.yVal)
        }

        let candidateY = maxY - minY

        guard candidateY > 30 else {
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

        return Obstacle(yPos: pos, width: size, height: size, objectType: type)
    }
}
