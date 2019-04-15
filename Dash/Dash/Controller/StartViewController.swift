//
//  StartViewController.swift
//  Dash
//
//  Created by Ang YC on 29/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    var networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.networkable.syncTime { [weak self] in
            self?.networkManager.networkable.syncTime(onDone: nil)
        }
    }

    @IBAction func singlePressed(_ sender: Any) {
        openGameView()
    }

    @IBAction func multiHostPressed(_ sender: Any) {
        networkManager.networkable.createRoom() { [weak self] _, roomID in
            guard let roomID = roomID else {
                return
            }
            self?.networkManager.networkable.joinRoom(roomID) { [weak self] _ in
                self?._joinRoom(roomID, isHost: true)
                self?.networkManager.networkable.setRoomInfo("type", value: "arrow")
            }
        }
    }

    @IBAction func multiJoinPressed(_ sender: Any) {
        networkManager.networkable.joinRoom("") { [weak self] _ in
            self?._joinRoom("HARD_CODED_ID", isHost: false)
        }
    }

    private func _joinRoom(_ roomId: String, isHost: Bool) {
        guard let roomViewController =
            self.storyboard?.instantiateViewController(withIdentifier: "roomView") as? RoomViewController else {
                return
        }
        roomViewController.roomId = roomId
        roomViewController.isHost = isHost
        present(roomViewController, animated: true, completion: nil)
    }

    func openGameView() {
        guard let gameViewController =
            self.storyboard?.instantiateViewController(withIdentifier: "gameView") as? GameViewController else {
                return
        }
        gameViewController.gameMode = .single
        self.present(gameViewController, animated: true, completion: nil)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
