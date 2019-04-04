//
//  PlayerDesignatedPathGenerator.swift
//  Dash
//
//  Created by Jie Liang Ang on 28/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import GameplayKit

class PlayerDesignatedPathGenerator {

    var generator: SeededGenerator

    var yVelocity = 600
    var xVelocity = 400

    init(_ seed: UInt64) {
        generator = SeededGenerator(seed: seed)
    }

    func generateModel(startingX: Int, startingY: Int) -> [Point] {
        var arr = [Point]()
        arr.append(Point(xVal: startingX, yVal: startingY))

        var currentX = startingX
        var currentY = startingY

        let endX = currentX + 50000

        while currentX <= endX {
            let minTopChange = min(300, Constants.gameHeight - currentY)
            let minBottomChange = -min(300, currentY)

            let segmentXDistance = Int.random(in: 100...200, using: &generator)
            let segmentYDistance = Int.random(in: minBottomChange...minTopChange, using: &generator)

            currentX += segmentXDistance
            currentY += segmentYDistance

            arr.append(Point(xVal: currentX, yVal: currentY))
        }

        return arr
    }

    func generateNextPoint(currX: Int, currY: Int) {
        let gradient = Int.random(in: 100...200, using: &generator)
    }

    func makePath(arr: [Point]) -> UIBezierPath {

        let path = UIBezierPath()

        guard arr.count > 0 else {
            return path
        }

        path.move(to: CGPoint(x: arr[0].xVal, y: arr[0].yVal))

        for point in arr.dropFirst() {
            path.addLine(to: CGPoint(x: point.xVal, y: point.yVal))
        }

        return path
    }
}
