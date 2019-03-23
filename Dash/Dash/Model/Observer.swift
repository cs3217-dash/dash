//
//  Observer.swift
//  Dash
//
//  Created by Jie Liang Ang on 20/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

// Reference: https://benoitpasquier.com/observer-design-pattern-swift/
protocol Observer: class {
    func onValueChanged(name: String, object: Any?)
}
