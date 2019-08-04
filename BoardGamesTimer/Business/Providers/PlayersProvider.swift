//
//  PlayersProvider.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 03/08/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

protocol PlayersProviderProtocol {
    func getPlayers() -> [Player]
    func addOrUpdatePlayer(_ player: Player)
    func deletePlayer(_ player: Player)
    func findByBggUsername(_ bggUsername: String) -> Player?
    func findByName(_ name: String) -> Player?
}

class PlayersProvider: PlayersProviderProtocol {
    func getPlayers() -> [Player] {
        return Array(playersDic().values).sorted { $0.name < $1.name }
    }
    
    func addOrUpdatePlayer(_ player: Player) {
        var playersDic = self.playersDic()
        playersDic[player.id] = player
        let data = NSKeyedArchiver.archivedData(withRootObject: playersDic)
        UserDefaults.standard.set(data, forKey: "players")
   }
    
    func deletePlayer(_ player: Player) {
        var playersDic = self.playersDic()
        playersDic.removeValue(forKey: player.id)
        let data = NSKeyedArchiver.archivedData(withRootObject: playersDic)
        UserDefaults.standard.set(data, forKey: "players")
    }
    
    func findByBggUsername(_ bggUsername: String) -> Player? {
        return (playersDic().first { (arg0) -> Bool in
            let (_, value) = arg0
            return value.bggUsername == bggUsername
        })?.value
    }
    
    func findByName(_ name: String) -> Player? {
        return (playersDic().first { (arg0) -> Bool in
            let (_, value) = arg0
            return value.name == name
        })?.value
    }

    private func playersDic() -> [UUID: Player] {
        if let data = UserDefaults.standard.data(forKey: "players"),
            let players = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UUID: Player] {
            return players
        }
        return [:]
    }
}
