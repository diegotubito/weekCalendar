//
//  CreateAvailabilitySheet.swift
//  WeekCalendar
//
//  Created by David Gomez on 24/06/2023.
//

import SwiftUI

struct CreateAvailabilitySheet: View {
    var capsule: SchedulerModel
    var onSuccess: (Availability) -> Void
    var onCancel: (SchedulerModel) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                Text("asdflkjasdf")
                HStack {
                    Button("Cancel") {
                        onCancel(capsule)
                        dismiss()
                    }
                    .padding()
                    .foregroundColor(.red)
                    .border(.red)
                    .background(Color.clear)
                    .cornerRadius(10)
                    Button("Create") {
                        dismiss()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
        }
    }
}
