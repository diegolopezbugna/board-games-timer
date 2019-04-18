//
//  StringExtensions.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 28/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

extension String {
    
    func fromBggDate() -> Date {
        let parts = self.split(separator: "-")
        guard parts.count == 3 else { return Date() }
        let calendar = Calendar.current
        let components = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: Int(parts[0]), month: Int(parts[1]), day: Int(parts[2]), hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        return calendar.date(from: components)!
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func camelcased() -> String {
        let rest = self.dropFirst()
        return self.prefix(1).uppercased() + rest.lowercased()
    }
}
