//
//  MovingObject.swift
//  Dash
//
//  Created by Jie Liang Ang on 7/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

/**
 Describes a game object that is moved and updated by `GameEngine`
 */
protocol MovingObject: class {
    var xPos: Int { get set }
    var yPos: Int { get set }
    var width: Int { get }
    var height: Int { get }
    var objectType: MovingObjectType { get }
    var initialPos: Int { get set }

    func update(speed: Int)
}
