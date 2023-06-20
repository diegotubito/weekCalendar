//
//  ContentView.swift
//  WeekCalendar
//
//  Created by David Gomez on 18/06/2023.
//

import SwiftUI

struct ContentView: View {
    var currentDate = Date()
    
    init(currentDate: Date = Date()) {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 2023
        dateComponents.month = 6
        dateComponents.day = 12

        if let particularDate = calendar.date(from: dateComponents) {
            self.currentDate = particularDate
        }
    }
    
    var body: some View {
        VStack {
            SchedulerView(items: generateItems(availabilities: loadAvailabilities()), initialDate: currentDate, maxColumn: 14)
                .background(Color.black)
        }
        .padding(8)
    }
    
    func getNearSunday(date: Date) -> Date {
        let weekDay = Calendar.current.component(.weekday, from: date)
       
        guard let fromDate = Calendar.current.date(byAdding: .day, value: -(weekDay - 1), to: date) else { return Date() }
        return fromDate
      
    }
    
    func loadAvailabilities() -> [Availability] {
    
        let availability = Availability(_id: "1110",
                                        dayOfWeek: 2,
                                        startTime: "2000-01-01T04:00:00.000Z",
                                        endTime: "2000-01-01T07:30:00.000Z",
                                        service: "",
                                        isEnabled: true,
                                        priceAdjustmentPercentage: 10,
                                        createdAt: "",
                                        updatedAt: "")
        
        return [availability]
    }
    
    func generateItems(availabilities: [Availability]) -> [SchedulerModel]{
        var result: [SchedulerModel] = []

        for availability in availabilities {
            guard let availabilityStartTime = availability.startTime.toDate(),
                  let endTime = availability.endTime.toDate() else { return [] }
            
            let components = Calendar.current.dateComponents([.day], from: availabilityStartTime, to: endTime)
            guard let days = components.day else { return [] }

            let format = "yyyy-MM-dd'T'HH:mm:ss.sssZ"

            for index in 0..<(days + 1) {
                guard let startTimeDate = Calendar.current.date(byAdding: .day, value: index, to: availabilityStartTime) else { break }
                
                var columnType: SchedulerModel.ColumnType = .none
                let dayofweek = availability.dayOfWeek + index
                var startTime = startTimeDate.toString(format: format)
                var endTime = availability.endTime

                if days > 0 {
                    if index != 0 {
                        let startOfDay = startTimeDate.startOfDay()
                        startTime = startOfDay.toString(format: format)
                        
                        if index == days {
                            columnType = .tail
                            endTime = availability.endTime
                        } else {
                            columnType = .inner
                            let endOfDay = startTimeDate.endOfDay()
                            endTime = endOfDay.toString(format: format)
                        }
                        
                    } else {
                        columnType = .head
                        let endOfDay = startTimeDate.endOfDay()
                        endTime = endOfDay.toString(format: format)
                    }
                }
                
                let newCapsule = SchedulerModel(availabilityId: availability._id,
                                                dayOfWeek: dayofweek,
                                                startTime: startTime,
                                                endTime: endTime,
                                                backgroundColor: Color.green,
                                                columnType: columnType)
                result.append(newCapsule)
            }
        }
        
        return result
    }
    
    func numberOfDaysBetweenDates(date1: Date, date2: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Availability: Decodable, Hashable {
    let _id: String
    let dayOfWeek: Int
    let startTime: String
    let endTime: String
    let service: String
    let isEnabled: Bool
    let priceAdjustmentPercentage: Int
    let createdAt: String
    let updatedAt: String
}
