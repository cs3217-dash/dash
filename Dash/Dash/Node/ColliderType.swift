//
//  ColliderType.swift
//  Dash
//
//  Created by Jie Liang Ang on 21/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

enum ColliderType: UInt32 {
    case player =   0b000001
    case obstacle = 0b000010
    case wall =     0b000100
    case powerup =  0b001000
    case coin =     0b010000
    case boundary = 0b100000
}
