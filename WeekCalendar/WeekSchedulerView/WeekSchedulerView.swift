//
//  WeekScheduler.swift
//  WeekCalendar
//
//  Created by David Gomez on 21/06/2023.
//

import SwiftUI


struct WeekSchedulerView: View {
    
    struct Constants {
        static let capsuleProportionalWidth: CGFloat = 0.95
    }
    
    @ObservedObject var viewmodel: WeekSchedulerViewModel
    @State private var sheetOffset: CGFloat = 0.0
    
    var HoursView: some View {
        VStack(spacing: viewmodel.spacing) {
            viewmodel.fixedBackgroundColor
                .frame(width: viewmodel.hourWidth, height: viewmodel.calendarHeight)
            WeekSchedulerHourView(startHour: viewmodel.startHour,
                                  endHour: viewmodel.endHour,
                                  hourWidth: viewmodel.hourWidth,
                                  hourHeight: viewmodel.boxHeight,
                                  spacing: viewmodel.spacing,
                                  fixedBackgroundColor: viewmodel.fixedBackgroundColor)
        }
        .offset(y: 4) // issue with this adjustment constant
       
    }
    
    var CalendarView: some View {
        WeekCalendarView(initialDate: viewmodel.initialDate,
                         selectedDate: Date(),
                         maxDays: viewmodel.days,
                         isSelectable: false,
                         spacing: viewmodel.spacing,
                         columnWidth: viewmodel.boxWidth,
                         height: viewmodel.calendarHeight,
                         fixedBackgroundColor: viewmodel.fixedBackgroundColor) { selectedDate in } onVisibleDates: { visibleDates in }
    }
    
    var RowsAndColumns: some View {
        ForEach(0..<(viewmodel.endHour - viewmodel.startHour + 1), id: \.self) { rowIndex in
            HStack(spacing: viewmodel.spacing) {
                ForEach(0..<viewmodel.days, id: \.self) { columnIndex in
                    viewmodel.dynamicBackgroundColor
                        .frame(width: viewmodel.boxWidth, height: viewmodel.boxHeight)
                        .onTapGesture {
                            if let tappedDate = Calendar.current.date(byAdding: .day, value: columnIndex, to: viewmodel.initialDate),
                               let tappedDateAndTime = Calendar.current.date(byAdding: .hour, value: rowIndex + viewmodel.startHour, to: tappedDate) {
                                let newAvailability = viewmodel.createNewAvailability(date: tappedDateAndTime)
                                let newCapsules = viewmodel.capsules.filter({$0.availabilityId == newAvailability._id})
                                viewmodel.selectedCapsules = newCapsules
                                
                                
                                viewmodel.sheetType = .new
                                viewmodel.isShowingSheet = true
                                
                            }
                        }
                }
            }
        }
    }
    
    var Capsules: some View {
        ForEach(viewmodel.capsules, id: \.self) { capsuleItem in
            WeekSchedulerCapsuleView(capsule: capsuleItem, selectedCapsules: viewmodel.selectedCapsules, backgroundColor: viewmodel.selectionBackgroundColor)
                .frame(width: viewmodel.boxWidth * Constants.capsuleProportionalWidth, height: viewmodel.getItemHeight(item: capsuleItem))
                .cornerRadius(5)
                .position(x: viewmodel.getPositionX(item: capsuleItem), y: viewmodel.getPositionY(item: capsuleItem))
                .onTapGesture {
                    viewmodel.selectAllCapsulesWithTheSameId(capsule: capsuleItem)
                    if let availabilityTapped = viewmodel.availabilities.filter({$0._id == capsuleItem.availabilityId}).first {
                        if viewmodel.selectedCapsules.contains(where: {$0.availabilityId == availabilityTapped._id}) {
                            viewmodel.sheetType = .edit
                            viewmodel.isShowingSheet = true
                        }
                    }
                }
        }
    }
    
    @State private var verticalOffset: CGFloat = 0.0
    @State private var horizontalOffset: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                
                OffsettableScrollView(axes: .vertical) { point in
                    verticalOffset = point.y
                    print(verticalOffset, proxy.size.height, viewmodel.getTotalHeight())
                    
                } content: {
                    HStack(spacing: viewmodel.spacing) {
                        HoursView
                        OffsettableScrollView(axes: .horizontal) { point in
                            horizontalOffset = point.x
                            print(horizontalOffset, proxy.size.width, viewmodel.getTotalWidth())
                        } content: {
                            VStack(spacing: viewmodel.spacing) {
                                CalendarView
                                VStack(spacing: viewmodel.spacing) {
                                    RowsAndColumns
                                }.overlay {
                                    Capsules
                                }
                            }
                        }
                    }
                }
            }
            
            if viewmodel.isLoading {
                ProgressView()
            }
        }
        
        .onAppear {
            Task {
                await viewmodel.loadAvailabilities()
            }
        }
        .sheet(isPresented: $viewmodel.isShowingSheet, onDismiss: {
            Task {
                await viewmodel.loadAvailabilities()
            }
        }) {
            if let selectedCapsule = viewmodel.selectedCapsules.first {
                
                AvailabilitySheetCreateUpdateDelete(viewmodel: AvailabilitySheetViewModel(item: viewmodel.item, type: viewmodel.sheetType, capsule: selectedCapsule)) { newAvailability in
                    if newAvailability == nil {
                        viewmodel.availabilities.removeLast()
                    }
                }
                .presentationDetents([.medium])
                .presentationBackground(.clear)
                .background(Color.Blue.midnight.opacity(0.8))

            }
            
        }
        .alert(isPresented: $viewmodel.showAlert) {
            Alert(title: Text(viewmodel.alertTitle), message: Text(viewmodel.alertMessage))
        }
    }
}
