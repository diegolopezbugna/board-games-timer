//
//  DateExtensions.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 18/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

extension Date {
    
    func firstDayOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
    
    func toBggDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func day() -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
}
