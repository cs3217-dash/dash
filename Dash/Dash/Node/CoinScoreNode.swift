//
//  CoinScoreNode.swift
//  Dash
//
//  Created by Jolyn Tan on 19/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class CoinScoreNode: SKSpriteNode {
    var label: SKLabelNode!

    convenience init() {
        self.init(texture: GameTexture.greenGem)
        self.size = CGSize(width: 30, height: 30)
        initLabel()
    }

    private func initLabel() {
        label = SKLabelNode()
        label.fontSize = 24
        label.position = CGPoint(x: 25, y: -10)
        self.addChild(label)
    }

    func update(_ coinCount: Int) {
        label.text = "\(coinCount)"
    }
}
