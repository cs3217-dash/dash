//
//  EnterLeaderboardScene.swift
//  Dash
//
//  Created by Jolyn Tan on 15/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit
import UIKit

class EnterLeaderboardScene: SKScene, UITextFieldDelegate {
    override func didMove(to view: SKView) {
        initTextLabels()
        initTextField()
    }

    private func initTextLabels() {
        let topRanklabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        topRanklabel.text = "Y O U  A R E  T O P  1 0 !"
        topRanklabel.fontSize = 40
        topRanklabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 20)
        self.addChild(topRanklabel)
    }

    private func initTextField() {
        let textFieldSize = CGSize(width: self.frame.width * 0.6, height: 60)
        let textFieldOrigin = CGPoint(
            x: self.frame.midX - textFieldSize.width / 2,
            y: self.frame.midY + 20)
        let textField = UITextField(frame: CGRect(origin: textFieldOrigin, size: textFieldSize))
        view?.addSubview(textField)

        textField.delegate = self
        textField.textColor = SKColor.black
        textField.placeholder = "Enter your name here"
        textField.backgroundColor = SKColor.white
    }
}
