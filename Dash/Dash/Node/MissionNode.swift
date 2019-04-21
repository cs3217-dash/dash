//
//  MissionNode.swift
//  Dash
//
//  Created by Jolyn Tan on 11/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import SpriteKit

class MissionNode: SKLabelNode {

    convenience init(mission: Mission) {
        self.init()
        mission.addObserver(self)
    }

    override init() {
        super.init()
        self.text = ""
        self.fontSize = 20
        self.fontColor = SKColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(_ message: String) {
        self.text = message
        animateMessage(for: 0.3)
    }

    func animateMessage(for duration: TimeInterval) {
        self.alpha = 1
        let moveUp = SKAction.moveTo(y: 100, duration: duration)
        let wait = SKAction.wait(forDuration: 2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let moveDown = SKAction.moveTo(y: -10, duration: 0.1)
        let sequence = SKAction.sequence([moveUp, wait, fadeOut, moveDown])
        self.run(sequence)
    }
}

// MARK: Observer
extension MissionNode: Observer {
    func onValueChanged(name: String, object: Any?) {
        guard let missionMessage = object as? String else {
            return
        }
        show(missionMessage)
    }
}
