//
//  PowerUpNode.swift
//  Dash
//
//  Created by Jie Liang Ang on 7/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import SpriteKit

class PowerUpNode: SKSpriteNode, Observer {

    convenience init(powerUp: PowerUp) {
        self.init(color: UIColor.red,
                  size: CGSize(width: powerUp.width, height: powerUp.height))

        self.position = CGPoint(x: powerUp.xPos + powerUp.width / 2,
                                y: powerUp.yPos + powerUp.height / 2)

        powerUp.observer = self
    }

    func onValueChanged(name: String, object: Any?) {
        guard let powerUp = object as? PowerUp else {
            return
        }

        DispatchQueue.main.async {
            switch name {
            case "xPos":
                self.position = CGPoint(x: powerUp.xPos + powerUp.width / 2,
                                        y: powerUp.yPos + powerUp.height / 2)
            default:
                return
            }
        }
    }
}
