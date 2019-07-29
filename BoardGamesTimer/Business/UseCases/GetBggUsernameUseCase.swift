//
//  GetBggUsernameUseCase.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 25/07/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

protocol GetBggUsernameUseCaseProtocol {
    var completionSuccess: ((String?) -> Void)? { get set }
    var completionError: (() -> Void)? { get set }
    func execute()
}

class GetBggUsernameUseCase: GetBggUsernameUseCaseProtocol {
    var completionSuccess: ((String?) -> Void)?
    var completionError: (() -> Void)?
    
    let bggUsernameProvider: BggUsernameProviderProtocol
    
    init(bggUsernameProvider: BggUsernameProviderProtocol) {
        self.bggUsernameProvider = bggUsernameProvider
    }
    
    func execute() {
        let bggUsername = self.bggUsernameProvider.bggUsername
        self.completionSuccess?(bggUsername)
    }
}
