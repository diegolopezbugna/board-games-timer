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
    var colorName: String = ""
    var animationColor: UIColor?
    var fontColor: UIColor?
    
    var remainingTimeLabel: UILabel!
    var timePenaltyLabel: UILabel!

    var timer: Timer?
    var accumulatedTimeInterval: TimeInterval = 0
    var currentTimerStart: Date?
    var audioPlayer1: AVAudioPlayer!
    var audioPlayer2: AVAudioPlayer!

    var remainingTimeInterval: TimeInterval = 0 {
        didSet {
            self.remainingTimeLabel.text = remainingTimeInterval.toString(showMs: false)
        }
    }
    var delays: Int = 0
    var timePenaltyTimeInterval: TimeInterval = 0 {
        didSet {
            self.timePenaltyLabel.text = timePenaltyTimeInterval.toString(showMs: false) + " exceeded"
        }
    }
    
    convenience init(playerColor: PlayerColor, initialTime: TimeInterval, turnTime: TimeInterval) {
        self.init(color: playerColor.bgColor, colorName: playerColor.name, animationColor: playerColor.bgColor2, fontColor: playerColor.textColor, initialTime: initialTime, turnTime: turnTime)
    }
    
    init(color: UIColor, colorName: String, animationColor: UIColor, fontColor: UIColor, initialTime: TimeInterval, turnTime: TimeInterval) {
        self.initialTime = initialTime
        self.turnTime = turnTime
        super.init(frame: CGRect())
        self.color = color
        self.colorName = colorName
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
        let label = UILabel(forAutoLayout: ())
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
        
        self.remainingTimeInterval = TimeInterval.minimum(self.remainingTimeInterval + turnTime, self.initialTime)
        self.currentTimerStart = Date()
        let currentTimerEnd = self.currentTimerStart!.addingTimeInterval(remainingTimeInterval)
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
        guard let currentTimerStart = self.currentTimerStart else { return }
        let timeInterval = Date().timeIntervalSince(currentTimerStart)
        self.accumulatedTimeInterval += timeInterval

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
    
    var totalTime: TimeInterval {
        return self.accumulatedTimeInterval
    }
    
    func showTotal() {
        self.timePenaltyLabel.text = "TOTAL:"
        self.remainingTimeLabel.text = self.totalTime.toString(showMs: false)
    }
    
    func showStartingPlayerMark() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
    }
    
    func hideStartingPlayerMark() {
        UIView.animate(withDuration: 0.5) {
            self.transform = CGAffineTransform.identity
        }
    }
}
