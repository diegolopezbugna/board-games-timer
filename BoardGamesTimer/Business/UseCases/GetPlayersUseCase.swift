//
//  GetPlayersUseCase.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 25/07/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

protocol GetPlayersUseCaseProtocol {
    var completionSuccess: (([Player]) -> Void)? { get set }
    var completionError: (() -> Void)? { get set }
    func execute()
}

class GetPlayersUseCase: GetPlayersUseCaseProtocol {
    var completionSuccess: (([Player]) -> Void)?
    var completionError: (() -> Void)?

    let playersProvider: PlayersProviderProtocol
    
    init(playersProvider: PlayersProviderProtocol) {
        self.playersProvider = playersProvider
    }
    
    func execute() {
        let players = playersProvider.getPlayers().sorted { $0.name < $1.name }
        completionSuccess?(players)
    }
}
