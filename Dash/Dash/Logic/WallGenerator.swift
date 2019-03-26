//
//  WallGenerator.swift
//  Dash
//
//  Created by Jie Liang Ang on 21/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit

class WallGenerator {
    var lastGeneratedWalls: (top: Wall, bottom: Wall)?
    var maximumAngle = Constants.maximumAngle

    func generateNextWalls() -> (top: Wall, bottom: Wall) {
        guard let lastGeneratedWalls = lastGeneratedWalls else {
            let topWall = Wall(startPoint: CGPoint(x: 0, y: 600), endPoint: CGPoint(x: 0, y: 600))
            let bottomWall = Wall(startPoint: CGPoint(x: 0, y: 200), endPoint: CGPoint(x: 0, y: 200))
            self.lastGeneratedWalls = (top: topWall, bottom: bottomWall)
            return (top: topWall, bottom: bottomWall)
        }

        let lastTopPoint = lastGeneratedWalls.top.endPoint
        let topWall = generateNextWall(startPoint: lastTopPoint, location: .top)

        let lastBottomPoint = lastGeneratedWalls.bottom.endPoint
        let bottomWall = generateNextWall(startPoint: lastBottomPoint, location: .bottom)

        self.lastGeneratedWalls = (top: topWall, bottom: bottomWall)

        return (top: topWall, bottom: bottomWall)
    }

    private func generateNextWall(startPoint: CGPoint, location: WallLocation) -> Wall {
        let angle = CGFloat.random(in: -60...60)
        let length = CGFloat.random(in: 50...100)

        let xOffset = length * cos(angle * CGFloat.pi / 180)
        let yOffset = length * sin(angle * CGFloat.pi / 180)
        let endPoint = CGPoint(x: startPoint.x + xOffset, y: startPoint.y + yOffset)
        return Wall(startPoint: startPoint, endPoint: endPoint)
    }
}
