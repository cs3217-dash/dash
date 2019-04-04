//
//  Action.swift
//  Dash
//
//  Created by Ang YC on 29/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class Action {
    weak var stage: Stage?
    var time: Double
    var type: ActionType

    init(stage: Stage, time: Double, type: ActionType) {
        self.stage = stage
        self.time = time
        self.type = type
    }
}
