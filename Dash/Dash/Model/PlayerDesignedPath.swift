//
//  PlayerDesignedPath.swift
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

    func makePath() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))

        var currentX = 0
        var currentY = 0

        while currentX < 3000 {
            // Random numbers for now
            let segmentXDistance = Int.random(in: 50...100, using: &generator)
            let segmentYDistance = Int.random(in: -30...30, using: &generator)

            currentX += segmentXDistance
            currentY += segmentYDistance

            path.addLine(to: CGPoint(x: currentX, y: currentY))

        }
    }
}
