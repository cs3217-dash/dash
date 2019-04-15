//
//  WallGenerator.swift
//  Dash
//
//  Created by Jie Liang Ang on 21/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit

/**
 `PathGeneratorV2` handles generation of `Wall`
 */
class WallGenerator {

    var generator: SeededGenerator

    init(_ seed: UInt64) {
        generator = SeededGenerator(seed: seed)
    }

    func generateTopWallModel(path: Path, startingY: Int, minRange: Int, maxRange: Int) -> Path {
        return generateNoise(path: path, range: minRange...maxRange, startingY: startingY)
    }

    func generateBottomWallModel(path: Path, startingY: Int, minRange: Int, maxRange: Int) -> Path {
        return generateNoise(path: path, range: (minRange)...(maxRange), startingY: startingY)
    }

    func generateTopBound(path: Path, startingY: Int, by shift: Int) -> Path {
        return path.shift(by: shift)
    }

    func generateBottomBound(path: Path, startingY: Int, by shift: Int) -> Path {
        return path.shift(by: -shift)
    }

    func makePath(path: Path) -> UIBezierPath {
        return path.generateBezierPath()
    }

    private func generateNoise(path: Path, range: ClosedRange<Int>, startingY: Int) -> Path {
        let points = path.points

        var noisePoints = points.map {
            shiftPoint(point: $0, by: range)
        }
        noisePoints[0] = Point(xVal: noisePoints[0].xVal, yVal: startingY)

        return Path(points: noisePoints, length: path.length)
    }

    private func shiftPoint(point: Point, by range: ClosedRange<Int>) -> Point {
        var yVal = point.yVal + Int.random(in: range, using: &generator)
        if yVal < 0 {
            yVal = -10
        } else if yVal > Constants.gameHeight {
            yVal = Constants.gameHeight + 10
        }
        return Point(xVal: point.xVal, yVal: yVal)
    }
}
