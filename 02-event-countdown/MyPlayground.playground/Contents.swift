import UIKit
import SwiftUICore

struct Event: Comparable, Identifiable {
    
    let id: UUID = UUID()
    
    var title: String
    var date: Date
    var textColor: Color
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        lhs.date < rhs.date
    }
    
    static func createDate(day: Int, month: Int, year: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year

        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }
}

extension Event {
    
    static let all: [Event] = [
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
        date: createDate(day: 31, month: 10, year: 2025)!,
        textColor: .orange
    )
    
    static let christmas: Event = .init(
        title: "Christmas 🎄",
        date: createDate(day: 25, month: 12, year: 2025)!,
        textColor: .green
    )
    
    static let newYearsEve: Event = .init(
        title: "New Year's Eve 🎉",
        date: createDate(day: 1, month: 1, year: 2026)!,
        textColor: .yellow
    )
    
    static let kingsDay: Event = .init(
        title: "King's Day 🇳🇱",
        date: createDate(day: 26, month: 4, year: 2025)!,
        textColor: .red
    )
    
    static let independenceDay: Event = .init(
        title: "Independence Day 🇺🇸",
        date: createDate(day: 4, month: 7, year: 2025)!,
        textColor: .blue
    )
}

// print(Event.all.sorted())

func isNewEvent(event: Event) -> Bool {
    return Event.all.filter{ $0.id == event.id }.count == 0
}

let newEvent = Event(title: "TEST", date: Date(), textColor: .green)

//let ev1 = Event.all.filter{ $0.id == newEvent.id }.first
//print(ev1)
//
//let ev2 = Event.all.filter{ $0.id == Event.all[0].id }.first
//print(ev2!.title)

print( isNewEvent(event: newEvent) )
print( isNewEvent(event: Event.all[0]) )
