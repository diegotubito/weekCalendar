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
        static let calendarHeight: CGFloat = 70
        static let hourWidht: CGFloat = 50
        static let boxWidth: CGFloat = 70
        static let boxHeight: CGFloat = 40
        static let spacing: CGFloat = 1
    }
    
    @State var capsules: [SchedulerModel] = [] {
        didSet {
            print(capsules.count)
        }
    }
    var initialDate: Date
    @State var days: Int
    var availabilities: [Availability]
    var onCapsuleTapped: (SchedulerModel) -> Void
    var onEmptyHourTapped: (Int, Int, Date) -> Void


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
                    VStack {
                        Spacer()
                            .frame(height: Constants.calendarHeight)
                        WeekSchedulerHourView(hourWidth: Constants.hourWidht, hourHeight: Constants.boxHeight, spacing: Constants.spacing)
                    }
                    
                    ScrollView(.horizontal) {
                        VStack(spacing: Constants.spacing) {
                            WeekCalendarView(initialDate: initialDate, selectedDate: Date(), maxDays: days, isSelectable: false, spacing: Constants.spacing, columnWidth: Constants.boxWidth, height: Constants.calendarHeight) { selectedDate in
                                print(selectedDate)
                            } onVisibleDates: { visibleDates in
                            }
                            
                            VStack(spacing: Constants.spacing) {
                                ForEach(0..<Constants.rows, id: \.self) { rowIndex in
                                    HStack(spacing: Constants.spacing) {
                                        ForEach(0..<days, id: \.self) { columnIndex in
                                            Color.gray.opacity(0.25)
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
                                ForEach(capsules, id: \.self) { capsuleItem in
                                    VStack(spacing: 0) {
                                        if capsuleItem.columnType == .inner || capsuleItem.columnType == .tail {
                                            HStack {
                                                Text("⤵")
                                                Spacer()
                                            }
                                        }
                                        HStack {
                                            Text(getStartTime(stringDate: capsuleItem.startDate))
                                                .font(.system(size: 10))
                                                .padding(.horizontal, 4)
                                                .foregroundColor(.white.opacity(0.5))
                                            Spacer()
                                        }
                                        Spacer()
                                        HStack {
                                            //Text(getEndTime())
                                            //    .font(.system(size: 11))
                                            //    .padding(.horizontal, 4)
                                            //Spacer()
                                        }
                                        if capsuleItem.columnType == .inner || capsuleItem.columnType == .head {
                                            HStack {
                                                Spacer()
                                                Text("⤴")
                                            }
                                        }
                                    }
                                        .frame(width: Constants.boxWidth, height: getItemHeight(item: capsuleItem))
                                        .background(capsuleItem.backgroundColor)
                                        .position(x: getPositionX(item: capsuleItem), y: getPosition(item: capsuleItem))
                                        .onTapGesture {
                                            onCapsuleTapped(capsuleItem)
                                        }
                                       
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            generateItems(availabilities: availabilities)
        }
        
    }
    
    func getStartTime(stringDate: String) -> String {
        stringDate.showTimeFormat()
    }
    
    func getEndTime(stringDate: String) -> String {
        stringDate.showTimeFormat()
    }
        
    private func getContainerWidht() -> CGFloat {
        (CGFloat(days) * Constants.boxWidth) + (CGFloat(days - 1) * Constants.spacing)
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
                for index in 0..<days / dailyConstant {
                    let fromDate = availability.startDate.toDate()!
                    let correctFromDate = Calendar.current.date(byAdding: .day, value: dailyConstant * index, to: fromDate)
                    let toDate = availability.endDate.toDate()!
                    let correctToDate = Calendar.current.date(byAdding: .day, value: dailyConstant * index, to: toDate)
                    capsules.append(contentsOf: addSingleItem(fromDate: correctFromDate!, toDate: correctToDate!, availability: availability))
                }
                break
            case .monthly:
                let monthlyConstant = 1 // month
                let iteration = (days / 30) + 1
                
                for index in 0..<iteration {
                    let fromDate = availability.startDate.toDate()!
                    let correctFromDate = Calendar.current.date(byAdding: .month, value: monthlyConstant * index, to: fromDate)
                    let toDate = availability.endDate.toDate()!
                    let correctToDate = Calendar.current.date(byAdding: .month, value: monthlyConstant * index, to: toDate)
                    capsules.append(contentsOf: addSingleItem(fromDate: correctFromDate!, toDate: correctToDate!, availability: availability))
                }
            case .weekly:
                let weeklyConstant = 7
                for index in 0..<days / weeklyConstant {
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
        guard let daysCounter = components.day else { return [] }
        let lastDate = Calendar.current.date(byAdding: .day, value: days, to: initialDate)!

        let format = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        var result: [SchedulerModel] = []
        
        for index in 0..<(daysCounter + 1) {
            guard let startTimeDate = Calendar.current.date(byAdding: .day, value: index, to: fromDate) else { break }
           
            if startTimeDate >= lastDate { // this is to avoid creating more capsules than the calendar screen width can support.
                return []
            }
           
            var startDate = startTimeDate.toString(format: format)
            var endDate = toDate.toString(format: format)
            
            var columnType: SchedulerModel.ColumnType = .none
            
            if daysCounter > 0 {
                if index != 0 {
                    let startOfDay = startTimeDate.startOfDay()
                    startDate = startOfDay.toString(format: format)
                    
                    if index == daysCounter {
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
                                           period: .weekly,
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
