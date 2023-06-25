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
        VStack {
            Spacer()
                .frame(height: viewmodel.calendarHeight)
            WeekSchedulerHourView(startHour: viewmodel.startHour,
                                  endHour: viewmodel.endHour,
                                  hourWidth: viewmodel.boxWidth,
                                  hourHeight: viewmodel.boxHeight,
                                  spacing: viewmodel.spacing)
        }
    }
    
    var CalendarView: some View {
        WeekCalendarView(initialDate: viewmodel.initialDate,
                         selectedDate: Date(),
                         maxDays: viewmodel.days,
                         isSelectable: false,
                         spacing: viewmodel.spacing,
                         columnWidth: viewmodel.boxWidth,
                         height: viewmodel.calendarHeight) { selectedDate in } onVisibleDates: { visibleDates in }
    }
    
    var RowsAndColumns: some View {
        ForEach(0..<(viewmodel.endHour - viewmodel.startHour + 1), id: \.self) { rowIndex in
            HStack(spacing: viewmodel.spacing) {
                ForEach(0..<viewmodel.days, id: \.self) { columnIndex in
                    Color.gray.opacity(0.25)
                        .frame(width: viewmodel.boxWidth, height: viewmodel.boxHeight)
                        .onTapGesture {
                            if let tappedDate = Calendar.current.date(byAdding: .day, value: columnIndex, to: viewmodel.initialDate),
                               let tappedDateAndTime = Calendar.current.date(byAdding: .hour, value: rowIndex + viewmodel.startHour, to: tappedDate) {
                                let newAvailability = viewmodel.createNewAvailability(date: tappedDateAndTime)
                                viewmodel.availabilities.append(newAvailability)
                                let newCapsules = viewmodel.capsules.filter({$0.availabilityId == newAvailability._id})
                                viewmodel.selectedCapsules = newCapsules
                                
                                
                                viewmodel.openSheet = .new
                                viewmodel.isShowingSheet = true
                                
                            }
                        }
                }
            }
        }
    }
    
    var Capsules: some View {
        ForEach(viewmodel.capsules, id: \.self) { capsuleItem in
            if let yPosition = viewmodel.getPositionY(item: capsuleItem) {
                WeekSchedulerCapsuleView(capsule: capsuleItem, selectedCapsules: viewmodel.selectedCapsules)
                    .frame(width: viewmodel.boxWidth * Constants.capsuleProportionalWidth, height: viewmodel.getItemHeight(item: capsuleItem))
                    .cornerRadius(5)
                    .position(x: viewmodel.getPositionX(item: capsuleItem), y: yPosition)
                    .onTapGesture {
                        
                        viewmodel.selectAllSameId(capsule: capsuleItem)
                        
                        if let availabilityTapped = viewmodel.availabilities.filter({$0._id == capsuleItem.availabilityId}).first {
                            
                            if viewmodel.selectedCapsules.contains(where: {$0.availabilityId == availabilityTapped._id}) {
                                
                                viewmodel.openSheet = .edit
                                viewmodel.isShowingSheet = true
                                
                            }
                        }
                    }
            }
        }
    }
    
    @State private var verticalOffset: CGFloat = 0.0
    @State private var horizontalOffset: CGFloat = 0.0
    
    var body: some View {
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
        .onAppear {
            viewmodel.loadAvailabilities()
        }
        .sheet(isPresented: $viewmodel.isShowingSheet) {
            if viewmodel.openSheet == .edit {
                Color.gray.opacity(0.6)
                Text("Edit or Delete current availability")
                    .foregroundColor(.black)
                    .presentationDetents([.medium, .fraction(0.8)])
                
            } else if viewmodel.openSheet == .new {
                if let capsuleToCancel = viewmodel.selectedCapsules.first {
                    CreateAvailabilitySheet(capsule: capsuleToCancel, onSuccess: { newAvailability in
                        
                    }, onCancel: {capsule in
                        viewmodel.availabilities.removeAll(where: {$0._id == capsule.availabilityId})
                        
                    })
                    .presentationDetents([.medium, .fraction(0.8)])
                }
            }
        }
    }
}
