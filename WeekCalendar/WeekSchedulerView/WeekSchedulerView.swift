//
//  WeekScheduler.swift
//  WeekCalendar
//
//  Created by David Gomez on 21/06/2023.
//

import SwiftUI

struct SchedulerModel: Hashable {
    let availabilityId: String
    let period: SchedulerPeriod
    let capacity: Int
    let startDate: String
    let endDate: String
    let backgroundColor: Color
    let columnType: ColumnType
    
    enum ColumnType {
        case none
        case head
        case inner
        case tail
    }
}

enum SchedulerPeriod: String, Decodable {
    case none
    case daily
    case weekly
    case monthly
}


enum SheetType {
    case edit
    case new
    case none
}

struct WeekSchedulerView: View {
    @State var openSheet: SheetType = .none
    @State var isShowingSheet = false

    struct Constants {
        static let capsuleProportionalWidth: CGFloat = 0.95
        static let calendarHeight: CGFloat = 70
        static let hourWidht: CGFloat = 50
        static let boxWidth: CGFloat = 70
        static let boxHeight: CGFloat = 40
        static let spacing: CGFloat = 1
    }

    @ObservedObject var viewmodel: WeekSchedulerViewModel

   
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                HStack(spacing: 0) {
                    VStack {
                        Spacer()
                            .frame(height: Constants.calendarHeight)
                        WeekSchedulerHourView(startHour: viewmodel.startHour,
                                              endHour: viewmodel.endHour,
                                              hourWidth: Constants.hourWidht,
                                              hourHeight: Constants.boxHeight,
                                              spacing: Constants.spacing)
                    }
                    
                    ScrollView(.horizontal) {
                        VStack(spacing: Constants.spacing) {
                            WeekCalendarView(initialDate: viewmodel.initialDate,
                                             selectedDate: Date(),
                                             maxDays: viewmodel.days,
                                             isSelectable: false,
                                             spacing: Constants.spacing,
                                             columnWidth: Constants.boxWidth,
                                             height: Constants.calendarHeight) { selectedDate in } onVisibleDates: { visibleDates in }
                            
                            VStack(spacing: Constants.spacing) {
                                ForEach(0..<(viewmodel.endHour - viewmodel.startHour + 1), id: \.self) { rowIndex in
                                    HStack(spacing: Constants.spacing) {
                                        ForEach(0..<viewmodel.days, id: \.self) { columnIndex in
                                            Color.gray.opacity(0.25)
                                                .frame(width: Constants.boxWidth, height: Constants.boxHeight)
                                                .onTapGesture {
                                                    if let tappedDate = Calendar.current.date(byAdding: .day, value: columnIndex, to: viewmodel.initialDate),
                                                       let tappedDateAndTime = Calendar.current.date(byAdding: .hour, value: rowIndex + viewmodel.startHour, to: tappedDate) {
                                                        let newAvailability = viewmodel.createNewAvailability(date: tappedDateAndTime)
                                                        viewmodel.availabilities.append(newAvailability)
                                                        let newCapsules = viewmodel.capsules.filter({$0.availabilityId == newAvailability._id})
                                                        viewmodel.selectedCapsules = newCapsules
                                                        
                                                        
                                                        openSheet = .new
                                                        isShowingSheet = true

                                                    }
                                                }
                                        }
                                    }
                                }
                            }.overlay {
                                ForEach(viewmodel.capsules, id: \.self) { capsuleItem in
                                    if let yPosition = getPositionY(item: capsuleItem) {
                                        WeekSchedulerCapsuleView(capsule: capsuleItem, selectedCapsules: viewmodel.selectedCapsules)
                                            .frame(width: Constants.boxWidth * Constants.capsuleProportionalWidth, height: getItemHeight(item: capsuleItem))
                                            .cornerRadius(5)
                                            .position(x: getPositionX(item: capsuleItem), y: yPosition)
                                            .onTapGesture {
                                                
                                                viewmodel.selectAllSameId(capsule: capsuleItem)
                                                
                                                if let availabilityTapped = viewmodel.availabilities.filter({$0._id == capsuleItem.availabilityId}).first {
                                                    
                                                    if viewmodel.selectedCapsules.contains(where: {$0.availabilityId == availabilityTapped._id}) {
                                                        
                                                        openSheet = .edit
                                                        isShowingSheet = true

                                                    }
                                                }
                                               

                                            }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewmodel.loadAvailabilities()
        }
        .sheet(isPresented: $isShowingSheet) {
            if openSheet == .edit {
                Color.gray.opacity(0.6)
                Text("Edit or Delete current availability")
                    .foregroundColor(.black)
                    .presentationDetents([.medium, .fraction(0.8)])
                
            } else if openSheet == .new {
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
    
   
    
    private func getContainerWidht() -> CGFloat {
        (CGFloat(viewmodel.days) * Constants.boxWidth) + (CGFloat(viewmodel.days - 1) * Constants.spacing)
    }
    
    func getItemHeight(item: SchedulerModel) -> CGFloat {
        let timeInterval = getTimeInterval(item: item)
        
        return timeInterval * (Constants.boxHeight) + (timeInterval * Constants.spacing) - (Constants.spacing * 2)
    }
    
    func getZeroPosition(item: SchedulerModel) -> CGFloat {
        return (getItemHeight(item: item) / 2) + (Constants.spacing / 2)
    }
    
    func getPositionY(item: SchedulerModel) -> CGFloat? {
        let startingHour = getStartingHour(item: item) - CGFloat(viewmodel.startHour)
        if startingHour < 0 { return nil }
        let zeroPosition = getZeroPosition(item: item)
        let finalPosition = zeroPosition + (Constants.boxHeight * startingHour) + (startingHour * Constants.spacing)
        
        return finalPosition
    }
    
    func getPositionX(item: SchedulerModel) -> CGFloat {
        let diff = getDayDifference(date1: viewmodel.initialDate, date2: item.startDate.toDate()!)
        let index: CGFloat = CGFloat(diff)
        let zeroPosition = Constants.boxWidth / 2
        let spacingOffset = Constants.spacing * index
        let result = zeroPosition + (Constants.boxWidth * index) + spacingOffset
        return result
    }
    
    func getTimeInterval(item: SchedulerModel) -> CGFloat {
        let startTimeString = item.startDate
        let endTimeString = item.endDate
        
        guard let startTime = startTimeString.toDate()?.timeIntervalSince1970,
              let endTime = endTimeString.toDate()?.timeIntervalSince1970 else { return 0 }
        
        let difference = endTime - startTime
        let hour = difference / 3600
        
        return hour
    }
    
    func getDayDifference(date1: Date, date2: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: date1, to: date2)
        guard let days = components.day else { return 0 }
        
        return days
    }
    
    func getStartingHour(item: SchedulerModel) -> CGFloat {
        let startTimeString = item.startDate
        guard let startTime = startTimeString.toDate(),
              let hour = Float(startTime.toString(format: "HH")),
              let minutes = Float(startTime.toString(format: "mm")) else { return 0 }
        
        let a = minutes / 60
        
        return CGFloat(hour + a)
    }
    
    func numberOfDaysBetweenDates(date1: Date, date2: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day
    }
    
   
}
