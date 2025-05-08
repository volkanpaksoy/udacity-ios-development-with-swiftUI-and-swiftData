//
//  EventsView.swift
//  EventCountdown
//
//  Created by Volkan Paksoy on 27/04/2025.
//

import SwiftUI

struct EventsView: View {
    
    @State var sortedEvents = Event.all.sorted()
    
    var body: some View {
        NavigationStack {
            List(sortedEvents, id: \.self.id) { event in
                NavigationLink {
                    EventForm(event: event)
                } label: {
                    EventRow(event: event)
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        Event.all.remove(at: Event.all.firstIndex(of: event)!)
                    }
                }
            }
            .onAppear() {
                sortedEvents = Event.all.sorted()
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink {
                    EventForm()
                } label: {
                    Button("Add Event", systemImage: "plus") { }
                }
            }
        }
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        EventsView()
    }
}
