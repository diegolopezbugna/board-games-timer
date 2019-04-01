//
//  Play.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 17/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

class Play: NSObject, NSCoding, Codable {
    var date: Date
    var game: Game
    var gameLength: Int
    var location: String?
    var comments: String?
    var playerDetails: [PlayPlayerDetails]?
    var dontCountWinStats: Bool = false
    var syncronizedWithBGG: Bool = false

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.date, forKey: "date");
        aCoder.encode(self.game, forKey: "game");
        aCoder.encode(self.gameLength, forKey: "gameLength");
        aCoder.encode(self.location, forKey: "location");
        aCoder.encode(self.comments, forKey: "comments");
        aCoder.encode(self.playerDetails, forKey: "playerDetails");
        aCoder.encode(self.dontCountWinStats, forKey: "dontCountWinStats");
        aCoder.encode(self.syncronizedWithBGG, forKey: "syncronizedWithBGG");
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.date = aDecoder.decodeObject(forKey: "date") as! Date
        self.game = aDecoder.decodeObject(forKey: "game") as! Game
        self.gameLength = aDecoder.decodeInteger(forKey: "gameLength")
        self.location = aDecoder.decodeObject(forKey: "location") as! String?
        self.comments = aDecoder.decodeObject(forKey: "comments") as! String?
        self.playerDetails = aDecoder.decodeObject(forKey: "playerDetails") as! [PlayPlayerDetails]?
        self.dontCountWinStats = aDecoder.decodeBool(forKey: "dontCountWinStats")
        self.syncronizedWithBGG = aDecoder.decodeBool(forKey: "syncronizedWithBGG")
        super.init()
    }

    init(date: Date, game: Game, gameLength: Int) {
        self.date = date
        self.game = game
        self.gameLength = gameLength
    }
    
    static func all() -> [Play] {
        if let data = UserDefaults.standard.data(forKey: "plays"),
            let plays = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Play] {
            return plays
        }
        return []
    }
    static func allTest() -> [Play] {
        let players = Player.allSorted()
        guard players.count > 3 else { return [] }
        var plays = [Play]()
        for i in 0...1000 {
            let calendar = Calendar.current
            var components = DateComponents()
            components.day = Int.random(in: 1...28)
            components.month = Int.random(in: 1...28)
            components.year = Int.random(in: 2017...2018)
            let date = calendar.date(from: components)
            let p = Play(date: date!, game: Game(), gameLength: i)
            p.location = "loc: \(i)"
            p.playerDetails = [PlayPlayerDetails(player: players[0], won: true, score: i), PlayPlayerDetails(player: players[1], won: false, score: i-1), PlayPlayerDetails(player: players[2], won: false, score: i-2)]
            plays.append(p)
        }
        return plays
    }

    // TODO: move to db or server
    static func insertPlay(_ play: Play) {
        var allPlays = all()
        allPlays.append(play)
        let data = NSKeyedArchiver.archivedData(withRootObject: allPlays)
        UserDefaults.standard.set(data, forKey: "plays")
    }
}
