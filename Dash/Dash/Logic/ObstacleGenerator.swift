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

        if num < 0.5 {
            return generateObstacle(xPos: xPos, topBound: topWall.path, bottomBound: path.shift(by: width), top: true)
        } else {
            return generateObstacle(xPos: xPos, topBound: path.shift(by: -width),
                                    bottomBound: bottomWall.path, top: false)
        }
    }

    func generateObstacle(xPos: Int, topBound: Path, bottomBound: Path, top: Bool) -> Obstacle? {
        let range = 150
        let topPoints = topBound.getAllPointsFrom(from: xPos, to: xPos + range)
        let botPoints = bottomBound.getAllPointsFrom(from: xPos, to: xPos + range)

        let maxY = topPoints.reduce(Constants.gameHeight) { (result, next) -> Int in
            return min(result, next.yVal)
        }
        let minY = botPoints.reduce(0) { (result, next) -> Int in
            return max(result, next.yVal)
        }

        guard maxY - minY > 20 else {
            return nil
        }

        let size = min(maxY - minY, range) - 30

        guard size > 20 else {
            return nil
        }

        let pos = top ? minY : minY + 30

        return Obstacle(yPos: pos, width: size, height: size)
    }
}
