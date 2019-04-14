//
//  GameOverScene.swift
//  Dash
//
//  Created by Jolyn Tan on 15/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

// TODO: add menu bar
// TODO: add replay
class GameOverScene: SKScene {
    var score = 0
    var scoreLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        initCurrentScoreLabel()
        initBestScoreLabel(score: 12900)
    }

    private func initCurrentScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        scoreLabel.text = "\(score) pts"
        scoreLabel.fontSize = 140
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(scoreLabel)
    }

    private func initBestScoreLabel(score: Int) {
        let bestScoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        bestScoreLabel.text = "Best: \(score) pts" // TODO: Set best score from storage
        bestScoreLabel.fontSize = 24
        bestScoreLabel.position = CGPoint(x: self.frame.midX, y: scoreLabel.position.y - 80)
        self.addChild(bestScoreLabel)
    }
}
