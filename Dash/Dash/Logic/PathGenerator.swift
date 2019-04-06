//
//  PathGenerator.swift
//  Dash
//
//  Created by Jie Liang Ang on 28/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import GameplayKit

class PathGenerator {

    var generator: SeededGenerator

    init(_ seed: UInt64) {
        generator = SeededGenerator(seed: seed)
    }

    func generateModel(startingPt: Point, grad: Double,
                       minInterval: Int, maxInterval: Int, range: Int) -> Path {

        let startingX = startingPt.xVal
        let startingY = startingPt.yVal

        var path = Path()
        path.append(xVal: startingX, yVal: startingY)

        var currentX = startingX
        var currentY = startingY

        let endX = currentX + range

        while currentX < endX {
            let nextPoint = generateNextPoint(currX: currentX, currY: currentY, grad: grad,
                                              minInterval: minInterval, maxInterval: maxInterval,
                                              endX: endX)

            currentX = nextPoint.xVal
            currentY = nextPoint.yVal
            path.append(point: nextPoint)
        }
        path.length = range

        return path
    }

    private func generateNextPoint(currX: Int, currY: Int, grad: Double,
                                   minInterval: Int, maxInterval: Int, endX: Int) -> Point {
        var nextX = currX + Int.random(in: minInterval...maxInterval, using: &generator)

        if nextX > endX {
            nextX = endX
        }

        let maxY = min(Constants.gameHeight - 100, currY + Int(grad * Double(nextX - currX)))
        let minY = max(0 + 100, currY - Int(grad * Double(nextX - currX)))

        let nextY = Int.random(in: minY...maxY, using: &generator)

        return Point(xVal: nextX, yVal: nextY)
    }

    func makePath(arr: [Point]) -> UIBezierPath {
        return UIBezierPath(points: arr)
    }
}
