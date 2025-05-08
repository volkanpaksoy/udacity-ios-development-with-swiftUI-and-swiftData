//
//  Untitled.swift
//  EventCountdown
//
//  Created by Volkan Paksoy on 27/04/2025.
//

import Foundation
import SwiftUICore


struct Event: Comparable, Identifiable, Hashable {
    let id: UUID = UUID()
    
    var title: String
    var date: Date
    var textColor: Color
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        lhs.date < rhs.date
    }
    
    static func createDateFromComponents(day: Int, month: Int, year: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second

        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }
}

extension Event {
    static var all: [Event] = [
        .halloween,
        .christmas,
        .newYearsEve,
        .kingsDay,
        .independenceDay
    ]
}

extension Event {
    static let halloween: Event = .init(
        title: "Halloween 🎃",
        date: createDateFromComponents(day: 31, month: 10, year: 2025)!,
        textColor: .orange
    )
    
    static let christmas: Event = .init(
        title: "Christmas 🎄",
        date: createDateFromComponents(day: 25, month: 12, year: 2025)!,
        textColor: .green
    )
    
    static let newYearsEve: Event = .init(
        title: "New Year's Eve 🎉",
        date: createDateFromComponents(day: 1, month: 1, year: 2026)!,
        textColor: .yellow
    )
    
    static let kingsDay: Event = .init(
        title: "King's Day 🇳🇱",
        date: createDateFromComponents(day: 26, month: 4, year: 2025)!,
        textColor: .red
    )
    
    static let independenceDay: Event = .init(
        title: "Independence Day 🇺🇸",
        date: createDateFromComponents(day: 4, month: 7, year: 2025)!,
        textColor: .blue
    )
}
