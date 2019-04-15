//
//  LeaderboardScene.swift
//  Dash
//
//  Created by Jolyn Tan on 15/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class LeaderboardScene: SKScene {
    var incomingScore = 0
    var incomingName = ""

    override func didMove(to view: SKView) {
        self.backgroundColor = .blue
        updateScoreBoard(with: incomingScore, and: incomingName)
    }

    func updateScoreBoard(with score: Int, and name: String) {
        print(score, name)
    }
}
