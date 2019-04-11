//
//  Networkable.swift
//  Dash
//
//  Created by Ang YC on 7/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

protocol Networkable {
    var peerID: String { get }
    var timeOffset: Double { get }
    var joinedRoomID: String { get }
    var roomInfo: [String: Any?] { get }
    var allPlayers: Set<String> { get }
    var onPlayersChange: (([String]) -> Void)? { get }
    var onRoomInfo: (([String: Any?]) -> Void)? { get }

    func createRoom(onDone: ((_ err: Any?, _ roomID: String?) -> Void)?)
    func joinRoom(_ roomId: String, onDone: ((_ err: Any?) -> Void)?)
    func leaveRoom(onDone: ((_ err: Any?) -> Void)?)
    func setRoomInfo(_ key: String, value: Any?)
    func setOnRoomInfo(_ run: (([String: Any?]) -> Void)?)
    func onEvent<T: GamePayload>(_ event: String, type: T.Type, run: ((String, T) -> Void)?)
    func emitEvent(_ event: String, object: GamePayload)
    func setOnPlayersChange(_ onPlayersChange: (([String]) -> Void)?)
    func syncTime(onDone: (() -> Void)?)
    func getServerTime() -> Double
    func getLocalTime(fromServerTime serverTime: Double) -> Double
}
