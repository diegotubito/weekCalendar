//
//  WeekScheduler.swift
//  WeekCalendar
//
//  Created by David Gomez on 21/06/2023.
//

import SwiftUI

struct WeekSchedulerView: View {
    struct Constants {
        static let rows: Int = 24
        
        static let boxWidth: CGFloat = 50
        static let boxHeight: CGFloat = 50
        static let spacing: CGFloat = 1
        static let refreshPositionX: CGFloat = 0.9 /// porcentage of the whole scroll content view that we should starting adding more columns for infinite columns.
    }
    
    @State var capsules: [SchedulerModel] = [] {
        didSet {
            print(capsules.count)
        }
    }
    var initialDate: Date
    var onCapsuleTapped: (SchedulerModel) -> Void
    var onEmptyHourTapped: (Int, Int, Date) -> Void

    @State var columns: Int = 14

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
    
    
  
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                HStack(spacing: 0) {
                    SchedulerHourView()
                    ScrollView(.horizontal) {
                        VStack(spacing: Constants.spacing) {
                            WeekCalendarView(initialDate: initialDate, selectedDate: Date(), maxDays: columns, isSelectable: false, spacing: Constants.spacing, columnWidth: Constants.boxWidth) { selectedDate in
                                print(selectedDate)
                            } onVisibleDates: { visibleDates in
                            }
                            
                            VStack(spacing: Constants.spacing) {
                                ForEach(0..<Constants.rows, id: \.self) { rowIndex in
                                    HStack(spacing: Constants.spacing) {
                                        ForEach(0..<columns, id: \.self) { columnIndex in
                                            Color.yellow
                                                .frame(width: Constants.boxWidth, height: Constants.boxHeight)
                                                .onTapGesture {
                                                    if let tappedDate = Calendar.current.date(byAdding: .day, value: columnIndex, to: initialDate),
                                                       let addTime = Calendar.current.date(byAdding: .hour, value: rowIndex, to: tappedDate) {
                                                        onEmptyHourTapped(rowIndex, columnIndex, addTime)
                                                        createNewAvailability(date: addTime)
                                                    }
                                                }
                                        }
                                    }
                                }
                            }.overlay {
                                ForEach(capsules, id: \.self) { capsule in
                                    WeekSchedulerBoxView()
                                        .frame(width: Constants.boxWidth, height: getItemHeight(item: capsule))
                                        .background(.blue)
                                        .position(x: getPositionX(item: capsule), y: getPosition(item: capsule))
                                        .onTapGesture {
                                            onCapsuleTapped(capsule)
                                        }
                                       
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            generateItems(availabilities: loadAvailabilities())
        }
        
    }
    
    struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGPoint = .zero
        
        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
    }
    
    func loadAvailabilities() -> [Availability] {
        
        let availability1 = Availability(_id: "1110",
                                         period: .daily,
                                         capacity: 33,
                                         startDate: "2023-06-12T06:00:00.000Z",
                                         endDate: "2023-06-12T07:00:00.000Z",
                                         service: "",
                                         isEnabled: true,
                                         priceAdjustmentPercentage: 10,
                                         createdAt: "",
                                         updatedAt: "")
        let availability2 = Availability(_id: "1110",
                                         period: .weekly,
                                         capacity: 33,
                                         startDate: "2023-06-13T09:00:00.000Z",
                                         endDate: "2023-06-13T10:00:00.000Z",
                                         service: "",
                                         isEnabled: true,
                                         priceAdjustmentPercentage: 10,
                                         createdAt: "",
                                         updatedAt: "")
        
        let availability3 = Availability(_id: "1110",
                                         period: .monthly,
                                         capacity: 33,
                                         startDate: "2023-06-14T16:00:00.000Z",
                                         endDate: "2023-06-15T17:30:00.000Z",
                                         service: "",
                                         isEnabled: true,
                                         priceAdjustmentPercentage: 10,
                                         createdAt: "",
                                         updatedAt: "")
        
        
        return [availability1, availability2, availability3]
    }
    
    private func getCurrentMaxXPosition(x: CGFloat, geometry: GeometryProxy) -> CGFloat {
        (abs(x) + geometry.size.width)
    }
    
    private func getCriticalWidth(geometry: GeometryProxy) -> CGFloat {
        let totalWidht = getContainerWidht()
        return totalWidht * Constants.refreshPositionX
    }
    
    private func getContainerWidht() -> CGFloat {
        (CGFloat(columns) * Constants.boxWidth) + (CGFloat(columns - 1) * Constants.spacing)
    }
    
    func getItemHeight(item: SchedulerModel) -> CGFloat {
        let timeInterval = getTimeInterval(item: item)
        
        return timeInterval * (Constants.boxHeight) + (timeInterval * Constants.spacing) - (Constants.spacing * 2)
    }
    
    func getZeroPosition(item: SchedulerModel) -> CGFloat {
        return (getItemHeight(item: item) / 2) + (Constants.spacing / 2)
    }
    
    func getPosition(item: SchedulerModel) -> CGFloat {
        let startingHour = getStartingHour(item: item)
        let zeroPosition = getZeroPosition(item: item)
        let finalPosition = zeroPosition + (Constants.boxHeight * startingHour) + (startingHour * Constants.spacing)
        
        return finalPosition
    }
    
    func getPositionX(item: SchedulerModel) -> CGFloat {
        let diff = getDayDifference(date1: initialDate, date2: item.startDate.toDate()!)
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
    
    func generateItems(availabilities: [Availability]) {
      //  capsules.removeAll()
        
        for availability in availabilities {
            switch availability.period {
            case .none:
                capsules.append(contentsOf: addSingleItem(fromDate: availability.startDate.toDate()!, toDate: availability.endDate.toDate()!, availability: availability))
            case .daily:
                let dailyConstant = 1
                for index in 0..<columns / dailyConstant {
                    let fromDate = availability.startDate.toDate()!
                    let correctFromDate = Calendar.current.date(byAdding: .day, value: dailyConstant * index, to: fromDate)
                    let toDate = availability.endDate.toDate()!
                    let correctToDate = Calendar.current.date(byAdding: .day, value: dailyConstant * index, to: toDate)
                    capsules.append(contentsOf: addSingleItem(fromDate: correctFromDate!, toDate: correctToDate!, availability: availability))
                }
                break
            case .monthly:
                let monthlyConstant = 1 // month
                let iteration = (columns / 30) + 1
                
                for index in 0..<iteration {
                    let fromDate = availability.startDate.toDate()!
                    let correctFromDate = Calendar.current.date(byAdding: .month, value: monthlyConstant * index, to: fromDate)
                    let toDate = availability.endDate.toDate()!
                    let correctToDate = Calendar.current.date(byAdding: .month, value: monthlyConstant * index, to: toDate)
                    capsules.append(contentsOf: addSingleItem(fromDate: correctFromDate!, toDate: correctToDate!, availability: availability))
                }
            case .weekly:
                let weeklyConstant = 7
                for index in 0..<columns / weeklyConstant {
                    let fromDate = availability.startDate.toDate()!
                    let correctFromDate = Calendar.current.date(byAdding: .day, value: weeklyConstant * index, to: fromDate)
                    let toDate = availability.endDate.toDate()!
                    let correctToDate = Calendar.current.date(byAdding: .day, value: weeklyConstant * index, to: toDate)
                    capsules.append(contentsOf: addSingleItem(fromDate: correctFromDate!, toDate: correctToDate!, availability: availability))
                }
            }
        }
    }
    
    func addSingleItem(fromDate: Date, toDate: Date, availability: Availability) -> [SchedulerModel] {
        
        let components = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        guard let days = components.day else { return [] }
        
        let format = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        var result: [SchedulerModel] = []
        
        for index in 0..<(days + 1) {
            guard let startTimeDate = Calendar.current.date(byAdding: .day, value: index, to: fromDate) else { break }
            
            var startDate = startTimeDate.toString(format: format)
            var endDate = toDate.toString(format: format)
            
            var columnType: SchedulerModel.ColumnType = .none
            
            if days > 0 {
                if index != 0 {
                    let startOfDay = startTimeDate.startOfDay()
                    startDate = startOfDay.toString(format: format)
                    
                    if index == days {
                        columnType = .tail
                        endDate = toDate.toString(format: format)
                    } else {
                        columnType = .inner
                        let endOfDay = startTimeDate.endOfDay()
                        endDate = endOfDay.toString(format: format)
                    }
                    
                } else {
                    columnType = .head
                    let endOfDay = startTimeDate.endOfDay()
                    endDate = endOfDay.toString(format: format)
                }
            }
            
            let newCapsule = SchedulerModel(availabilityId: availability._id,
                                            period: availability.period,
                                            capacity: availability.capacity,
                                            startDate: startDate,
                                            endDate: endDate,
                                            backgroundColor: Color.gray.opacity(0.15),
                                            columnType: columnType)
            result.append(newCapsule)
        }
        
        return result
    }
    
    func createNewAvailability(date: Date) {
        let format = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        
        let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: date)
        
        let newAvailability = Availability(_id: "003",
                                           period: .daily,
                                           capacity: 21,
                                           startDate: date.toString(format: format),
                                           endDate: (endDate?.toString(format: format))!,
                                           service: "",
                                           isEnabled: true,
                                           priceAdjustmentPercentage: 10,
                                           createdAt: "",
                                           updatedAt: "")
        generateItems(availabilities: [newAvailability])
    }
}
