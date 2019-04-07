//
//  NetworkManager.swift
//  Dash
//
//  Created by Ang YC on 29/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import MultipeerConnectivity
import PeerKit

class NetworkManager {
    static let shared = NetworkManager()

    private init() {
        PeerKit.onConnect = { peerID, peerID2 in
            print("Connected: \(peerID) \(peerID2)")
        }
        PeerKit.onDisconnect = { peerID, peerID2 in
            print("Disconnected: \(peerID) \(peerID2)")
        }
    }

    func connect() {
        PeerKit.transceive(serviceType: "dash")
    }

    func onEvent(_ event: String, run: ObjectBlock?) {
        PeerKit.eventBlocks[event] = run
    }

    func sendEventToEveryone(_ event: String, time: Double) {
        let peers = PeerKit.session?.connectedPeers as [MCPeerID]? ?? []
        PeerKit.sendEvent(event, object: time as AnyObject, toPeers: peers)
    }
}
