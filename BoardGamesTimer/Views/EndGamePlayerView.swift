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

    var leftLabel: UILabel?
    var rightLabel: UILabel?

    init(timerPlayer: TimerPlayer) {
        self.timerPlayer = timerPlayer
        super.init(frame: CGRect())
        self.createLeftLabel(timerPlayer: timerPlayer)
        self.createRightLabel(timerPlayer: timerPlayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLeftLabel(timerPlayer: TimerPlayer) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        self.addSubview(label)
        let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8)
        let bottom = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -8)
        let left = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 16)
        let width = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)
        self.addConstraints([top, left, width, bottom])
        label.text = timerPlayer.colorName + ":"
        self.leftLabel = label
    }

    func createRightLabel(timerPlayer: TimerPlayer) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        self.addSubview(label)
        let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self.leftLabel!, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self.leftLabel!, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: self.leftLabel!, attribute: .trailing, multiplier: 1, constant: 8)
        let width = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        let right = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -16)
        self.addConstraints([top, left, width, bottom, right])
        label.text = timerPlayer.totalTime.toString(showMs: false)
        self.rightLabel = label
    }

}