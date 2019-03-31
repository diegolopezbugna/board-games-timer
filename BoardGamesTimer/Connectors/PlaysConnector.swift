//
//  PlaysConnector.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 26/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

class PlaysConnector: BaseConnector {
    
    func getPlays(completion: @escaping (Plays?) -> Void) {
        let username = "dielop"  // TODO: settings
        let uri = "xmlapi2/plays"
        
        let queryItems = [URLQueryItem(name: "username", value: username)] // TODO: page
        self.requestDecodable(uri: uri, queryItems: queryItems, completion: completion)
    }
    
}
