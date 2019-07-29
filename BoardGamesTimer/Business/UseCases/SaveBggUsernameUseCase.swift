//
//  SaveBggUsernameUseCase.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 25/07/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

protocol SaveBggUsernameUseCaseProtocol {
    var completionSuccess: (() -> Void)? { get set }
    var completionError: (() -> Void)? { get set }
    func execute(bggUsername: String?)
}

class SaveBggUsernameUseCase: SaveBggUsernameUseCaseProtocol {
    var completionSuccess: (() -> Void)?
    var completionError: (() -> Void)?

    var bggUsernameProvider: BggUsernameProviderProtocol
    
    init(bggUsernameProvider: BggUsernameProviderProtocol) {
        self.bggUsernameProvider = bggUsernameProvider
    }
    
    func execute(bggUsername: String?) {
        self.bggUsernameProvider.bggUsername = bggUsername
        self.completionSuccess?()
    }
}
