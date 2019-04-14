//
//  GameScene+Observer.swift
//  Dash
//
//  Created by Jolyn Tan on 15/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import SpriteKit

extension GameScene: Observer {
    func onValueChanged(name: String, object: Any?) {
        switch name {
        case "moving":
            for object in gameModel.movingObjects where movingObjects[ObjectIdentifier(object)] == nil {
                let node: SKNode
                switch object.objectType {
                case .wall:
                    guard let wall = object as? Wall else {
                        continue
                    }
                    node = WallNode(wall: wall)
                    movingObjects[ObjectIdentifier(wall)] = node
                case .powerup:
                    guard let powerUp = object as? PowerUp else {
                        continue
                    }
                    node = PowerUpNode(powerUp: powerUp)
                    movingObjects[ObjectIdentifier(powerUp)] = node
                default:
                    guard let obstacle = object as? Obstacle else {
                        continue
                    }
                    node = ObstacleNode(obstacle: obstacle)
                    movingObjects[ObjectIdentifier(obstacle)] = node
                }
                self.addChild(node)
            }
            // Remove nodes not in gameModel
            let oids = gameModel.movingObjects.map { ObjectIdentifier($0) }
            for oid in movingObjects.keys where !oids.contains(oid) {
                guard let node = movingObjects[oid] else {
                    continue
                }
                node.removeFromParent()
                movingObjects.removeValue(forKey: oid)
            }
        default:
            break
        }
    }
}
