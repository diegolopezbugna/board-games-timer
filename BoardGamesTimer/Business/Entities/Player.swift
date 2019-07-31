//
//  Player.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 17/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

class Player: NSObject, NSCoding, Codable {
    let id: UUID
    var name: String
    var bggUsername: String?
    var preferredColor: String?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id");
        aCoder.encode(self.name, forKey: "name");
        aCoder.encode(self.bggUsername, forKey: "bggUser");
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! UUID
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.bggUsername = aDecoder.decodeObject(forKey: "bggUser") as? String
        super.init()
    }
    
    init(id: UUID, name: String, bggUsername: String?) {
        self.id = id
        self.name = name
        self.bggUsername = bggUsername
    }

    static func all() -> [UUID: Player] {
        if let data = UserDefaults.standard.data(forKey: "players"),
            let players = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UUID: Player] {
            return players
        }
        return [:]
    }
    
    static func allSorted() -> [Player] {
        return Array(Player.all().values).sorted { $0.name < $1.name }
    }
    
    static func addOrUpdatePlayer(_ player: Player) {
        var allPlayers = all()
        allPlayers[player.id] = player
        let data = NSKeyedArchiver.archivedData(withRootObject: allPlayers)
        UserDefaults.standard.set(data, forKey: "players")
    }
    
    static func deletePlayer(_ player: Player) {
        var allPlayers = all()
        allPlayers.removeValue(forKey: player.id)
        let data = NSKeyedArchiver.archivedData(withRootObject: allPlayers)
        UserDefaults.standard.set(data, forKey: "players")
    }
    
    static func findByBggUsername(_ bggUsername: String) -> Player? {
        return (all().first { (arg0) -> Bool in
            let (_, value) = arg0
            return value.bggUsername == bggUsername
        })?.value
    }
    
    static func findByName(_ name: String) -> Player? {
        return (all().first { (arg0) -> Bool in
            let (_, value) = arg0
            return value.name == name
        })?.value
    }
}
