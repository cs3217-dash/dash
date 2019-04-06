//
//  WallGenerator.swift
//  Dash
//
//  Created by Jie Liang Ang on 21/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit

class WallGenerator {

    var generator: SeededGenerator

    init(_ seed: UInt64) {
        generator = SeededGenerator(seed: seed)
    }

    // TODO: Add noise
    func generateTopWallModel(path: Path) -> Path {
        return path.shift(by: 150)
    }

    func generateBottomWallModel(path: Path) -> Path {
        return path.shift(by: -150)
    }

    func makePath(path: Path) -> UIBezierPath {
        return path.generateBezierPath()
    }
}
