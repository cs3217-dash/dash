//
//  EnterLeaderboardScene.swift
//  Dash
//
//  Created by Jolyn Tan on 15/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit
import UIKit

class EnterLeaderboardScene: SKScene {
    var incomingScore = 0
    var textField: UITextField!

    override func didMove(to view: SKView) {
        initTextLabels()
        initTextField()
        initSubmitButton()
    }

    private func initTextLabels() {
        let topRanklabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        topRanklabel.text = "Y O U  A R E  T O P  1 0 !"
        topRanklabel.fontSize = 40
        topRanklabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 40)
        self.addChild(topRanklabel)
    }

    private func initTextField() {
        // position and size
        let textFieldSize = CGSize(width: self.frame.width * 0.6, height: 60)
        let textFieldOrigin = CGPoint(
            x: self.frame.midX - textFieldSize.width / 2,
            y: self.frame.midY)
        textField = UITextField(frame: CGRect(origin: textFieldOrigin, size: textFieldSize))
        view?.addSubview(textField)

        // text properties
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "enter your name here",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.6)])
        textField.layer.borderColor = SKColor.white.cgColor
        textField.layer.borderWidth = 1
        textField.backgroundColor = self.backgroundColor

        // left and right padding
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textFieldSize.height))
        textField.leftView = padding
        textField.leftViewMode = .always
        textField.rightView = padding
        textField.rightViewMode = .always
    }

    private func initSubmitButton() {
        // TODO: replace with picture
        let submitButton = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        submitButton.name = "submit"
        submitButton.text = "submit my score"
        submitButton.fontSize = 30
        submitButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 120)
        self.addChild(submitButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)
        if nodes.first?.name == "submit" {
            guard isInputValid(textField.text) else {
                return
            }
            presentLeaderboardScene()
        }
    }

    private func presentLeaderboardScene() {
        cleanSubviews()
        let leaderboardScene = LeaderboardScene(size: self.size)
        leaderboardScene.incomingScore = incomingScore
        leaderboardScene.incomingName = textField.text ?? "Player"
        self.view?.presentScene(leaderboardScene)
    }

    private func isInputValid(_ input: String?) -> Bool {
        guard let input = input else {
            return false
        }
        guard !input.isEmpty else {
            return false
        }
        // TODO: check regex
        return true
    }

    private func cleanSubviews() {
        guard let subviews = view?.subviews else {
            return
        }
        subviews.forEach { $0.removeFromSuperview() }
    }
}
