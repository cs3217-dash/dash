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
    var incomingCategory = HighScoreCategory.arrow
    var currentPlayerActions: [Action] = []
    var currentSeed = 0
    var textField: UITextField?

    private var loadingView: UIView!
    private let networkManager = NetworkManager.shared

    override func didMove(to view: SKView) {
        initLoadingWindow()
        initHighScores()
    }

    private func initReturnToMenuButton() {
        let returnToMenuButton = ReturnToMenuNode(parentFrameSize: frame.size)
        self.addChild(returnToMenuButton)
    }

    private func initHighScores() {
        networkManager.highScore.getHighScore(
            category: incomingCategory) { [weak self] (records) in
                self?.cleanSubviews()

                if !records.isEmpty {
                    guard let last = records.last, let score = self?.incomingScore,
                        (score > Int(last.score) ||
                            records.count < Constants.highScoreLimit) else {
                                self?.presentLeaderboardScene()
                                return
                    }
                }

                self?.initTextLabels()
                self?.initTextField()
                self?.initSubmitButton()
                self?.initSkipLabel()
                self?.initReturnToMenuButton()
        }
    }

    private func initTextLabels() {
        let topRanklabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        topRanklabel.text = "Y O U  A R E  T O P  1 0 !"
        topRanklabel.fontSize = 40
        topRanklabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 70)
        self.addChild(topRanklabel)
    }

    private func initTextField() {
        let textFieldSize = CGSize(width: self.frame.width * 0.6, height: 60)
        let textFieldOrigin = CGPoint(
            x: self.frame.midX - textFieldSize.width / 2,
            y: self.frame.midY - 30)
        let textField = TextFieldView(size: textFieldSize, origin: textFieldOrigin)
        view?.addSubview(textField)
        self.textField = textField
    }

    private func initSubmitButton() {
        let submitButton = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        submitButton.name = "submit"
        submitButton.text = "submit my score"
        submitButton.fontSize = 30
        submitButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 90)
        self.addChild(submitButton)
    }

    private func initSkipLabel() {
        let submitButton = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        submitButton.name = "skip"
        submitButton.text = "skip"
        submitButton.fontSize = 20
        submitButton.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.1)
        self.addChild(submitButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)
        if nodes.first?.name == "submit" {
            if isInputValid(textField?.text) {
                presentLeaderboardScene()
            } else {
                alertInvalidInput()
            }
        }

        if nodes.first?.name == "skip" {
            presentGameOverScene()
        }

        if nodes.first?.name == "menu" {
            presentMainMenuScene()
        }
    }

    private func alertInvalidInput() {
        guard let textField = textField else {
            return
        }

        let alertLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        alertLabel.text = "please ensure non-empty field with less than 16 characters"
        alertLabel.fontColor = SKColor.init(red: 229 / 255, green: 52 / 255, blue: 71 / 255, alpha: 1)
        alertLabel.fontSize = 16
        alertLabel.position = CGPoint(x: textField.frame.minX + alertLabel.frame.width / 2,
                                      y: self.frame.midY - 50)
        self.addChild(alertLabel)
    }

    private func presentLeaderboardScene() {
        cleanSubviews()
        let leaderboardScene = LeaderboardScene(size: self.size)
        leaderboardScene.incomingScore = incomingScore
        leaderboardScene.incomingName = textField?.text ?? ""
        leaderboardScene.incomingCategory = incomingCategory
        leaderboardScene.currentPlayerActions = currentPlayerActions
        leaderboardScene.currentSeed = currentSeed
        self.view?.presentScene(leaderboardScene)
    }

    private func presentMainMenuScene() {
        cleanSubviews()
        let mainMenuScene = MainMenuScene(size: self.size)
        self.view?.presentScene(mainMenuScene)
    }

    private func isInputValid(_ input: String?) -> Bool {
        guard let input = input else {
            return false
        }
        guard !input.isEmpty && input.count <= 16 else {
            return false
        }
        return true
    }

    private func initLoadingWindow() {
        let midPoint = CGPoint(x: frame.midX, y: frame.midY)
        loadingView = LoadingView(origin: frame.origin, mid: midPoint, size: frame.size)
        loadingView.alpha = 1
        view?.addSubview(loadingView)
    }

    private func hideLoadingWindow() {
        loadingView.alpha = 0
    }

    private func cleanSubviews() {
        guard let subviews = view?.subviews else {
            return
        }
        subviews.forEach { $0.removeFromSuperview() }
    }

    private func presentGameOverScene() {
        cleanSubviews()
        let gameOverScene = GameOverScene(size: self.size)

        let characterType: CharacterType
        switch incomingCategory {
        case .arrow:
            characterType = .arrow
        case .flappy:
            characterType = .flappy
        case .glide:
            characterType = .glide
        }
        gameOverScene.currentCharacterType = characterType
        gameOverScene.currentPlayerActions = currentPlayerActions
        gameOverScene.currentSeed = currentSeed
        gameOverScene.score = incomingScore
        self.view?.presentScene(gameOverScene, transition: SKTransition.fade(with: .white, duration: 0.5))
    }
}
