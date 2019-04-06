//
//  MenuScene.swift
//  Dash
//
//  Created by Jolyn Tan on 6/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    var arrowButtonNode: SKSpriteNode!
    var jetpackButtonNode: SKSpriteNode!
    var flappyButtonNode: SKSpriteNode!

    override func didMove(to view: SKView) {
        arrowButtonNode = self.childNode(withName: "arrowButton") as? SKSpriteNode
        jetpackButtonNode = self.childNode(withName: "jetpackButton") as? SKSpriteNode
        flappyButtonNode = self.childNode(withName: "flappyButton") as? SKSpriteNode
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first

        if let location = touch?.location(in: self) {
            let nodes = self.nodes(at: location)

            if nodes.first?.name == "arrowButton" {
                presentGameScene(with: .arrow)
            }
            if nodes.first?.name == "jetpackButton" {
                presentGameScene(with: .jetpack)
            }
            if nodes.first?.name == "flappyButton" {
                presentGameScene(with: .flappy)
            }
        }
    }

    private func presentGameScene(with characterType: CharacterType) {
        let gameScene = GameScene(size: self.size)
        gameScene.characterType = characterType
        self.view?.presentScene(gameScene)
    }
}
