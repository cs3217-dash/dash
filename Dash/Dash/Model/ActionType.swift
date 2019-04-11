//
//  ActionType.swift
//  Dash
//
//  Created by Ang YC on 29/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

enum ActionType: String, CaseIterable, Decodable {
    case hold
    case release
    case start
    case xPosition
    case yPosition
}
