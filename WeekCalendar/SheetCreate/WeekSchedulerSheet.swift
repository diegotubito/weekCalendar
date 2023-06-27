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
            ScrollView {
                Text("Availability Settings")
                    .padding()

                HStack {
                    Text("Periodicity")
                        .padding(16)
                        .foregroundColor(Color.Dark.tone90)
                    Spacer()
                    Picker("", selection: $viewmodel.selectedPeriod) {
                        ForEach(SchedulerCapsulePeriod.allCases, id: \.self) { item in // 4
                            Text(item.rawValue.capitalized) // 5
                        }
                    }
                    .padding(8)
                }
                
                HStack(alignment: .top) {
                    DatePicker("Start date", selection: $viewmodel.selectedStartDate, displayedComponents: .date)
                        .foregroundColor(Color.Dark.tone90)
                    VStack(alignment: .trailing) {
                        DatePicker("from", selection: $viewmodel.selectedStartDate, displayedComponents: .hourAndMinute)
                            .foregroundColor(Color.Dark.tone90)
                        DatePicker("to", selection: $viewmodel.selectedEndDate, displayedComponents: .hourAndMinute)
                            .foregroundColor(Color.Dark.tone90)
                    }
                }
                .padding()
                
                if viewmodel.selectedPeriod != .oneTime {
                    VStack {
                        Toggle("Endless", isOn: $viewmodel.isEndless)
                            .padding([.horizontal])
                            .toggleStyle(.switch)
                            .foregroundColor(Color.Dark.tone90)
                        
                        
                        if !viewmodel.isEndless {
                            DatePicker("Expiration date", selection: $viewmodel.selectedExpirationDate, displayedComponents: .date)
                                .padding()
                                .foregroundColor(Color.Dark.tone90)
                            
                        }
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
