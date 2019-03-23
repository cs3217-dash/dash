//
//  Player.swift
//  Dash
//
//  Created by Jie Liang Ang on 20/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

enum CharacterType {
    case arrow
}

class Player: Observable {
    weak var observer: Observer?
    var type = CharacterType.arrow {
        didSet {
            switch type {
            case .arrow:
                observer?.onValueChanged(name: Constants.notificationChangeType, object: type)
            }
        }
    }

    func tap() {
        switch type {
        case .arrow:
            observer?.onValueChanged(name: Constants.notificationSwitchDirection, object: nil)
        }
    }

    func longPress() {
        switch type {
        case .arrow: break
        }
    }
}
