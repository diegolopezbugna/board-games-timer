//
//  EndGameViewController.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 2/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    var timerPlayers: [TimerPlayer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let timerPlayers = timerPlayers {
            for t in timerPlayers {
                let v = EndGamePlayerView(timerPlayer: t)
                stackView.addArrangedSubview(v)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "positionsSegue" {
            let vc = segue.destination as? PositionsViewController
            vc?.timerPlayers = self.timerPlayers
        }
    }
}
