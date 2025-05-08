//
//  EventRow.swift
//  EventCountdown
//
//  Created by Volkan Paksoy on 27/04/2025.
//

import SwiftUI
import Combine

struct EventRow: View {
    @State private var dateDiffString: String = ""
    @State var timer: AnyCancellable?

    let event: Event

    func formatDateDifff (event: Event) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: event.date, relativeTo: Date.now)
    }
        
    func updateCurrentTime() {
        dateDiffString = formatDateDifff(event: event)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.largeTitle)
                .foregroundColor(event.textColor)
                .bold()
            Text("\(dateDiffString)")
                .frame(alignment: .leading)
        }
        .onAppear {
            timer = Timer.publish(every: 1.0, on: .main, in: .common)
                        .autoconnect()
                        .sink { _ in
                            updateCurrentTime()
                        }
        }
        .onDisappear {
            timer?.cancel()
        }
        
    }
}

#Preview {
    List {
        EventRow(event: .halloween)
    }
}
