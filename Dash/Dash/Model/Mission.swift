//
//  Mission.swift
//  Dash
//
//  Created by Jolyn Tan on 11/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class Mission: Observable {
    var observers = [ObjectIdentifier : Observer]()
    var message = "" {
        didSet {
            notifyObservers(name: "message", object: message)
        }
    }
}
