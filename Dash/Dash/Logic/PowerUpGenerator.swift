//
//  PowerUpGenerator.swift
//  Dash
//
//  Created by Jie Liang Ang on 7/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class PowerUpGenerator {

    var generator: SeededGenerator

    init(_ seed: UInt64) {
        generator = SeededGenerator(seed: seed)
    }

    func generatePowerUp(xPos: Int, path: Path) -> PowerUp {
        let yPos = path.getPointAt(xVal: xPos)
        return PowerUp(yPos: yPos)
    }
}
