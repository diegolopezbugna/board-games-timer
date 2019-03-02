//
//  EndGameViewController.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 2/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    var timerPlayers: [TimerPlayer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let stackView = UIStackView(frame: CGRect())
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        self.view.addSubview(stackView)
        if let timerPlayers = timerPlayers {
            for t in timerPlayers {
                let v = EndGamePlayerView(timerPlayer: t)
                stackView.addArrangedSubview(v)
            }
        }
        let centerX = NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraints([centerX, centerY])
    }
}
