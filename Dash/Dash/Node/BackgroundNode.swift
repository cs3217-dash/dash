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
    
    let emitter = SKEmitterNode(fileNamed: "Passing")

    init(_ frame: CGRect, type: CharacterType) {
        super.init()
        zPosition = -1
        setGradientBackgroun(frame: frame, type: type)
        setParallaxObjects(frame: frame)
        
        guard let backgroundEmitter = emitter else {
            return
        }
        backgroundEmitter.zPosition = -2
        backgroundEmitter.position = CGPoint(x: Constants.gameWidth, y: 0)
        self.addChild(backgroundEmitter)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setGradientBackgroun(frame: CGRect, type: CharacterType) {
        let backgroundTexture: SKTexture
        switch type {
        case .arrow: backgroundTexture = GameTexture.blueGradientBG
        case .glide: backgroundTexture = GameTexture.redGradientBG
        case .flappy:backgroundTexture = GameTexture.greenGradientBG
        }
        let gradientBackground = SKSpriteNode(texture: backgroundTexture)
        gradientBackground.size.height = frame.height
        gradientBackground.size.width = frame.width
        gradientBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        gradientBackground.zPosition = -5
        addChild(gradientBackground)
    }

    private func setParallaxObjects(frame: CGRect) {
        setupMovingNode(frame, texture: GameTexture.caveWithLight, zPos: -1, duration: 20)
    }

    private func setupMovingNode(_ frame: CGRect, texture: SKTexture, zPos: CGFloat, duration: Double) {
        let shiftBackground = SKAction.moveBy(x: -texture.size().width, y: 0, duration: duration)
        let replaceBackground = SKAction.moveBy(x: texture.size().width, y: 0, duration: 0)
        let movingAndReplacingBackground =
            SKAction.repeatForever(SKAction.sequence([shiftBackground, replaceBackground]))

        for index in 0..<2 {
            let background = SKSpriteNode(texture: texture)
            background.size.height = frame.height
            background.position = CGPoint(x: (texture.size().width * CGFloat(index)) - 1, y: frame.midY)
            background.run(movingAndReplacingBackground)
            background.zPosition = zPos
            addChild(background)
        }
    }
}
