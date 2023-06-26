//
//  CreateAvailabilitySheet.swift
//  WeekCalendar
//
//  Created by David Gomez on 24/06/2023.
//

import SwiftUI

struct AvailabilitySheetCreateUpdateDelete: View {
    @ObservedObject var viewmodel: AvailabilitySheetViewModel
    var onFinished: (Availability?) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Availability Settings")
                .padding()
            
            HStack {
                DatePicker("Start date", selection: $viewmodel.selectedStartDate, displayedComponents: .date)
                    .padding([.leading, .trailing], 8)
                    .padding([.top, .bottom], 16)
                    .foregroundColor(Color.Dark.tone90)
                DatePicker("Start time", selection: $viewmodel.selectedStartDate, displayedComponents: .hourAndMinute)
                    .padding([.leading, .trailing], 8)
                    .padding([.top, .bottom], 16)
                    .foregroundColor(Color.Dark.tone90)
            }
            
            HStack {
                DatePicker("End date", selection: $viewmodel.selectedEndDate, displayedComponents: .date)
                    .padding([.leading, .trailing], 8)
                    .padding([.top, .bottom], 16)
                    .foregroundColor(Color.Dark.tone90)
                Spacer()
                DatePicker("End time", selection: $viewmodel.selectedEndDate, displayedComponents: .hourAndMinute)
                    .padding([.leading, .trailing], 8)
                    .padding([.top, .bottom], 16)
                    .foregroundColor(Color.Dark.tone90)
            }
            
            HStack {
                Text("Select a period")
                    .padding(8)
                    .foregroundColor(Color.Dark.tone90)
                Spacer()
                Picker("", selection: $viewmodel.selectedPeriod) {
                    ForEach(SchedulerCapsulePeriod.allCases, id: \.self) { item in // 4
                        Text(item.rawValue.capitalized) // 5
                    }
                }
            }
            
            Spacer()
            HStack {
                switch viewmodel.type {
                case .edit:
                    BasicButton(title: "Remove", style: .destructive, isEnabled: .constant(true)) {
                        Task {
                            await viewmodel.deleteAvailability()
                        }
                    }
                    
                    BasicButton(title: "Update", style: .primary, isEnabled: .constant(true)) {
                        Task {
                            await viewmodel.updateAvailability()
                        }
                    }
                    
                case .new:
                    BasicButton(title: "Cancel", style: .secondary, isEnabled: .constant(true)) {
                        onFinished(nil)
                        dismiss()
                    }
                    
                    BasicButton(title: "Create", style: .primary, isEnabled: .constant(true)) {
                        Task {
                            await viewmodel.saveAvailability()
                        }
                    }
                }
            }
            .padding()
        }
        .alert(isPresented: $viewmodel.showAlert) {
            Alert(title: Text(viewmodel.alertTitle), message: Text(viewmodel.alertMessage))
        }
        .onChange(of: viewmodel.availability) { newValue in
            onFinished(newValue)
            dismiss()
        }
    }
}
