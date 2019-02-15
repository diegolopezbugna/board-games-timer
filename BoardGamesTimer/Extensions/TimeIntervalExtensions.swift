//
//  TimeIntervalExtensions.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 15/2/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

extension TimeInterval {
    func toString(showMs: Bool) -> String {
        let ti = NSInteger(self)
        let ms = Int(self.truncatingRemainder(dividingBy: 1) * 1000)
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
}
