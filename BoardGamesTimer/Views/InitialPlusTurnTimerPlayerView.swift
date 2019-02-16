//
//  InitialPlusTurnTimerPlayerView.swift
//  BoardGamesTimer
//
//  Created by Diego on 5/16/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit
import AVFoundation

class InitialPlusTurnTimerPlayerView: UIView, TimerPlayer {

    let initialTime: TimeInterval
    let turnTime: TimeInterval

    var color: UIColor? {
        didSet {
            self.backgroundColor = color
        }
    }
    var animationColor: UIColor?

    var fontColor: UIColor?
    
    var remainingTimeLabel: UILabel!
    var delaysLabel: UILabel!
    var timePenaltyLabel: UILabel!

    var timer: Timer?
    var audioPlayer1: AVAudioPlayer!
    var audioPlayer2: AVAudioPlayer!

    var remainingTimeInterval: TimeInterval = 0 {
        didSet {
            self.remainingTimeLabel.text = remainingTimeInterval.toString(showMs: false)
        }
    }
    var delays: Int = 0 {
        didSet {
            self.delaysLabel?.text = String(delays)
        }
    }
    var timePenaltyTimeInterval: TimeInterval = 0 {
        didSet {
            self.timePenaltyLabel.text = timePenaltyTimeInterval.toString(showMs: false)
        }
    }
    
    convenience init(playerColor: PlayerColor, initialTime: TimeInterval, turnTime: TimeInterval) {
        self.init(color: playerColor.bgColor, animationColor: playerColor.bgColor2, fontColor: playerColor.textColor, initialTime: initialTime, turnTime: turnTime)
    }
    
    init(color: UIColor, animationColor: UIColor, fontColor: UIColor, initialTime: TimeInterval, turnTime: TimeInterval) {
        self.initialTime = initialTime
        self.turnTime = turnTime
        super.init(frame: CGRect())
        self.color = color
        self.animationColor = animationColor
        self.fontColor = fontColor
        self.backgroundColor = self.color
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.translatesAutoresizingMaskIntoConstraints = false
        self.remainingTimeInterval = initialTime

        if let audioFilePath = Bundle.main.path(forResource: "lost", ofType: "mp3") {
            let audioFileUrl = URL(fileURLWithPath: audioFilePath)
            self.audioPlayer1 = try! AVAudioPlayer(contentsOf: audioFileUrl)
        }
        if let audioFilePath = Bundle.main.path(forResource: "lostF", ofType: "mp3") {
            let audioFileUrl = URL(fileURLWithPath: audioFilePath)
            self.audioPlayer2 = try! AVAudioPlayer(contentsOf: audioFileUrl)
            self.audioPlayer2.numberOfLoops = 100
        }

        self.remainingTimeLabel = createLabel(fontSize: 44, constraintConstantY: 20)
        self.remainingTimeLabel.text = remainingTimeInterval.toString(showMs: false)
        self.delaysLabel = createLabel(fontSize: 16, constraintConstantY: -55)
        self.delaysLabel.text = String(delays)
        self.timePenaltyLabel = createLabel(fontSize: 16, constraintConstantY: -30)
        self.timePenaltyLabel.text = timePenaltyTimeInterval.toString(showMs: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.initialTime = 0
        self.turnTime = 0
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
        
        let centerYConstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: constraintConstantY)
        let centerXConstraint = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([centerYConstraint, centerXConstraint])
        
        return label
    }
    
    func createDelaysLabel(fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = self.fontColor
        label.font = UIFont.init(name: "Verdana", size: fontSize)
        
        self.addSubview(label)

        let trailingConstraint = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -16)
        let bottomConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -16)
        
        NSLayoutConstraint.activate([trailingConstraint, bottomConstraint])
        
        return label
    }
    
    func isRunning() -> Bool {
        return timer != nil
    }
    
    func startTimer() {
        
        self.remainingTimeInterval = TimeInterval.minimum(self.remainingTimeInterval + turnTime, self.initialTime)
        let currentTimerStart = Date()
        let currentTimerEnd = currentTimerStart.addingTimeInterval(remainingTimeInterval)
        let previousTimePenaltyTimeInterval = self.timePenaltyTimeInterval
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.083, repeats: true, block: { [weak self] (t) in // número primo, así refresca todos los números de los milisegundos y no sólo el 1ro
            guard let strongSelf = self else { return }
            
            strongSelf.remainingTimeInterval = currentTimerEnd.timeIntervalSince(Date())

            if strongSelf.remainingTimeInterval < 0.0 {
                strongSelf.remainingTimeInterval = 0
                strongSelf.delays += 1
                strongSelf.timer?.invalidate()
                strongSelf.audioPlayer1?.stop()
                strongSelf.audioPlayer1?.currentTime = 0
                strongSelf.audioPlayer2?.play()
                strongSelf.timer = Timer.scheduledTimer(withTimeInterval: 0.083, repeats: true, block: { [weak self] (t) in // número primo, así refresca todos los números de los milisegundos y no sólo el 1ro
                    guard let strongSelf = self else { return }
                    strongSelf.timePenaltyTimeInterval = previousTimePenaltyTimeInterval + Date().timeIntervalSince(currentTimerEnd)
                })
                
            } else if strongSelf.remainingTimeInterval < 29.5 {
                strongSelf.audioPlayer1?.play()
                strongSelf.audioPlayer2?.prepareToPlay()
            }
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
//        guard let currentTimerStart = self.currentTimerStart else { return }
//
//        let timeInterval = Date().timeIntervalSince(currentTimerStart)
//        self.timerLabel.text = timeInterval.toString(showMs: true)
//        self.accumulateLabel.text = (self.accumulatedTimeInterval + timeInterval).toString(showMs: false)

        if (timer != nil) {
            timer!.invalidate()
            timer = nil
        }
        
        self.audioPlayer1?.stop()
        self.audioPlayer1?.currentTime = 0
        self.audioPlayer2?.stop()
        self.audioPlayer2?.currentTime = 0

        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = self.color
        }
    }
}
