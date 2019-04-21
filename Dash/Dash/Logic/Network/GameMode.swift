//
//  GameMode.swift
//  Dash
//
//  Created by Ang YC on 15/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

enum GameMode: String, CaseIterable, Decodable {
    case single
    case multi
    case shadow
}
