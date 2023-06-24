//
//  ContentView.swift
//  WeekCalendar
//
//  Created by David Gomez on 18/06/2023.
//

import SwiftUI

struct ContentView: View {
    var currentDate = Date()
    @State var assignments: [Assignment] = []
    @State var availabilities: [Availability] = []
    
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
        WeekSchedulerView(initialDate: currentDate, days: 14, startHour: 7, endHour: 22, availabilities: loadAvailabilities()) { capsule in
            print(capsule)
        } onEmptyHourTapped: { (row, column, date) in
            print(row, column, date)
    
        }
    }
    
    func getNearSunday(date: Date) -> Date {
        let weekDay = Calendar.current.component(.weekday, from: date)
       
        guard let fromDate = Calendar.current.date(byAdding: .day, value: -(weekDay - 1), to: date) else { return Date() }
        return fromDate
      
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
                                         period: .none,
                                         capacity: 33,
                                         startDate: "2023-06-13T09:00:00.000Z",
                                         endDate: "2023-06-13T10:00:00.000Z",
                                         service: "",
                                         isEnabled: true,
                                         priceAdjustmentPercentage: 10,
                                         createdAt: "",
                                         updatedAt: "")
        
        let availability3 = Availability(_id: "1110",
                                         period: .none,
                                         capacity: 33,
                                         startDate: "2023-06-14T22:00:00.000Z",
                                         endDate: "2023-06-14T23:30:00.000Z",
                                         service: "",
                                         isEnabled: true,
                                         priceAdjustmentPercentage: 10,
                                         createdAt: "",
                                         updatedAt: "")
        
        
        return [availability2, availability3]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Availability: Decodable, Hashable {
    let _id: String
    let period: WeekSchedulerView.SchedulerPeriod
    let capacity: Int
    let startDate: String
    let endDate: String
    let service: String
    let isEnabled: Bool
    let priceAdjustmentPercentage: Int
    let createdAt: String
    let updatedAt: String
}

struct Assignment: Decodable, Hashable {
    let _id: String
    let availability: Availability
    let status: String
    let startDate: String
    let amount: Double
    let createdAt: String
    let updatedAt: String
    let expiration: Expiration?
    
    struct Expiration: Decodable, Hashable {
        let _id: String
        let duration: Int
        let startDate: String?
    }
}

enum AssignmentStatus: String {
    case userPending
    case ownerAccepted
    case ownerRejected
    case userScheduled
    case userCancelled
}
