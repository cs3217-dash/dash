//
//  ReturnToMenuNode.swift
//  Dash
//
//  Created by Jolyn Tan on 17/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class ReturnToMenuNode: SKSpriteNode {

    convenience init(parentFrameSize: CGSize) {
        self.init(texture: MenuTexture.returnToMenu)
        self.size = CGSize(width: 184, height: 40)
        self.name = "menu"
        self.position = CGPoint(x: 70 + self.frame.width / 2,
                                y: parentFrameSize.height - 70)
        self.zPosition = 51
    }
}
