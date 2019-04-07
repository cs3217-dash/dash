//
//  StartViewController.swift
//  Dash
//
//  Created by Ang YC on 29/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit
import PeerKit

class StartViewController: UIViewController {
    var networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func singlePressed(_ sender: Any) {
        openGameView(isMulti: false)
    }

    @IBAction func multiHostPressed(_ sender: Any) {
        networkManager.connect()
    }

    @IBAction func multiJoinPressed(_ sender: Any) {
    }

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
}
