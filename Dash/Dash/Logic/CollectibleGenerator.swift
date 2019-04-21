//
//  CollectibleGenerator.swift
//  Dash
//
//  Created by Jie Liang Ang on 7/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

/**
 `CollectibleGenerator` handles generation of `Coin` and `PowerUp`
 */
class CollectibleGenerator {

    var generator: SeededGenerator

    init(_ seed: UInt64) {
        generator = SeededGenerator(seed: seed)
    }

    func generatePowerUp(xPos: Int, path: Path) -> PowerUp {
        let yPos = path.getPointAt(xVal: xPos)
        return PowerUp(yPos: yPos)
    }

    func generateCoin(xPos: Int, path: Path) -> Coin {
        let yPos = path.getPointAt(xVal: xPos)
        return Coin(yPos: yPos)
    }
}
