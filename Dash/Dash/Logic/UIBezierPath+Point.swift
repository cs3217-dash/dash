//
//  UIBezierPath+Point.swift
//  Dash
//
//  Created by Jie Liang Ang on 4/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit

extension UIBezierPath {
    convenience init(points: [Point]) {
        self.init()

        guard points.count > 0 else {
            return
        }
        self.move(to: CGPoint(x: points[0].xVal, y: points[0].yVal))

        for point in points.dropFirst() {
            self.addLine(to: CGPoint(x: point.xVal, y: point.yVal))
        }
    }
}
