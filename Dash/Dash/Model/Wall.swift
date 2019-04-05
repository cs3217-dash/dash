//
//  Wall.swift
//  Dash
//
//  Created by Jie Liang Ang on 20/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit

enum WallLocation {
    case top, bottom
}

class Wall: Observable {
    weak var observer: Observer?

    var top: Path
    var bottom: Path
    
    init(top: Path, bottom: Path) {
        self.top = top
        self.bottom = bottom
    }
}
