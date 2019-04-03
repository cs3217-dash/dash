//
//  Player.swift
//  Dash
//
//  Created by Jie Liang Ang on 20/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class Player: Observable {
    weak var observer: Observer?

    var isJumping = false

    var type: CharacterType

    init(type: CharacterType) {
        self.type = type
    }

    func update() {
        observer?.onValueChanged(name: Constants.notificationStateChange, object: self)
    }
}
