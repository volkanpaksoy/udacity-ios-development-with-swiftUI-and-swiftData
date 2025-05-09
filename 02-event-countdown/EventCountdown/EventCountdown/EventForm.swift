//
//  EventForm.swift
//  EventCountdown
//
//  Created by Volkan Paksoy on 27/04/2025.
//

import SwiftUI

struct EventForm: View {
    @State var event: Event = Event(
        title: "",
        date: Date(),
        textColor: .black
    )
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func isNewEvent(event: Event) -> Bool {
        // If the unique ID is not in the list then it's a new event
        return Event.all.filter{ $0.id == event.id }.count == 0
    }
    
    func onSave (event: Event) -> Void {
        if let index = Event.all.firstIndex(where: {$0.id == event.id}) {
            Event.all[index] = event
        } else {
            Event.all.append(event)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        let originalTitle = event.title
        let navigationTitle: String = isNewEvent(event: event) ? "Add Event": "Edit \(originalTitle)"
        
        Form {
            Section {
                TextField("Title", text: $event.title)
                
                HStack {
                    Text("Date")
                    DatePicker("", selection: $event.date, displayedComponents: [.date])
                    DatePicker("", selection: $event.date, displayedComponents: [.hourAndMinute])
                }
                
                ColorPicker("Text Color", selection: $event.textColor)
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("AddOrEdit", systemImage: "checkmark") {
                    onSave(event: event)
                }
                .disabled($event.title.wrappedValue.isEmpty)
            }
        }
       .navigationTitle(navigationTitle)
       .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        EventForm(event: .halloween)
    }
    
}
