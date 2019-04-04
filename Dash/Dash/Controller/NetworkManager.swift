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

    var peerId: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!

    private init() {
        peerId = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .optional)
        mcSession.disconnect()
    }

    func setDelegate(delegate: MCSessionDelegate) {
        mcSession.delegate = delegate
    }

    func hostGame() {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "dash", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected \(peerID.displayName)")
        case .connecting:
            print("Connecting \(peerID.displayName)")
        case .notConnected:
            print("Not connected \(peerID.displayName)")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // TODO: Handle received data
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String,
                 fromPeer peerID: MCPeerID) {
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, with progress: Progress) {
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}
