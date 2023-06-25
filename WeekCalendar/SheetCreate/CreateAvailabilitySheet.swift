//
//  CreateAvailabilitySheet.swift
//  WeekCalendar
//
//  Created by David Gomez on 24/06/2023.
//

import SwiftUI

struct CreateAvailabilitySheet: View {
    var capsule: SchedulerCapsuleModel
    var onFinished: (Bool) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            VStack {
                Text("Availability Settings")
                    .padding()
                Spacer()
                HStack {
                    Button("Cancel") {
                        onFinished(false)
                        dismiss()
                    }
                    .padding()
                    .foregroundColor(.red)
                    .border(.red)
                    .background(Color.clear)
                    .cornerRadius(10)
                    Button("Create") {
                        onFinished(true)
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
