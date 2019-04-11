//
//  MissionNode.swift
//  Dash
//
//  Created by Jolyn Tan on 11/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import SpriteKit

class MissionNode: SKLabelNode, Observer {

    convenience init(mission: Mission) {
        self.init()
        mission.addObserver(self)
    }

    override init() {
        super.init()
        self.text = "mission here"
        self.fontSize = 20
        self.fontColor = SKColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(_ message: String) {
        self.text = message
    }

    func onValueChanged(name: String, object: Any?) {
        guard let missionMessage = object as? String else {
            return
        }
        show(missionMessage)
    }
}
