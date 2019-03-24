//
//  GameConnector.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 23/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

class GameConnector: BaseConnector {
    
//    func searchGames(prefix: String, completion: @escaping ([PaymentMethod]?) -> ()) {
//        let uri = "search?query=\(prefix)&type=boardgame"
//        self.requestDecodable(uri: uri, completion: completion)
//    }

    func searchGames(prefix: String, completion: @escaping ([Game]) -> Void) {
//        let uri = "search/boardgame?sort=rank&q=\(prefix)&nosubtypes%5B0%5D=boardgameexpansion"
//        let uri = "search/boardgame?sort=rank&q=\(prefix.addingPercentEncoding(withAllowedCharacters:  ))&advsearch=1"
        let uri = "search/boardgame"

        let queryItems = [URLQueryItem(name: "q", value: prefix),
                          URLQueryItem(name: "sort", value: "rank"),
//                          URLQueryItem(name: "nosubtypes[0]", value: "boardgameexpansion"),
                          URLQueryItem(name: "advsearch", value: "1")]
        
        self.getData(uri: uri, queryItems: queryItems) { (dataOrNil) in
            guard let data = dataOrNil else {
                completion([])
                return
            }
            
            let parser = BGGSearchResultsParser()
            let games = parser.parse(data: data)
            completion(games)
        }
    }
}
