//
//  Date+Extension.swift
//  HayEquipo
//
//  Created by David Gomez on 23/04/2023.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        return dateString
    }

    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        min(date1, date2) ... max(date1, date2) ~= self
    }
}

extension Date {
    func startOfDay() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }
    
    func endOfDay() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endOfDay = calendar.date(byAdding: components, to: self.startOfDay())!
        return endOfDay
    }
}

