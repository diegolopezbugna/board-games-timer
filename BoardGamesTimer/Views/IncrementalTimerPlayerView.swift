//
//  IncrementalTimerPlayerView.swift
//  BoardGamesTimer
//
//  Created by Diego on 5/16/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit

class IncrementalTimerPlayerView: UIView, TimerPlayer {

    var color: UIColor? {
        didSet {
            self.backgroundColor = color
        }
    }
    var colorName: String = ""
    var animationColor: UIColor?

    var fontColor: UIColor?
    
    var timerLabel: UILabel!
    var accumulateLabel: UILabel!
    
    var timer: Timer?
    var accumulatedTimeInterval: TimeInterval = 0
    var currentTimerStart: Date?
    
    convenience init(playerColor: PlayerColor) {
        self.init(color: playerColor.bgColor, colorName: playerColor.name, animationColor: playerColor.bgColor2, fontColor: playerColor.textColor)
    }
    
    init(color: UIColor, colorName: String, animationColor: UIColor, fontColor: UIColor) {
        super.init(frame: CGRect())
        self.color = color
        self.animationColor = animationColor
        self.fontColor = fontColor
        self.backgroundColor = self.color
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.translatesAutoresizingMaskIntoConstraints = false
        
        timerLabel = createLabel(fontSize: 16, constraintConstantY: -40)
        timerLabel.text = "00:00.000"
        accumulateLabel = createLabel(fontSize: 44, constraintConstantY: 20)
        accumulateLabel.text = "00:00"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        if (timer != nil) {
            timer!.invalidate()
            timer = nil
        }
    }

    func createLabel(fontSize: CGFloat, constraintConstantY: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = self.fontColor
        label.font = UIFont.init(name: "Verdana", size: fontSize)
        
        self.addSubview(label)
        
        label.autoAlignAxis(.horizontal, toSameAxisOf: self, withOffset: constraintConstantY)
        label.autoAlignAxis(.vertical, toSameAxisOf: self)
        
        return label
    }
    
    func isRunning() -> Bool {
        return timer != nil
    }
    
    func startTimer() {
        
        currentTimerStart = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.083, repeats: true, block: { [unowned self] (t) in // número primo, así refresca todos los números de los milisegundos y no sólo el 1ro
            let timeInterval = Date().timeIntervalSince(self.currentTimerStart!)
            self.timerLabel.text = timeInterval.toString(showMs: true)
            self.accumulateLabel.text = (self.accumulatedTimeInterval + timeInterval).toString(showMs: false)
        })
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.repeat, .autoreverse, .allowUserInteraction],
                       animations: {
                        self.backgroundColor = self.animationColor
                        },
                       completion: nil)

    }
    
    func stopTimer() {

        let timeInterval = Date().timeIntervalSince(self.currentTimerStart!)
        self.timerLabel.text = timeInterval.toString(showMs: true)
        
        self.accumulatedTimeInterval = self.accumulatedTimeInterval + timeInterval
        self.accumulateLabel.text = self.accumulatedTimeInterval.toString(showMs: false)

        if (timer != nil) {
            timer!.invalidate()
            timer = nil
        }

        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = self.color
        }

    }
    
    var totalTime: TimeInterval {
        return self.accumulatedTimeInterval
    }
    
    func showTotal() {
        self.timerLabel.text = "TOTAL:"
    }
    
    func showStartingPlayerMark() {
        fatalError("implement")
    }

    func hideStartingPlayerMark() {
        fatalError("implement")
    }
}
