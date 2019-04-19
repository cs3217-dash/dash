//
//  ReturnToMenuNode.swift
//  Dash
//
//  Created by Jolyn Tan on 17/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class ReturnToMenuNode: SKSpriteNode {

    convenience init() {
        self.init(texture: MenuTexture.returnToMenu)
        self.size = CGSize(width: 184, height: 40)
        self.name = "menu"
        self.position = position
        self.zPosition = 51
    }
}
