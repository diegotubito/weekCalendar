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
                .background(Color.clear)
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
                                        endTime: "2000-01-04T07:30:00.000Z",
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
            let startTime = availability.startTime.toDate()
            let endTime = availability.endTime.toDate()
            let components = Calendar.current.dateComponents([.day], from: startTime!, to: endTime!)
            let days = components.day!
            
            for index in 0..<(days + 1) {
                let dayofweek = availability.dayOfWeek + index
                var startTime = Calendar.current.date(byAdding: .day, value: index, to: availability.startTime.toDate()!)?.toString(format: "yyyy-MM-dd'T'HH:mm:ss.sssZ")
                
                var endTime = availability.endTime
                if index != 0 {
                    let nextDate = Calendar.current.date(byAdding: .day, value: index, to: availability.startTime.toDate()!)!
                    let components = Calendar.current.dateComponents([.year, .month, .day], from: nextDate)
                    let newStartTime = Calendar.current.date(from: components)!
                    startTime = newStartTime.toString(format: "yyyy-MM-dd'T'HH:mm:ss.sssZ")
                    
                    if index == days {
                        endTime = availability.endTime
                    } else {
                        let lastHour = Calendar.current.date(byAdding: .hour, value: 23, to: nextDate)!
                        endTime = lastHour.toString(format: "yyyy-MM-dd'T'HH:mm:ss.sssZ")
                    }
                    
                }
                let newCapsule = SchedulerModel(availabilityId: availability._id,
                                                dayOfWeek: dayofweek,
                                                startTime: startTime!,
                                                endTime: endTime,
                                                backgroundColor: .green)
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
