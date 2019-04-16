//
//  CoinNode.swift
//  Dash
//
//  Created by Jie Liang Ang on 16/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import SpriteKit

class CoinNode: SKSpriteNode, Observer {
    
    convenience init(coin: Coin) {
        let texture = GameTexture.greenGem
        self.init(texture: texture,
                  size: CGSize(width: coin.width, height: coin.height))

        self.position = CGPoint(x: coin.xPos + coin.width / 2,
                                y: coin.yPos + coin.height / 2)

        self.name = "coin"
        self.physicsBody = SKPhysicsBody(texture: texture,
                                         size: CGSize(width: coin.width,
                                                      height: coin.height))
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.Coin.rawValue
        self.physicsBody?.contactTestBitMask = ColliderType.Coin.rawValue
        self.physicsBody?.collisionBitMask = 0

        coin.addObserver(self)
    }
    
    func onValueChanged(name: String, object: Any?) {
        guard let coin = object as? Coin else {
            return
        }

        DispatchQueue.main.async {
            switch name {
            case "xPos":
                self.position = CGPoint(x: coin.xPos + coin.width / 2,
                                        y: coin.yPos + coin.height / 2)
            default:
                return
            }
        }
    }
}
