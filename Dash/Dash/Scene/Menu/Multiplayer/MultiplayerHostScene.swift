//
//  MultiplayerHostScene.swift
//  Dash
//
//  Created by Jolyn Tan on 16/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

class MultiplayerHostScene: SKScene {
    var selectArrowPosition: CGPoint!
    var selectGlidePosition: CGPoint!
    var selectFlappyPosition: CGPoint!

    var selectionBox: SKShapeNode!
    var playerCountLabel: SKLabelNode!
    var loadingView: UIView!

    var roomId = ""
    var isHost = false

    private let networkManager = NetworkManager.shared
    private var currentSelection = CharacterType.arrow
    private var handlerId: Int?

    override func didMove(to view: SKView) {
        initRoomIdLabel(id: roomId)
        initPlayerCountLabel(count: 1)
        initModeSelectionLabel()
        initStartLabel()
        initBackButton()
        initLogics()
        initLoadingWindow()
        initBackground()
    }
    
    private func initBackground() {
        let backgroundNode = BackgroundNode(self.frame)
        self.addChild(backgroundNode)
    }

    private func deconstruct() {
        guard let handlerId = handlerId else {
            return
        }
        networkManager.removeActionHandler(handlerId)
    }

    private func initRoomIdLabel(id: String) {
        let roomIdLabel = SKLabelNode(fontNamed: "HelveticaNeue")
        roomIdLabel.text = "room id: \(id)"
        roomIdLabel.fontSize = 30
        roomIdLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.8)
        self.addChild(roomIdLabel)
    }

    private func initPlayerCountLabel(count: Int) {
        playerCountLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        playerCountLabel.fontSize = 20
        playerCountLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.75)
        self.addChild(playerCountLabel)
    }

    private func updatePlayerCountLabel(count: Int) {
        playerCountLabel.text = "\(count) players joined"
    }

    private func initModeSelectionLabel() {
        let selectLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        selectLabel.text = "S E L E C T  M O D E"
        selectLabel.fontSize = 40
        selectLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.5)
        self.addChild(selectLabel)

        let arrowLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        arrowLabel.name = "arrow"
        arrowLabel.text = "arrow"
        arrowLabel.fontSize = 20
        arrowLabel.position = CGPoint(x: self.frame.midX - 140, y: self.frame.height * 0.4)
        self.addChild(arrowLabel)

        selectArrowPosition = selectionBoxPosition(for: arrowLabel.position)

        let glideLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        glideLabel.name = "glide"
        glideLabel.text = "glide"
        glideLabel.fontSize = 20
        glideLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.4)
        self.addChild(glideLabel)

        selectGlidePosition = selectionBoxPosition(for: glideLabel.position)

        let flappyLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        flappyLabel.name = "flappy"
        flappyLabel.text = "flappy"
        flappyLabel.fontSize = 20
        flappyLabel.position = CGPoint(x: self.frame.midX + 140, y: self.frame.height * 0.4)
        self.addChild(flappyLabel)

        selectFlappyPosition = selectionBoxPosition(for: flappyLabel.position)

        selectionBox = SKShapeNode(rectOf: CGSize(width: 110, height: 45))
        selectionBox.position = selectArrowPosition
        self.addChild(selectionBox)

    }

    private func selectionBoxPosition(for labelPosition: CGPoint) -> CGPoint {
        return CGPoint(x: labelPosition.x, y: labelPosition.y + 5)
    }

    private func initStartLabel() {
        let startLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        startLabel.name = "start"
        startLabel.text = "S T A R T"
        startLabel.fontSize = 40
        startLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.2)
        self.addChild(startLabel)
    }

    private func initBackButton() {
        let backButton = BackButtonNode(frameHeight: self.frame.height)
        self.addChild(backButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)

        switch nodes.first?.name {
        case "arrow":
            updateSelection(to: .arrow)
        case "glide":
            updateSelection(to: .glide)
        case "flappy":
            updateSelection(to: .flappy)
        default:
            return
        }
    }

    private func updateSelection(to selectedType: CharacterType) {
        guard isHost else {
            return
        }
        currentSelection = selectedType
        networkManager.networkable.setRoomInfo("type", value: currentSelection.rawValue)
        updateTypePosition()
    }

    private func updateTypePosition() {
        switch currentSelection {
        case .arrow:
            selectionBox.position = selectArrowPosition
        case .glide:
            selectionBox.position = selectGlidePosition
        case .flappy:
            selectionBox.position = selectFlappyPosition
        }
    }

    private func initLogics() {
        updatePlayers(Array(networkManager.networkable.allPlayers))
        updateInfo(networkManager.networkable.roomInfo)
        networkManager.networkable.setOnPlayersChange { [weak self] (playerIds) in
            self?.updatePlayers(playerIds)
        }
        networkManager.networkable.setOnRoomInfo { [weak self] (roomInfo) in
            self?.updateInfo(roomInfo)
        }
        handlerId = networkManager.addActionHandler { [weak self] (_, action) in
            guard let self = self, action.type == .start else {
                return
            }
            let localTime = self.networkManager.networkable
                .getLocalTime(fromServerTime: action.value)
            self.startGame(localTime)
        }
    }

    private func updatePlayers(_ playerIds: [String]) {
        updatePlayerCountLabel(count: playerIds.count + 1)
    }

    private func updateInfo(_ roomInfo: [String: Any?]) {
        guard let roomType = roomInfo["type"] as? String,
            let gameType = CharacterType(rawValue: roomType) else {
                return
        }
        currentSelection = gameType
        updateTypePosition()
    }

    private func onStartPressed() {
        guard isHost else {
            return
        }
        let startAction = Action(time: 0.0, type: .start)
        startAction.value = networkManager.networkable.getServerTime() + 3000
        networkManager.sendAction(startAction)
    }

    private func startGame(_ timestamp: Double) {
        guard let gameScene = SKScene(fileNamed: "GameScene") as? GameScene else {
            return
        }

        showLoadingWindow()
        let room = Room(id: roomId, type: currentSelection)
        networkManager.networkable.allPlayers.forEach { [weak room] id in
            let player = Player(type: currentSelection)
            player.id = id
            room?.players.append(player)
        }

        gameScene.characterType = currentSelection
        gameScene.room = room
        gameScene.gameMode = .multi
        gameScene.clockTime = timestamp
        cleanSubviews()
        self.view?.presentScene(gameScene)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)

        switch nodes.first?.name {
        case "start":
            onStartPressed()
        case "back":
            presentMultiplayerLobbyScene()
        default:
            return
        }
    }

    private func presentMultiplayerLobbyScene() {
        cleanSubviews()
        let lobbyScene = MultiplayerLobbyScene(size: self.size)
        self.view?.presentScene(lobbyScene)
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

    private func cleanSubviews() {
        guard let subviews = view?.subviews else {
            return
        }
        subviews.forEach { $0.removeFromSuperview() }
    }
}
