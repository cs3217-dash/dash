//
//  Room.swift
//  Dash
//
//  Created by Ang YC on 8/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class Room: Observable {
    var observers = [ObjectIdentifier : Observer]()
    var id: String
    var players = [Player]()
    var characterType: CharacterType
    var isHost = false

    init(id: String, type: CharacterType) {
        self.id = id
        self.characterType = type
    }
}
