//
//  NetworkManager.swift
//  Dash
//
//  Created by Ang YC on 29/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import MultipeerConnectivity

class NetworkManager {
    static let shared = NetworkManager()
    let networkable: Networkable = FirebaseNetwork()
    private var actionHandlers = [Int: ((String, Action) -> Void)]()

    private init() {
        ActionType.allCases.forEach { [weak self] (actionType) in
            networkable.onEvent(actionType.rawValue, type: Action.self) { (peerID, action) in
                self?._onAction(peerID, action)
            }
        }
    }

    func sendAction(_ action: Action) {
        networkable.emitEvent(action.type.rawValue, object: action)
    }

    func _onAction(_ peerID: String, _ action: Action) {
        actionHandlers.forEach { _, handler in
            handler(peerID, action)
        }
    }

    func addActionHandler(_ run: @escaping ((String, Action) -> Void)) -> Int {
        let id = Int.random(in: 1...1000000000)
        actionHandlers[id] = run
        return id
    }

    func removeActionHandler(_ id: Int) {
        actionHandlers.removeValue(forKey: id)
    }
}
