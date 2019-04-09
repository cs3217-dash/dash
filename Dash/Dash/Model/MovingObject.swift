//
//  MovingObject.swift
//  Dash
//
//  Created by Jie Liang Ang on 7/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

protocol MovingObject {
    var xPos: Int { set get }
    var yPos: Int { set get }
    var width: Int { get }
    var height: Int { get }
    
    func update(_: Int)
}
