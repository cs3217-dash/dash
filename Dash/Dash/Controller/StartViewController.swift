//
//  StartViewController.swift
//  Dash
//
//  Created by Ang YC on 29/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class StartViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {

    var networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func singlePressed(_ sender: Any) {
        openGameView(isMulti: false)
    }

    @IBAction func multiHostPressed(_ sender: Any) {
        networkManager.hostGame()
    }

    @IBAction func multiJoinPressed(_ sender: Any) {
        let mcSession = networkManager.mcSession!
        let mcBrowser = MCBrowserViewController(serviceType: "dash", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true, completion: nil)
    }

    // TODO: mcSession.disconnect()

    func openGameView(isMulti: Bool) {
        guard let gameViewController =
            self.storyboard?.instantiateViewController(withIdentifier: "gameView") as? GameViewController else {
                return
        }
        self.present(gameViewController, animated: true, completion: nil)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        networkManager.session(session, peer: peerID, didChange: state)
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        networkManager.session(session, didReceive: data, fromPeer: peerID)
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        networkManager.session(session, didReceive: stream, withName: streamName, fromPeer: peerID)
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        networkManager.session(session, didStartReceivingResourceWithName: resourceName, fromPeer: peerID, with: progress)
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        networkManager.session(session, didFinishReceivingResourceWithName: resourceName, fromPeer: peerID, at: localURL, withError: error)
    }

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
}
