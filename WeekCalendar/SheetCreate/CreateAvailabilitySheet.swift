//
//  CreateAvailabilitySheet.swift
//  WeekCalendar
//
//  Created by David Gomez on 24/06/2023.
//

import SwiftUI

struct CreateAvailabilitySheet: View {
    var capsule: SchedulerCapsuleModel
    var onSuccess: (Availability) -> Void
    var onCancel: (SchedulerCapsuleModel) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            VStack {
                Text("Availability Settings")
                    .padding()
                Spacer()
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
