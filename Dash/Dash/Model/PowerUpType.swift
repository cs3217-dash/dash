//
//  PowerUpType.swift
//  Dash
//
//  Created by Jie Liang Ang on 15/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

enum PowerUpType: String {
    case ghost, magnet, dash, shrink

    static func randomType() -> PowerUpType {
        let index = Int(arc4random_uniform(UInt32(Constants.powerUps.count)))
        return Constants.powerUps[index]
    }
}
