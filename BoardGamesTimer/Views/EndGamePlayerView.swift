//
//  EndGamePlayerView.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 2/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import UIKit

class EndGamePlayerView: UIView {
    
    let timerPlayer: TimerPlayer
    
    init(timerPlayer: TimerPlayer) {
        self.timerPlayer = timerPlayer
        super.init(frame: CGRect())
        self.createLabel(timerPlayer: timerPlayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLabel(timerPlayer: TimerPlayer) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 40)
        let right = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -40)
        self.addConstraints([top, left, right, bottom])
        label.text = timerPlayer.colorName + " -> " + String(Int(timerPlayer.totalTime.rounded()))
    }
    
}
