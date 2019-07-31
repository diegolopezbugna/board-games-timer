//
//  GetLoggedPlaysUseCaseTests.swift
//  BoardGamesTimerTests
//
//  Created by Diego Lopez bugna on 30/07/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import XCTest
@testable import BoardGamesTimer

class StubOfflineLoggedPlaysProvider: OfflineLoggedPlaysProviderProtocol {
    func addOrUpdateOfflineLoggedPlay(_ play: LoggedPlay) {}
    func getOfflineLoggedPlays() -> [LoggedPlay] {
        return [LoggedPlay(date: Date(), game: Game(id: 1, name: "Game1"))]
    }
}

class StubBggLoggedPlaysProvider: BggLoggedPlaysProviderProtocol {
    func getBggLoggedPlays(username: String, callback: @escaping ([LoggedPlay]?) -> Void) {
        callback([LoggedPlay(date: Date(), game: Game(id: 2, name: "BggGame1"))])
    }
}

class StubGetUsernameUseCase: GetBggUsernameUseCaseProtocol {
    var completionSuccess: ((String?) -> Void)?
    var completionError: (() -> Void)?
    
    func execute() {
        self.completionSuccess?("username")
    }
}

class GetLoggedPlaysUseCaseTests: XCTestCase {
    
    func testShouldGetBothLoggedPlaysWhenOnlineAndOfflineLoggedPlaysPresent() {
        // GIVEN
        let offlineProvider = StubOfflineLoggedPlaysProvider()
        let bggProvider = StubBggLoggedPlaysProvider()
        let getUsernameUseCase = StubGetUsernameUseCase()
        
        let useCase = GetLoggedPlaysUseCase(
            offlineLoggedPlaysProvider: offlineProvider,
            bggLoggedPlaysProvider: bggProvider,
            getBggUsernameUseCase: getUsernameUseCase)
        // WHEN
        useCase.completionSuccess = { plays in
            // THEN
            XCTAssert(plays.count == 2)
            XCTAssert(plays[0].game.name == "Game1")
            XCTAssert(plays[1].game.name == "BggGame1")
        }
        useCase.execute()
    }
    
    // TODO: more tests
}
