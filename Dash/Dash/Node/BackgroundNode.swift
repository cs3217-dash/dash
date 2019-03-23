//
//  BackgroundNode.swift
//  Dash
//
//  Created by Jie Liang Ang on 18/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import SpriteKit

class BackgroundNode: SKNode {

    init(_ frame: CGRect) {
        super.init()
        self.setupBackground(frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBackground(_ frame: CGRect) {
        let backgroundTexture = GameTexture.sampleBackground
        let shiftBackground = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 5)
        let replaceBackground = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
        let movingAndReplacingBackground =
            SKAction.repeatForever(SKAction.sequence([shiftBackground, replaceBackground]))

        for index in 0..<3 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.size.height = frame.height
            background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(index)) - 1, y: frame.midY)
            background.run(movingAndReplacingBackground)
            addChild(background)
        }

        zPosition = -1
    }
}
