//
//  RoomViewController.swift
//  Dash
//
//  Created by Ang YC on 8/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit

class RoomViewController: UIViewController {

    private let networkManager = NetworkManager.shared
    @IBOutlet weak var roomIdLabel: UILabel!
    @IBOutlet weak var roomPlayersLabel: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    var roomId = ""
    var isHost = false
    private var type = CharacterType.arrow
    private var room = Room(id: "", type: .arrow)
    private var handlerId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        room = Room(id: roomId, type: type)
        roomIdLabel.text = roomId
        _updatePlayers(Array(networkManager.networkable.allPlayers))
        _updateInfo(networkManager.networkable.roomInfo)
        networkManager.networkable.setOnPlayersChange { [weak self] (playerIds) in
            self?._updatePlayers(playerIds)
        }
        networkManager.networkable.setOnRoomInfo { [weak self] (roomInfo) in
            self?._updateInfo(roomInfo)
        }
        handlerId = networkManager.addActionHandler { [weak self] (_, action) in
            guard let self = self, action.type == .start else {
                return
            }
            let localTime = self.networkManager.networkable
                .getLocalTime(fromServerTime: action.value)
            let localDate = Date.init(timeIntervalSince1970: localTime / 1000.0)
            let timer = Timer(fireAt: localDate, interval: 0, target: self, selector: #selector(self.startGame), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let handlerId = handlerId else {
            return
        }
        networkManager.removeActionHandler(handlerId)
    }

    private func _updatePlayers(_ playerIds: [String]) {
        roomPlayersLabel.text = playerIds.joined(separator: ", ")
    }

    private func _updateInfo(_ roomInfo: [String: Any?]) {
        guard let roomType = roomInfo["type"] as? String,
            let gameType = CharacterType(rawValue: roomType) else {
                return
        }
        type = gameType
        roomTypeLabel.text = gameType.rawValue
    }

    private func _changeType(_ type: CharacterType) {
        networkManager.networkable.setRoomInfo("type", value: type.rawValue)
    }

    @IBAction func onArrowSelect(_ sender: Any) {
        _changeType(.arrow)
    }

    @IBAction func onFlappySelect(_ sender: Any) {
        _changeType(.flappy)
    }

    @IBAction func onGlideSelect(_ sender: Any) {
        _changeType(.jetpack)
    }

    @IBAction func onStartClick(_ sender: Any) {
        guard isHost else {
            return
        }
        let startAction = Action(time: 0.0, type: .start)
        startAction.value = networkManager.networkable.getServerTime() + 3000
        networkManager.sendAction(startAction)
    }

    @objc func startGame() {
        guard let gameViewController =
            self.storyboard?.instantiateViewController(withIdentifier: "gameView") as? GameViewController else {
                return
        }
        let room = Room(id: roomId, type: type)
        networkManager.networkable.allPlayers.forEach { [weak room] id in
            let player = Player(type: type)
            player.id = id
            room?.players.append(player)
        }
        gameViewController.room = room
        self.present(gameViewController, animated: true, completion: nil)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
