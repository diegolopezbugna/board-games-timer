//
//  PlayerView.swift
//  BoardGamesTimer
//
//  Created by Diego on 5/16/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit

class PlayerView: UIView {

    var color: UIColor? {
        didSet {
            self.backgroundColor = color
        }
    }
    var animationColor: UIColor?

    var fontColor: UIColor?
    
    var timerLabel: UILabel!
    var accumulateLabel: UILabel!
    
    var timer: Timer?
    var accumulatedTimeInterval: TimeInterval!
    var currentTimerStart: Date?
    
    init(color: UIColor, animationColor: UIColor, fontColor: UIColor) {
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
        
        accumulatedTimeInterval = 0  // grabar?
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    func stringFromTimeInterval(interval: TimeInterval, showMs: Bool) -> String {
        
        let ti = NSInteger(interval)
        let ms = Int(interval.truncatingRemainder(dividingBy: 1) * 1000)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        if (showMs) {
            if (hours > 0) {
                return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
            }
            else {
                return String(format: "%0.2d:%0.2d.%0.3d",minutes,seconds,ms)
            }
        }
        else {
            if (hours > 0) {
                return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
            }
            else {
                return String(format: "%0.2d:%0.2d",minutes,seconds)
            }
        }
    }

    func isRunning() -> Bool {
        return timer != nil
    }
    
    func startTimer() {
        
        currentTimerStart = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (t) in
            let timeInterval = Date().timeIntervalSince(self.currentTimerStart!)
            self.timerLabel.text = self.stringFromTimeInterval(interval: timeInterval, showMs: true)  // retain cycle? ui thread?
        })
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.repeat, .autoreverse],
                       animations: {
                        self.backgroundColor = self.animationColor
                        },
                       completion: nil)

    }
    
    func stopTimer() {

        let timeInterval = Date().timeIntervalSince(self.currentTimerStart!)
        self.timerLabel.text = self.stringFromTimeInterval(interval: timeInterval, showMs: true)

        accumulatedTimeInterval = accumulatedTimeInterval + timeInterval
        
        accumulateLabel.text = self.stringFromTimeInterval(interval: accumulatedTimeInterval, showMs: false)
        
        if (timer != nil) {
            timer!.invalidate()
            timer = nil
        }

        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = self.color
        }

    }
}
