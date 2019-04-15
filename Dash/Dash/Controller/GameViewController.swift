//
//  GameViewController.swift
//  Dash
//
//  Created by Jie Liang Ang on 18/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var room: Room?
    var gameMode: GameMode = .single

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = self.view as? SKView else {
            return
        }

        // Load the SKScene from 'GameScene.sks'
        if let room = room, gameMode == .multi,
            let gameScene = SKScene(fileNamed: "GameScene") as? GameScene {
                gameScene.characterType = room.characterType
                gameScene.room = room
                gameScene.gameMode = gameMode
                view.presentScene(gameScene)
        } else if let scene = SKScene(fileNamed: "StartScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .resizeFill

            // Present the scene
            view.presentScene(scene)
        }

        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
