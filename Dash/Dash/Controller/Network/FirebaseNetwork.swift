//
//  FirebaseNetwork.swift
//  Dash
//
//  Created by Ang YC on 7/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import Firebase

class FirebaseNetwork: Networkable {
    let peerID: String
    private (set) var timeOffset = 0.0
    private (set) var joinedRoomID = "_"
    let ref: DatabaseReference
    private var playerRef: DatabaseReference?
    private var infoRef: DatabaseReference?

    private (set) var roomInfo = [String: Any?]()
    private (set) var allPlayers = Set<String>()
    private (set) var onPlayersChange: (([String]) -> Void)?
    private (set) var onRoomInfo: (([String: Any?]) -> Void)?
    private (set) var references = [String: DatabaseReference]()
    private (set) var callbacks = [String: ((DataSnapshot) -> Void)]()

    init() {
        peerID = UIDevice.current.identifierForVendor!.uuidString
        ref = FirebaseInstance.ref
    }

    func createRoom(onDone: ((_ err: Any?, _ roomID: String?) -> Void)?) {
        let maxId = Int(truncating: NSDecimalNumber(
            decimal: pow(10, Constants.roomIdLength)))
        let randomInt = Int.random(in: 0..<maxId)
        let roomId = String(format: "%0\(Constants.roomIdLength)d", randomInt)
        ref.child("rooms").child(roomId)
            .setValue(["roomId": roomId, "started": false]) { (error, ref) in
                guard error == nil else {
                    onDone?(error, nil)
                    return
                }
                onDone?(nil, roomId)
        }
    }

