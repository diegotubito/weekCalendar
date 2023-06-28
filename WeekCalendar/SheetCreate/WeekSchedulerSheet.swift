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
    
    struct Constants {
        static let optionTextColor = Color.Neutral.tone80
        static let labelTextColor = Color.Dark.tone90
    }
    
    @Environment(\.dismiss) var dismiss
   
    var body: some View {
        VStack {
            ScrollView {
                
                VStack {
                    Text("Availability Settings")
                        .padding()
                        .foregroundColor(Color.Neutral.tone70)
                        .font(.title2)
                    
                    Divider()
                        .background(Color.Neutral.tone70)
                    
                    HStack {
                        Text("Periodicity")
                            .foregroundColor(Constants.labelTextColor)
                        Spacer()
                        Picker("", selection: $viewmodel.selectedPeriod) {
                            ForEach(SchedulerCapsulePeriod.allCases, id: \.self) { item in
                                Text(item.rawValue.capitalized)
                            }
                        }
                    }
                    
                    if viewmodel.selectedPeriod == .weekly && viewmodel.type == .new {
                        CheckBoxSelector(items: viewmodel.getWeekNames(), style: .horizontal, selectedItems: viewmodel.selectedClones) { selectedItems in
                            viewmodel.selectedClones = selectedItems
                        }
                        .padding([.bottom])
                    }
                    
                    Divider()
                        .background(Color.Neutral.tone70)
                    
                    HStack(alignment: .top) {
                        HStack {
                            Text("Start date")
                                .foregroundColor(Constants.labelTextColor)
                            DatePicker("", selection: $viewmodel.selectedStartDate, displayedComponents: .date)
                                .applyTextColor(Constants.optionTextColor)
                        }
                        VStack(alignment: .trailing) {
                            DatePicker("", selection: $viewmodel.selectedStartDate, displayedComponents: .hourAndMinute)
                                .applyTextColor(Constants.optionTextColor)
                            DatePicker("", selection: $viewmodel.selectedEndDate, displayedComponents: .hourAndMinute)
                                .applyTextColor(Constants.optionTextColor)
                        }
                    }
                    .padding(.vertical)
                    
                    if viewmodel.selectedPeriod != .oneTime {
                        Divider()
                            .background(Color.Neutral.tone70)
                        
                        VStack {
                            Toggle("Expiration", isOn: $viewmodel.doesExpyre)
                                .toggleStyle(.switch)
                                .foregroundColor(Constants.labelTextColor)
                                .tint(Color.Yellow.light100)
                            
                            
                            if viewmodel.doesExpyre {
                                HStack {
                                    Text("Set the date that finishes this event")
                                        .font(.caption)
                                        .foregroundColor(Constants.labelTextColor)
                                    
                                    DatePicker("", selection: $viewmodel.selectedExpirationDate, displayedComponents: .date)
                                        .applyTextColor(Constants.optionTextColor)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .padding()
            }
            
            Spacer()
            HStack(spacing: 16) {
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
                        viewmodel.saveAvailability()
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

extension View {
  @ViewBuilder func applyTextColor(_ color: Color) -> some View {
    if UITraitCollection.current.userInterfaceStyle == .light {
      self.colorInvert().colorMultiply(color)
    } else {
      self.colorMultiply(color)
    }
  }
}
