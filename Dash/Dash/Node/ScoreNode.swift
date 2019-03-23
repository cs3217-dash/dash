//
//  ScoreNode.swift
//  Dash
//
//  Created by Jie Liang Ang on 20/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import SpriteKit

class ScoreNode: SKLabelNode {

    override init() {
        super.init()
        self.text = "0m"
        self.fontSize = 40
        self.fontColor = SKColor.black
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ score: Int) {
        self.text = "\(score)m"
    }
}
