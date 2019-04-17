//
//  BackButtonNode.swift
//  Dash
//
//  Created by Jolyn Tan on 17/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class BackButtonNode: SKSpriteNode {

    convenience init(frameHeight: CGFloat) {
        self.init(texture: MenuTexture.back)
        self.size = CGSize(width: 50, height: 50)
        self.name = "back"
        self.position = CGPoint(x: self.frame.width / 2 + 70, y: frameHeight - 70)
    }
}
