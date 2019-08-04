//
//  PlaysConnector.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 26/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

class PlaysConnector: BaseConnector {
    let playersProvider: PlayersProviderProtocol = PlayersProvider()
    
    func getPlays(username: String, page: Int = 1, completion: @escaping ([LoggedPlay]?) -> Void) {
        let uri = "xmlapi2/plays"
        
        let queryItems = [URLQueryItem(name: "username", value: username),
                          URLQueryItem(name: "page", value: String(page))]
        self.requestDecodable(uri: uri, queryItems: queryItems) { (bggPlays: BggPlays?) in
            let plays = bggPlays?.play?.map({ (bggPlay) -> LoggedPlay in
                let game = Game(id: bggPlay.item.objectid, name: bggPlay.item.name)
                let p = LoggedPlay(date: bggPlay.date.fromBggDate(), game: game)
                if bggPlay.length > 0 {
                    p.gameLength = bggPlay.length
                }
                p.location = bggPlay.location
                p.comments = bggPlay.comments
                p.dontCountWinStats = bggPlay.nowinstats
                p.syncronizedWithBGG = true
                p.playerDetails = bggPlay.players?.player?.map({ (bggPlayerDetails) -> LoggedPlayPlayerDetails in
                    var player: Player
                    if bggPlayerDetails.username.count > 0,
                        let foundPlayer = self.playersProvider.findByBggUsername(bggPlayerDetails.username) {
                        player = foundPlayer
                    } else if let foundPlayer = self.playersProvider.findByName(bggPlayerDetails.name) {
                        player = foundPlayer
                    } else {
                        player = Player(id: UUID(), name: bggPlayerDetails.name, bggUsername: bggPlayerDetails.username.count > 0 ? bggPlayerDetails.username : nil)
                        self.playersProvider.addOrUpdatePlayer(player)
                    }
                    let pd = LoggedPlayPlayerDetails(player: player, won: bggPlayerDetails.win, firstTimePlaying: bggPlayerDetails.new, score: Int(bggPlayerDetails.score), teamColor: bggPlayerDetails.color, startingPosition: bggPlayerDetails.startposition, playRating: bggPlayerDetails.rating, time: nil)
                    return pd
                })
                return p
            })
            completion(plays)
        }

    }
    
}
