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
        label.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16), excludingEdge: .right)
        label.autoSetDimension(.width, toSize: 80)
        label.text = timerPlayer.colorName + ":"
        self.leftLabel = label
    }

    func createRightLabel(timerPlayer: TimerPlayer) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        self.addSubview(label)
        label.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16), excludingEdge: .left)
        label.autoSetDimension(.width, toSize: 80)
        label.autoPinEdge(.left, to: .right, of: self.leftLabel!, withOffset: 8)
        label.text = timerPlayer.totalTime.toString(showMs: false)
        self.rightLabel = label
    }

}
