//
//  PlaysConnector.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 26/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

class PlaysConnector: BaseConnector {
    
    func getPlays(username: String, page: Int = 1, completion: @escaping ([Play]?) -> Void) {
        let uri = "xmlapi2/plays"
        
        let queryItems = [URLQueryItem(name: "username", value: username),
                          URLQueryItem(name: "page", value: String(page))]
        self.requestDecodable(uri: uri, queryItems: queryItems) { (bggPlays: BggPlays?) in
            let plays = bggPlays?.play?.map({ (bggPlay) -> Play in
                let game = Game(id: bggPlay.item.objectid, name: bggPlay.item.name)
                let p = Play(date: bggPlay.date.fromBggDate(), game: game)
                if bggPlay.length > 0 {
                    p.gameLength = bggPlay.length
                }
                p.location = bggPlay.location
                p.comments = bggPlay.comments
                p.dontCountWinStats = bggPlay.nowinstats
                p.syncronizedWithBGG = true
                p.playerDetails = bggPlay.players?.player?.map({ (bggPlayerDetails) -> PlayPlayerDetails in
                    var player: Player
                    if bggPlayerDetails.username.count > 0,
                        let foundPlayer = Player.findByBggUsername(bggPlayerDetails.username) {
                        player = foundPlayer
                    } else if let foundPlayer = Player.findByName(bggPlayerDetails.name) {
                        player = foundPlayer
                    } else {
                        player = Player(id: UUID(), name: bggPlayerDetails.name, bggUsername: bggPlayerDetails.username.count > 0 ? bggPlayerDetails.username : nil)
                        Player.addOrUpdatePlayer(player)
                    }
                    let pd = PlayPlayerDetails(player: player, won: bggPlayerDetails.win, firstTimePlaying: bggPlayerDetails.new, score: Int(bggPlayerDetails.score), teamColor: bggPlayerDetails.color, startingPosition: bggPlayerDetails.startposition, playRating: bggPlayerDetails.rating, time: nil)
                    return pd
                })
                return p
            })
            completion(plays)
        }

    }
    
}