    func joinRoom(_ roomId: String, onDone: ((_ err: Any?) -> Void)?) {
        ref.child("rooms").child(roomId).child("started")
            .observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard snapshot.exists() else {
                    onDone?("Room not exists")
                    return
                }
                self?._joinRoom(roomId, onDone: onDone)
        }
    }

    func _joinRoom(_ roomId: String, onDone: ((_ err: Any?) -> Void)?) {
        let databaseRef = ref.child("rooms").child(roomId).child("players").child(peerID)
        databaseRef.setValue(["peerID": peerID]) { [weak self] (error, _) in
            guard error == nil else {
                onDone?(error)
                return
            }
            self?.joinedRoomID = roomId
            self?._resetEventRef()
            self?._initPlayersChange()
            self?._initInfoChange()
            onDone?(nil)
        }
    }

    func leaveRoom(onDone: ((_ err: Any?) -> Void)?) {
        allPlayers.removeAll()
        roomInfo.removeAll()
        _informPlayersChange()
        _informInfoChange()
        playerRef?.removeAllObservers()
        playerRef = nil
        infoRef?.removeAllObservers()
        infoRef = nil
        joinedRoomID = "_"
        _removeAllObservers()

        ref.child("rooms").child(joinedRoomID).child("players")
            .child(peerID).removeValue() { (error, _) in
                guard error == nil else {
                    onDone?(error)
                    return
                }
                onDone?(nil)
        }
    }

    private func _initPlayersChange() {
        allPlayers.removeAll()
        playerRef?.removeAllObservers()
        playerRef = ref.child("rooms").child(joinedRoomID).child("players")
        playerRef?.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else {
                return
            }
            dict.keys.forEach {
                guard $0 != self?.peerID else {
                    return
                }
                self?.allPlayers.insert($0)
            }
            self?._informPlayersChange()
        }
        playerRef?.observe(.childAdded, with: _onPlayersChange(false))
        playerRef?.observe(.childRemoved, with: _onPlayersChange(true))
    }

    private func _onPlayersChange(_ isRemoved: Bool) -> ((DataSnapshot) -> Void) {
        return { [weak self] (snapshot) in
            let peerID = snapshot.key
            guard let self = self, peerID != self.peerID else {
                return
            }

            if isRemoved {
                self.allPlayers.remove(peerID)
            } else {
                self.allPlayers.insert(peerID)
            }

            self._informPlayersChange()
        }
    }

    private func _informPlayersChange() {
        onPlayersChange?(Array(allPlayers))
    }

    private func _initInfoChange() {
        roomInfo.removeAll()
        infoRef?.removeAllObservers()
        infoRef = ref.child("rooms").child(joinedRoomID).child("info")
        infoRef?.observe(.value) { [weak self] (snapshot) in
            guard let dict = snapshot.value as? [String: Any?] else {
                return
            }
            self?.roomInfo = dict
            self?._informInfoChange()
        }
    }

    private func _informInfoChange() {
        onRoomInfo?(roomInfo)
    }

    func setRoomInfo(_ key: String, value: Any?) {
        infoRef?.child(key).setValue(value)
    }

    func setOnRoomInfo(_ run: (([String: Any?]) -> Void)?) {
        onRoomInfo = run
    }

    func onEvent<T: GamePayload>(_ event: String, type: T.Type, run: ((String, T) -> Void)?) {
        _createEventRef(event)
        guard let eventRef = references[event] else {
            return
        }
        let callback: ((DataSnapshot) -> Void) = { snapshot in
            guard let dict = snapshot.value as? [String: Any],
                let decoded = Envelope<T>(dict: dict) else {
                    return
            }
            run?(decoded.peerID, decoded.payload)
        }
        callbacks[event] = callback
        eventRef.observe(.childAdded, with: callback)
    }

    func emitEvent(_ event: String, object: GamePayload) {
        _createEventRef(event)
        guard let eventRef = references[event] else {
            return
        }
        let childRef = eventRef.childByAutoId()

        let env = Envelope<GamePayload>(peerID, object)
        guard let dict = env.dictionary else {
            return
        }
        childRef.setValue(dict)
    }

    func _createEventRef(_ event: String) {
        guard !references.keys.contains(event) else {
            return
        }
        references[event] = ref.child("rooms").child(joinedRoomID)
            .child("events").child(event)
    }

    func _resetEventRef() {
        var newReferences = [String: DatabaseReference]()
        references.keys.forEach { (event) in
            guard let callback = callbacks[event] else {
                return
            }
            let newRef = ref.child("rooms").child(joinedRoomID).child("events").child(event)
            newReferences[event] = newRef
            newRef.observe(.childAdded, with: callback)
        }
        _removeAllObservers()
        references = newReferences
    }

    func _removeAllObservers() {
        var iter = references.makeIterator()
        while let eventRef = iter.next() {
            eventRef.value.removeAllObservers()
        }
        references.removeAll()
    }

    func setOnPlayersChange(_ onPlayersChange: (([String]) -> Void)?) {
        self.onPlayersChange = onPlayersChange
    }

    func syncTime(onDone: (() -> ())?) {
        let timeRef = ref.child("players").child(peerID).child("syncTime")
        var data = [String: Any]()
        data["timestamp"] = ServerValue.timestamp()

        let startTime = Date().timeIntervalSince1970 * 1000
        var syncId: UInt?
        var firstCall = false

        syncId = timeRef.observe(.value) { [weak self] (snapshot) in
            if !firstCall {
                firstCall = true
                return
            }
            guard let value = snapshot.value as? [String: Any],
                let serverTime = value["timestamp"] as? Double else {
                    return
            }
            let endTime = Date().timeIntervalSince1970 * 1000
            let midTime = (startTime + endTime) / 2.0
            self?.timeOffset = serverTime - midTime
            onDone?()
            if let syncId = syncId {
                timeRef.removeObserver(withHandle: syncId)
            }
        }

        timeRef.setValue(data)
    }

    func getServerTime() -> Double {
        return Date().timeIntervalSince1970 * 1000 + timeOffset
    }

    func getLocalTime(fromServerTime serverTime: Double) -> Double {
        return serverTime - timeOffset
    }
}
