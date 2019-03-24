//
//  BGGSearchResultsParser.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 23/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation
import SwiftSoup

class BGGSearchResultsParser {
    
    func parse(data: Data) -> [Game] {
        var games = [Game]()
        
        guard let html = String(data: data, encoding: .utf8),
            let doc = try? SwiftSoup.parse(html),
            let rows = try? doc.select("tr[id='row_']") else {
                return games
        }
        
        for row in rows {
            let game = Game()
            
            if let ahref = try? row.select("a[href]"),
                let firstAhref = ahref.first(),
                let attrValue = try? firstAhref.attr("href"),
                let gameId = Int(attrValue.split(separator: "/")[1]) {
                game.id = gameId
            } else {
                continue
            }
            
            if let div = try? row.select("div[style='z-index:1000;']"),
                let a = try? div.select("a"),
                let firstA = a.first(),
                let text = try? firstA.text() {
                game.name = text
            } else {
                continue
            }
            
            if let img = try? row.select("img[src]"),
                let firstImg = img.first(),
                let attrValue = try? firstImg.attr("src") {
                game.thumbnailUrl = attrValue
            }
                
            games.append(game)
        }

        return games
    }
}
