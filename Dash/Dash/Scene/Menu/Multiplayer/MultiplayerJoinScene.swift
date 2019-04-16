//
//  MultiplayerJoinScene.swift
//  Dash
//
//  Created by Jolyn Tan on 16/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class MultiplayerJoinScene: SKScene {
    var textField: UITextField!
    var loadingView: UIView!
    private let networkManager = NetworkManager.shared
    
    override func didMove(to view: SKView) {
        initIdTextField()
        initSubmitButton()
        initLoadingWindow()
    }

    private func initIdTextField() {
        // position and size
        let textFieldSize = CGSize(width: self.frame.width * 0.4, height: 60)
        let textFieldOrigin = CGPoint(
            x: self.frame.midX - textFieldSize.width / 2,
            y: self.frame.midY - 20)
        textField = UITextField(frame: CGRect(origin: textFieldOrigin, size: textFieldSize))

        view?.addSubview(textField)

        // text properties
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "enter room id here",
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

        // room id label
        let enterIdLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        enterIdLabel.text = "enter room id"
        enterIdLabel.fontSize = 20
        enterIdLabel.position = CGPoint(
            x: textFieldOrigin.x + enterIdLabel.frame.width / 2,
            y: self.frame.midY + 40)
        self.addChild(enterIdLabel)
    }

    private func initSubmitButton() {
        let submitButton = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        submitButton.name = "submit"
        submitButton.text = "G O"
        submitButton.fontSize = 20
        submitButton.position = CGPoint(
            x: textField.frame.maxX + submitButton.frame.width / 2 + 20,
            y: textField.frame.midY - 25)
        self.addChild(submitButton)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)

        switch nodes.first?.name {
        case "submit":
            handleSubmit()
        default:
            return
        }
    }

    private func handleSubmit() {
        guard let roomId = textField.text, roomId.count > 0 else {
            // TODO: Show error
            return
        }
        showLoadingWindow()
        networkManager.networkable.joinRoom(roomId) { [weak self] (err) in
            guard err == nil else {
                // TODO: Show loading / error
                self?.hideLoadingWindow()
                return
            }
            self?.cleanSubviews()
            self?.presentMultiplayerHostScene(roomId)
        }
    }

    private func presentMultiplayerHostScene(_ roomID: String) {
        let hostScene = MultiplayerHostScene(size: self.size)
        hostScene.roomId = roomID
        hostScene.isHost = false
        self.view?.presentScene(hostScene)
    }

    private func initLoadingWindow() {
        let midPoint = CGPoint(x: frame.midX, y: frame.midY)
        loadingView = LoadingView(origin: frame.origin, mid: midPoint, size: frame.size)
        loadingView.alpha = 0
        view?.addSubview(loadingView)
    }

    private func showLoadingWindow() {
        loadingView.alpha = 1
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
}
