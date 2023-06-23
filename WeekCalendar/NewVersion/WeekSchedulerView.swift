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
    
    @State var columns: Int = 100
    
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

    @State private var scrollPosition: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                ScrollView(.horizontal) {
                    ZStack {
                        VStack(spacing: Constants.spacing) {
                            ForEach(0..<Constants.rows, id: \.self) { rowIndex in
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: Constants.spacing) {
                                        ForEach(0..<columns, id: \.self) { columnIndex in
                                            WeekSchedulerBoxView()
                                                .frame(width: Constants.boxWidth, height: Constants.boxHeight)
                                            //   .background(.yellow)
                                                .background(GeometryReader { geometry in
                                                    ZStack {
                                                        Text("\(Int(geometry.size.width))")
                                                            .font(.system(size: 12))
                                                        Color.clear
                                                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                                                        
                                                    }
                                                })
                                                
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                        ForEach(capsules, id: \.self) { capsule in
                            WeekSchedulerBoxView()
                                .frame(width: Constants.boxWidth, height: getItemHeight(item: capsule))
                                .background(.blue)
                                .position(x: getPositionX(item: capsule), y: getPosition(item: capsule))
                        }
                    }
                   
                   
                }
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.scrollPosition = value
                print(value)
                if getCurrentMaxXPosition(x: value.x, geometry: geometry) > getCriticalWidth(geometry: geometry) {
                    print("critical", getCriticalWidth(geometry: geometry))
                   // columns = columns + 7
                   // generateItems()
                }
            }
        }
        .onAppear {
            generateItems()
        }
        
    }

    struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGPoint = .zero

        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        }
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
    
    func generateItems() {
        capsules.removeAll()
        
        let availabilities = loadAvailabilities()
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
    
}
