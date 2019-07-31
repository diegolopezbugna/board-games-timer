//
//  Play.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 17/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

class LoggedPlay: NSObject, NSCoding, Codable {
    var date: Date
    var game: Game
    var gameLength: Int?
    var location: String?
    var comments: String?
    var playerDetails: [LoggedPlayPlayerDetails]?
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
        self.gameLength = aDecoder.decodeObject(forKey: "gameLength") as? Int
        self.location = aDecoder.decodeObject(forKey: "location") as? String
        self.comments = aDecoder.decodeObject(forKey: "comments") as? String
        self.playerDetails = aDecoder.decodeObject(forKey: "playerDetails") as? [LoggedPlayPlayerDetails]
        self.dontCountWinStats = aDecoder.decodeBool(forKey: "dontCountWinStats")
        self.syncronizedWithBGG = aDecoder.decodeBool(forKey: "syncronizedWithBGG")
        super.init()
    }

    init(date: Date, game: Game) {
        self.date = date
        self.game = game
    }
}
