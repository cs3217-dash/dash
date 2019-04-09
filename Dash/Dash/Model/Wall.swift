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

    var xPos = Constants.gameWidth {
        didSet {
            observer?.onValueChanged(name: "xPos", object: self)
        }
    }
    var yPos = 0

    var path: Path

    init() {
        path = Path()
    }

    init(path: Path) {
        self.path = path
    }

    var height = 0

    var width: Int {
        return path.length
    }

    var lastPoint: Point {
        return path.lastPoint
    }

    func update(speed: Int) {
        xPos -= speed
    }
}
