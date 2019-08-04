//
//  LogPlayUseCaseTests.swift
//  BoardGamesTimerTests
//
//  Created by Diego Lopez bugna on 30/07/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import XCTest
@testable import BoardGamesTimer

class FakeOfflineLoggedPlaysProvider: OfflineLoggedPlaysProviderProtocol {
    var plays = [LoggedPlay]()
    func addOrUpdateOfflineLoggedPlay(_ play: LoggedPlay) {
        plays.append(play)
    }
    func getOfflineLoggedPlays() -> [LoggedPlay] {
        return plays
    }
}

class LogPlayUseCaseTests: XCTestCase {
    
    func testShouldGetLoggedPlaysWhenPlayAdded() {
        // GIVEN
        let offlineProvider = FakeOfflineLoggedPlaysProvider()
        
        let useCase = LogPlayUseCase(offlineLoggedPlaysProvider: offlineProvider)
        // WHEN
        useCase.completionSuccess = {
            // THEN
            XCTAssertTrue(offlineProvider.plays.count == 1)
            XCTAssertTrue(offlineProvider.plays[0].game.name == "Game1")
        }
        useCase.completionError = {
            XCTFail()
        }
        let play = LoggedPlay(date: Date(), game: Game(id: 1, name: "Game1"))
        useCase.execute(play: play)
    }
    
    func testShouldGetErrorWhenTryingToUpdateBggLoggedPlay() {
        // GIVEN
        let offlineProvider = FakeOfflineLoggedPlaysProvider()
        let play = LoggedPlay(date: Date(), game: Game(id: 1, name: "Game1"))
        play.syncronizedWithBGG = true
        
        let useCase = LogPlayUseCase(offlineLoggedPlaysProvider: offlineProvider)
        // WHEN
        useCase.completionSuccess = {
            XCTFail()
        }
        useCase.completionError = {
        }
        useCase.execute(play: play)
    }
}
